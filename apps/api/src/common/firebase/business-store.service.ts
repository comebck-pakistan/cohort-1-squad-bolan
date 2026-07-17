import { Injectable } from '@nestjs/common';
import { CollectionReference, DocumentData } from 'firebase-admin/firestore';
import { FirebaseAdminService } from './firebase-admin.service';

@Injectable()
export class BusinessStoreService {
  constructor(private readonly firebase: FirebaseAdminService) {}

  collection(businessId: string, name: string): CollectionReference<DocumentData> {
    return this.firebase.firestore.collection('businesses').doc(businessId).collection(name);
  }
}
