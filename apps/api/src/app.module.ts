import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { FirebaseAdminService } from './common/firebase/firebase-admin.service';
import { FirebaseAuthGuard } from './common/firebase/firebase-auth.guard';

@Module({
  imports: [ConfigModule.forRoot({ isGlobal: true })],
  controllers: [AppController],
  providers: [FirebaseAdminService, { provide: APP_GUARD, useClass: FirebaseAuthGuard }],
})
export class AppModule {}
