import { Injectable, NotFoundException } from '@nestjs/common';
import { FieldValue } from 'firebase-admin/firestore';
import { CreateContactDto } from '../common/dto/api.dto';
import { BusinessStoreService } from '../common/firebase/business-store.service';

@Injectable()
export class ContactsService {
  constructor(private readonly store: BusinessStoreService) {}

  async create(businessId: string, dto: CreateContactDto): Promise<{ id: string }> {
    const ref = this.store.collection(businessId, 'contacts').doc();
    await ref.set({ ...dto, whatsappOptIn: dto.whatsappOptIn ?? false, createdAt: FieldValue.serverTimestamp(), updatedAt: FieldValue.serverTimestamp() });
    return { id: ref.id };
  }

  async list(businessId: string): Promise<Array<Record<string, unknown> & { id: string }>> {
    const snapshot = await this.store.collection(businessId, 'contacts').orderBy('name').get();
    return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
  }

  async get(businessId: string, id: string): Promise<Record<string, unknown> & { id: string }> {
    const snapshot = await this.store.collection(businessId, 'contacts').doc(id).get();
    if (!snapshot.exists) throw new NotFoundException('Contact not found.');
    return { id: snapshot.id, ...snapshot.data()! };
  }
}
