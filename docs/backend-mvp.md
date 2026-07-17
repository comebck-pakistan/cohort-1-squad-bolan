# Backend MVP API

All routes except `GET /v1/health` require a Firebase ID token. The token UID is
the tenant/business boundary; no client-supplied business ID is trusted.

## Workflow

1. `POST /v1/contacts` creates a customer with an E.164 phone number.
2. `POST /v1/uploads` stores a base64 JPEG, PNG, or PDF in private Firebase
   Storage and returns its SHA-256-deduplicated upload ID.
3. `POST /v1/invoice-extractions` runs Gemini's schema-constrained extraction.
   It creates a draft in `needs_review`; the model can never post a balance.
4. `POST /v1/invoices/approve` posts an approved invoice and an immutable
   positive ledger entry in one Firestore transaction.
5. `POST /v1/contacts/:id/payments` appends a negative ledger entry for any
   partial/full payment.
6. `POST /v1/contacts/:id/reminders/draft` returns a reviewed WhatsApp deep
   link. It does not send a message programmatically.

## Required environment

Set Firebase Admin credentials and `FIREBASE_STORAGE_BUCKET`. For extraction,
set `GEMINI_API_KEY`; optional `GEMINI_MODEL` defaults to `gemini-2.5-flash`.

## Core endpoints

- `GET|POST /v1/contacts`
- `GET|POST /v1/catalog-products`
- `POST /v1/uploads`
- `POST /v1/invoice-extractions`, `GET /v1/invoice-extractions/:id`
- `POST /v1/invoices/approve`
- `POST /v1/contacts/:id/payments`, `GET /v1/contacts/:id/ledger`
- `GET /v1/dashboard`
- `POST /v1/contacts/:id/reminders/draft`

Keep raw image files private. Audit events record invoice approvals and payment
entries. For a future WhatsApp Cloud API integration, add explicit opt-in,
approved-template metadata, webhook verification, and delivery-status storage.
