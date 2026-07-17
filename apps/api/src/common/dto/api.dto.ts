import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsDateString,
  IsEmail,
  IsIn,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Matches,
  Max,
  Min,
  ValidateNested,
} from 'class-validator';

export class CreateContactDto {
  @IsString()
  @IsNotEmpty()
  name!: string;

  @Matches(/^\+[1-9]\d{7,14}$/, { message: 'phone must be in E.164 format, e.g. +923001234567.' })
  phone!: string;

  @IsOptional()
  @IsEmail()
  email?: string;

  @IsOptional()
  whatsappOptIn?: boolean;
}

export class CreateCatalogProductDto {
  @IsString()
  @IsNotEmpty()
  name!: string;

  @IsOptional()
  @IsString()
  urduName?: string;

  @IsOptional()
  @IsString()
  sku?: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  aliases?: string[];
}

export class CreateUploadDto {
  @IsString()
  @IsIn(['image/jpeg', 'image/png', 'application/pdf'])
  contentType!: string;

  @IsString()
  @IsNotEmpty()
  base64!: string;

  @IsOptional()
  @IsString()
  filename?: string;
}

export class CreateExtractionDto {
  @IsString()
  uploadId!: string;
}

export class InvoiceItemDto {
  @IsString()
  @IsNotEmpty()
  name!: string;

  @IsNumber({ maxDecimalPlaces: 3 })
  @Min(0)
  quantity!: number;

  @IsNumber({ maxDecimalPlaces: 2 })
  @Min(0)
  unitPrice!: number;

  @IsNumber({ maxDecimalPlaces: 2 })
  @Min(0)
  lineTotal!: number;
}

export class ApproveInvoiceDto {
  @IsString()
  extractionId!: string;

  @IsString()
  contactId!: string;

  @IsOptional()
  @IsString()
  invoiceNumber?: string;

  @IsDateString()
  invoiceDate!: string;

  @IsOptional()
  @IsDateString()
  dueDate?: string;

  @IsNumber({ maxDecimalPlaces: 2 })
  @Min(0.01)
  total!: number;

  @IsArray()
  @ArrayMaxSize(100)
  @ValidateNested({ each: true })
  @Type(() => InvoiceItemDto)
  items!: InvoiceItemDto[];
}

export class CreatePaymentDto {
  @IsNumber({ maxDecimalPlaces: 2 })
  @Min(0.01)
  amount!: number;

  @IsOptional()
  @IsDateString()
  paidAt?: string;

  @IsOptional()
  @IsString()
  note?: string;
}

export class CreateReminderDraftDto {
  @IsOptional()
  @IsString()
  message?: string;
}
