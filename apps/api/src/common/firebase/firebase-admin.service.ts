import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { App, cert, getApps, initializeApp } from 'firebase-admin/app';
import { Auth, DecodedIdToken, getAuth } from 'firebase-admin/auth';

@Injectable()
export class FirebaseAdminService {
  private app?: App;

  constructor(private readonly config: ConfigService) {}

  async verifyIdToken(token: string): Promise<DecodedIdToken> {
    try {
      return await this.auth.verifyIdToken(token);
    } catch {
      throw new UnauthorizedException('Firebase ID token is invalid or expired.');
    }
  }

  private get auth(): Auth {
    if (!this.app) {
      this.app = getApps()[0] ?? initializeApp({
        credential: cert({
          projectId: this.required('FIREBASE_PROJECT_ID'),
          clientEmail: this.required('FIREBASE_CLIENT_EMAIL'),
          privateKey: this.required('FIREBASE_PRIVATE_KEY').replace(/\\n/g, '\n'),
        }),
      });
    }
    return getAuth(this.app);
  }

  private required(name: string): string {
    const value = this.config.get<string>(name);
    if (!value) throw new Error(`${name} must be configured before verifying Firebase tokens.`);
    return value;
  }
}
