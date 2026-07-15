import { CanActivate, ExecutionContext, Injectable, UnauthorizedException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { Request } from 'express';
import { FirebaseAdminService } from './firebase-admin.service';
import { IS_PUBLIC_KEY } from './public.decorator';

@Injectable()
export class FirebaseAuthGuard implements CanActivate {
  constructor(private readonly reflector: Reflector, private readonly firebaseAdmin: FirebaseAdminService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    if (this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [context.getHandler(), context.getClass()])) return true;
    const request = context
      .switchToHttp()
      .getRequest<Request & { user: Awaited<ReturnType<FirebaseAdminService['verifyIdToken']>> }>();
    request.user = await this.firebaseAdmin.verifyIdToken(this.bearerToken(request));
    return true;
  }

  private bearerToken(request: Request): string {
    const [scheme, token] = request.headers.authorization?.split(' ') ?? [];
    if (scheme !== 'Bearer' || !token) throw new UnauthorizedException('A Firebase bearer token is required.');
    return token;
  }
}
