import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { App, cert, getApps, initializeApp } from 'firebase-admin/app';
import { Auth, DecodedIdToken, getAuth } from 'firebase-admin/auth';
import { Firestore, getFirestore } from 'firebase-admin/firestore';
import { Storage, getStorage } from 'firebase-admin/storage';
import { S3Client, PutObjectCommand, GetObjectCommand } from '@aws-sdk/client-s3';
import { Readable } from 'stream';

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

  get firestore(): Firestore {
    return getFirestore(this.firebaseApp);
  }

  get storage(): Storage | any {
    const s3Bucket = this.config.get<string>('S3_BUCKET') ?? this.config.get<string>('BACKPLACE_S3_BUCKET');
    if (s3Bucket) {
      const s3 = new S3Client({
        region: this.config.get<string>('S3_REGION') ?? 'us-east-1',
        endpoint: this.config.get<string>('S3_ENDPOINT') ?? undefined,
        credentials: {
          accessKeyId: this.config.get<string>('S3_ACCESS_KEY_ID') ?? this.config.get<string>('BACKPLACE_S3_KEY'),
          secretAccessKey: this.config.get<string>('S3_SECRET_ACCESS_KEY') ?? this.config.get<string>('BACKPLACE_S3_SECRET'),
        },
        forcePathStyle: !!this.config.get<string>('S3_FORCE_PATH_STYLE') || false,
      } as any);
      const bucketName = s3Bucket;
      return {
        bucket: () => ({
          file: (key: string) => ({
            async save(bytes: Buffer, options?: any) {
              const params: any = {
                Bucket: bucketName,
                Key: key,
                Body: bytes,
                ContentType: options?.contentType,
              };
              if (options?.metadata) params.Metadata = options.metadata;
              if (options?.cacheControl || (options?.metadata && options.metadata.cacheControl)) params.CacheControl = options.cacheControl ?? options.metadata.cacheControl;
              await s3.send(new PutObjectCommand(params));
            },
            async download() {
              const res = await s3.send(new GetObjectCommand({ Bucket: bucketName, Key: key }));
              const body = res.Body as unknown;
              let buffer: Buffer;
              if (body instanceof Uint8Array) buffer = Buffer.from(body);
              else if (body instanceof Readable) buffer = await streamToBuffer(body as Readable);
              else if (typeof body === 'string') buffer = Buffer.from(body);
              else buffer = Buffer.from([]);
              return [buffer];
            },
          }),
        }),
      };
    }

    return getStorage(this.firebaseApp);
  }

  private get auth(): Auth {
    return getAuth(this.firebaseApp);
  }

  private get firebaseApp(): App {
    if (!this.app) {
      this.app = getApps()[0] ?? initializeApp({
        credential: cert({
          projectId: this.required('FIREBASE_PROJECT_ID'),
          clientEmail: this.required('FIREBASE_CLIENT_EMAIL'),
          privateKey: this.required('FIREBASE_PRIVATE_KEY').replace(/\\n/g, '\n'),
        }),
        storageBucket: this.config.get<string>('FIREBASE_STORAGE_BUCKET'),
      });
    }
    return this.app;
  }

  private required(name: string): string {
    const value = this.config.get<string>(name);
    if (!value) throw new Error(`${name} must be configured before verifying Firebase tokens.`);
    return value;
  }
}

async function streamToBuffer(stream: Readable): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    const chunks: Uint8Array[] = [];
    stream.on('data', (chunk) => chunks.push(typeof chunk === 'string' ? Buffer.from(chunk) : chunk));
    stream.on('end', () => resolve(Buffer.concat(chunks)));
    stream.on('error', reject);
  });
}
