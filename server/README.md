# HoME App Backend

Node.js, Express, Sequelize, MySQL, and Firebase Admin backend for the hostel management app.

## Setup

1. Install and start MySQL.

2. Create the database:

```sql
CREATE DATABASE home_app;
```

3. Install dependencies:

```bash
npm install
```

4. Copy the environment example:

```powershell
copy .env.example .env
```

5. Fill in MySQL values in `.env`.

For local development, keep:

```env
DEV_AUTH_ENABLED=true
```

6. Run the database scripts:

```sql
USE home_app;
source migrations/schema.sql;
source migrations/seed.sql;
```

7. Start the server:

```bash
npm start
```

## Main Routes

- `GET /health`
- `GET /api/users/me`
- `CRUD /api/users`
- `CRUD /api/hostels`
- `CRUD /api/rooms`
- `CRUD /api/storage-items`

## Auth

Local development accepts:

```http
Authorization: Bearer dev:admin
```

Production should disable `DEV_AUTH_ENABLED` and use Firebase ID tokens:

```http
Authorization: Bearer <firebase-id-token>
```
