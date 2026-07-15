# Development

## Repository layout

```text
apps/
  api/       NestJS API; Firebase Admin verifies client ID tokens.
  mobile/    Flutter application; Firebase Authentication signs users in.
docs/        Product and engineering documentation.
research/    Discovery and OCR research.
```

## Prerequisites

- Node.js 22+ and pnpm 10+
- Flutter 3.38+ and a configured Android/iOS simulator or device
- A Firebase project with Email/Password and/or Phone authentication enabled

## API

```bash
cp .env.example apps/api/.env
pnpm install
pnpm api:dev
```

The API listens on `http://localhost:3000/v1`. `GET /v1/health` is public. All
other routes require `Authorization: Bearer <Firebase ID token>` and are
verified server-side with Firebase Admin.

Never commit a Firebase service-account key. Use a secret manager in deployed
environments and environment variables only for local development.

## Mobile

```bash
cd apps/mobile
flutterfire configure
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/v1
```

`flutterfire configure` creates the generated Firebase configuration and adds
the platform files required by Firebase. For an Android emulator use
`10.0.2.2`; use your machine's LAN address on a physical device.

## Architecture rules

- Mobile code is feature-first: `core/` holds cross-cutting infrastructure,
  while each feature owns `data`, `domain`, and `presentation` layers.
- The API is modular: controllers handle HTTP, services hold use cases, and
  infrastructure (such as Firebase Admin) stays in `common/`.
- The mobile app obtains a Firebase ID token; it never holds a service-account
  credential. The backend is the sole verifier of the token.
- Financial writes must be explicit, validated, and audited; do not use an LLM
  to calculate or post ledger balances.
