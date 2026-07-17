import { Body, Controller, Get, Post } from '@nestjs/common';
import { DecodedIdToken } from 'firebase-admin/auth';
import { CreateContactDto } from '../common/dto/api.dto';
import { CurrentUser } from '../common/firebase/current-user.decorator';
import { ContactsService } from './contacts.service';

@Controller('contacts')
export class ContactsController {
  constructor(private readonly contacts: ContactsService) {}

  @Get()
  list(@CurrentUser() user: DecodedIdToken) { return this.contacts.list(user.uid); }

  @Post()
  create(@CurrentUser() user: DecodedIdToken, @Body() dto: CreateContactDto) { return this.contacts.create(user.uid, dto); }
}
