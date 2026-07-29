# HoME inspection API

Express, MySQL, Firebase Auth, and Cloudinary backend for the room handover workflow.

## Setup

1. Run `npm install` in this directory.
2. Copy `.env.example` to `.env` and supply database, Firebase, and Cloudinary values.
3. Create a fresh database with `migrations/schema.sql`.
4. Start the API with `npm run dev`.

All API endpoints require a Firebase ID token:

```http
Authorization: Bearer <firebase-id-token>
```

## Inspection API

- `GET /api/hostels/code/:hostelCode` - resolve the hostel used at login.
- `GET /api/rooms?hostelId=:hostelId` - list room numbers for that hostel.
- `GET /api/inspections/room/:roomId` - room inspection history, including students and media.
- `GET /api/inspections/:id` - one complete inspection record.
- `POST /api/inspections/upload-signature` - generate a short-lived signed Cloudinary upload request.
- `POST /api/inspections` - create a handover inspection after uploads complete.

First request an upload signature with `{ "resourceType": "image" }` or `{ "resourceType": "video" }`. Upload the selected file directly to `https://api.cloudinary.com/v1_1/:cloudName/:resourceType/upload` using the returned `apiKey`, `timestamp`, `folder`, and `signature`. Keep Cloudinary's returned `secure_url`, `public_id`, and the local file MIME type.

`POST /api/inspections` accepts JSON with these fields:

- `roomId`, `inspectionType` (`check_in` or `check_out`), `inspectionDate`, and optional `comments`.
- `students`: JSON array of names, such as `["Aarav Sharma", "Meera Nair"]`.
- `conditions`: JSON object, such as `{"Ceiling fan":"Good","Light fixtures":"Fair","Study table":"Good"}`.
- `studentSignature` and `securitySignature`: signature data strings (typically PNG data URLs).
- `media`: Cloudinary records, for example `[{"mediaType":"photo","secureUrl":"https://...","publicId":"home-app/...","mimeType":"image/jpeg"}]`.

Cloudinary stores the photos and videos. The database stores their secure URLs and public IDs; student names, conditions, comments, and both signatures remain linked to the inspection record.
