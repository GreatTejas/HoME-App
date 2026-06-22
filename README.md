# HoME App

Flutter hostel management app with a Node.js/Express backend.

## What This Branch Adds

- A shared Flutter `ApiClient` for backend calls.
- API-backed hostel, room, add-room, add-hostel, room-detail, inspection-submit, and inspection-history flows.
- A local mock API server for quick frontend integration testing.
- Local dev auth support for the real Express backend using `Authorization: Bearer dev:admin`.
- MySQL seed data for testing the real backend.

## Quick Local Demo

Use this when you want to test the Flutter frontend without setting up MySQL:

```bash
node mock_server.js
flutter run -d chrome
```

Open the Flutter URL shown in the terminal, then log in with:

```text
User ID: admin
Password: anything
```

The password field is ignored in local demo mode.

## Real Backend Setup

The real backend lives in `server/` and uses Express, Sequelize, MySQL, and Firebase Admin.

1. Install and start MySQL.
2. Create the database:

```sql
CREATE DATABASE home_app;
```

3. Copy the example environment file:

```powershell
cd server
copy .env.example .env
```

4. Update `server/.env` if your MySQL user/password is different.

5. Install backend dependencies:

```bash
npm install
```

6. Run the schema and seed files in MySQL:

```sql
USE home_app;
source migrations/schema.sql;
source migrations/seed.sql;
```

7. Start the real backend:

```bash
npm start
```

8. Start Flutter:

```bash
flutter run -d chrome
```

## Auth Notes

For local development, `server/.env.example` enables:

```env
DEV_AUTH_ENABLED=true
```

That allows the Flutter login screen to use a token like:

```http
Authorization: Bearer dev:admin
```

For production, disable `DEV_AUTH_ENABLED` and configure Firebase service account credentials.

## Useful Routes

- `GET /health`
- `GET /api/users/me`
- `CRUD /api/hostels`
- `CRUD /api/rooms`
- `CRUD /api/storage-items`

## Important

Do not commit `server/.env`. Use `server/.env.example` as the shareable template.
