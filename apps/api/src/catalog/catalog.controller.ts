import { Body, Controller, Get, Post } from '@nestjs/common';
import { DecodedIdToken } from 'firebase-admin/auth';
import { CreateCatalogProductDto } from '../common/dto/api.dto';
import { CurrentUser } from '../common/firebase/current-user.decorator';
import { CatalogService } from './catalog.service';
@Controller('catalog-products')
export class CatalogController { constructor(private readonly catalog: CatalogService) {} @Get() list(@CurrentUser() user: DecodedIdToken) { return this.catalog.list(user.uid); } @Post() create(@CurrentUser() user: DecodedIdToken, @Body() dto: CreateCatalogProductDto) { return this.catalog.create(user.uid, dto); } }
