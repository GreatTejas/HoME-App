# HoME App Backend

Node.js, Express, Sequelize, MySQL, and Firebase Auth backend for the hostel management app.

## Setup

1. Install dependencies:

```bash
npm install
```

2. Copy the environment example:

```bash
cp .env.example .env
```

3. Fill in MySQL and Firebase values in `.env`.

4. Create the database tables using `migrations/schema.sql`.

5. Start the server:

```bash
npm run dev
```

## Main Routes

- `GET /health`
- `GET /api/users/me`
- `CRUD /api/users`
- `CRUD /api/hostels`
- `CRUD /api/rooms`
- `CRUD /api/storage-items`

All `/api/*` routes expect a Firebase ID token:

```http
Authorization: Bearer <firebase-id-token>
```
