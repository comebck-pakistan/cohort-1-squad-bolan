import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { FieldValue } from 'firebase-admin/firestore';
import { ApproveInvoiceDto, CreatePaymentDto } from '../common/dto/api.dto';
import { BusinessStoreService } from '../common/firebase/business-store.service';

@Injectable()
export class ReceivablesService {
  constructor(private readonly store: BusinessStoreService) {}

  async approveInvoice(businessId: string, actorId: string, dto: ApproveInvoiceDto): Promise<{ id: string }> {
    const db = this.store.collection(businessId, 'invoices').firestore;
    const extractionRef = this.store.collection(businessId, 'invoiceExtractions').doc(dto.extractionId);
    const contactRef = this.store.collection(businessId, 'contacts').doc(dto.contactId);
    const invoiceRef = this.store.collection(businessId, 'invoices').doc();
    const entryRef = this.store.collection(businessId, 'receivableEntries').doc();
    await db.runTransaction(async (transaction) => {
      const [extraction, contact] = await Promise.all([transaction.get(extractionRef), transaction.get(contactRef)]);
      if (!extraction.exists) throw new NotFoundException('Extraction not found.');
      if (extraction.data()!.status !== 'needs_review') throw new ConflictException('Only a draft awaiting review can be approved.');
      if (!contact.exists) throw new NotFoundException('Contact not found.');
      transaction.set(invoiceRef, { ...dto, status: 'approved', approvedBy: actorId, approvedAt: FieldValue.serverTimestamp(), createdAt: FieldValue.serverTimestamp() });
      transaction.set(entryRef, { type: 'invoice', invoiceId: invoiceRef.id, contactId: dto.contactId, signedAmount: dto.total, occurredAt: dto.invoiceDate, dueDate: dto.dueDate ?? null, createdBy: actorId, createdAt: FieldValue.serverTimestamp() });
      transaction.update(extractionRef, { status: 'approved', approvedInvoiceId: invoiceRef.id, approvedAt: FieldValue.serverTimestamp() });
    });
    await this.audit(businessId, actorId, 'invoice.approved', invoiceRef.id);
    return { id: invoiceRef.id };
  }

  async recordPayment(businessId: string, actorId: string, contactId: string, dto: CreatePaymentDto): Promise<{ id: string }> {
    const contact = await this.store.collection(businessId, 'contacts').doc(contactId).get();
    if (!contact.exists) throw new NotFoundException('Contact not found.');
    const ref = this.store.collection(businessId, 'receivableEntries').doc();
    await ref.set({ type: 'payment', contactId, signedAmount: -dto.amount, paidAt: dto.paidAt ?? new Date().toISOString(), note: dto.note ?? null, createdBy: actorId, createdAt: FieldValue.serverTimestamp() });
    await this.audit(businessId, actorId, 'payment.recorded', ref.id);
    return { id: ref.id };
  }

  async dashboard(businessId: string): Promise<{ outstandingTotal: number; overdueTotal: number; customerCount: number }> {
    const entries = await this.store.collection(businessId, 'receivableEntries').get();
    let outstandingTotal = 0;
    let overdueTotal = 0;
    const customers = new Set<string>();
    for (const doc of entries.docs) {
      const data = doc.data() as { signedAmount: number; contactId: string; type: string; dueDate?: string | null };
      outstandingTotal += data.signedAmount;
      customers.add(data.contactId);
      if (data.type === 'invoice' && data.dueDate && new Date(data.dueDate) < new Date()) overdueTotal += data.signedAmount;
    }
    return { outstandingTotal, overdueTotal, customerCount: customers.size };
  }

  async ledger(businessId: string, contactId: string): Promise<Array<Record<string, unknown> & { id: string }>> {
    const snapshot = await this.store.collection(businessId, 'receivableEntries').where('contactId', '==', contactId).get();
    const items = snapshot.docs.map((doc) => {
      const data = doc.data() as Record<string, any>;
      return { id: doc.id, ...data } as Record<string, any> & { id: string };
    });
    return items.sort((a, b) => String(a.createdAt ?? '').localeCompare(String(b.createdAt ?? '')));
  }

  private async audit(businessId: string, actorId: string, action: string, resourceId: string): Promise<void> {
    await this.store.collection(businessId, 'auditEvents').add({ actorId, action, resourceId, createdAt: FieldValue.serverTimestamp() });
  }
}
