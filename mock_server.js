// ================================================================
// MOCK SERVER — For testing frontend connection ONLY.
// This does NOT modify any backend code. Delete when real server runs.
//
// Usage:  node mock_server.js
// Then:   flutter run -d chrome
// ================================================================

const http = require('http');

const PORT = 5000;

// ── MOCK DATA (same as what the real backend would return) ─────────
const hostels = [
  {
    id: 1, name: 'Maple Residence', hostelCode: 'MR', gender: 'male',
    totalRooms: 20, totalStudents: 15, createdAt: new Date().toISOString(),
    warden: null,
    rooms: Array.from({ length: 20 }, (_, i) => ({
      id: i + 1, hostelId: 1, roomNumber: `${Math.floor(i / 10) + 1}${String(i % 10).padStart(2, '0')}`,
      roomType: 'standard', capacity: 2, occupancyCount: i < 15 ? 1 : 0,
    })),
  },
  {
    id: 2, name: 'Oak Hall', hostelCode: 'OH', gender: 'female',
    totalRooms: 10, totalStudents: 8, createdAt: new Date().toISOString(),
    warden: null,
    rooms: Array.from({ length: 10 }, (_, i) => ({
      id: 21 + i, hostelId: 2, roomNumber: `${Math.floor(i / 5) + 1}${String(i % 5).padStart(2, '0')}`,
      roomType: 'standard', capacity: 2, occupancyCount: i < 8 ? 1 : 0,
    })),
  },
  {
    id: 3, name: 'Cedar House', hostelCode: 'CH', gender: 'co-ed',
    totalRooms: 15, totalStudents: 12, createdAt: new Date().toISOString(),
    warden: null,
    rooms: Array.from({ length: 15 }, (_, i) => ({
      id: 31 + i, hostelId: 3, roomNumber: `${Math.floor(i / 5) + 1}${String(i % 5).padStart(2, '0')}`,
      roomType: i % 3 === 0 ? 'common' : 'standard', capacity: 2, occupancyCount: i < 12 ? 1 : 0,
    })),
  },
];

// Flatten all rooms for easy lookup
const allRooms = hostels.flatMap(h => h.rooms.map(r => ({ ...r, hostel: { id: h.id, name: h.name } })));

// Storage items (inspection records)
let storageItems = [
  { id: 1, roomId: 1, description: 'Ceiling Fan: Broken blade', photoUrl: null, belongsTo: 'inspection', takenByUserId: 'test', takenAt: new Date().toISOString() },
];
let nextStorageId = 2;
let nextRoomId = allRooms.length + 1;
let nextHostelId = hostels.length + 1;

// ── REQUEST HANDLER ───────────────────────────────────────────────
const server = http.createServer((req, res) => {
  // CORS headers (Flutter web needs these)
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    res.writeHead(204);
    res.end();
    return;
  }

  const url = new URL(req.url, `http://localhost:${PORT}`);
  const path = url.pathname;
  const method = req.method;

  // Collect POST/PUT body
  let body = '';
  req.on('data', chunk => { body += chunk; });
  req.on('end', () => {
    let parsed = {};
    try { parsed = body ? JSON.parse(body) : {}; } catch (e) {}

    console.log(`${method} ${path}`);

    // ── ROUTES ──────────────────────────────────────────────────

    // Health check
    if (path === '/health') {
      return json(res, { status: 'ok' });
    }

    if (method === 'GET' && path === '/api/users/me') {
      return json(res, {
        id: 'admin',
        name: 'Local Admin',
        email: 'admin@example.com',
        role: 'admin',
      });
    }

    // GET /api/hostels
    if (method === 'GET' && path === '/api/hostels') {
      return json(res, hostels);
    }

    // POST /api/hostels
    if (method === 'POST' && path === '/api/hostels') {
      const newHostel = {
        id: nextHostelId++,
        name: parsed.name || 'New Hostel',
        hostelCode: parsed.hostelCode || `H${nextHostelId}`,
        gender: parsed.gender || 'co-ed',
        totalRooms: 0,
        totalStudents: 0,
        createdAt: new Date().toISOString(),
        warden: null,
        rooms: [],
      };
      hostels.push(newHostel);
      return json(res, newHostel, 201);
    }

    // GET /api/hostels/:id
    const hostelMatch = path.match(/^\/api\/hostels\/(\d+)$/);
    if (method === 'GET' && hostelMatch) {
      const h = hostels.find(h => h.id === Number(hostelMatch[1]));
      return h ? json(res, h) : json(res, { message: 'Not found' }, 404);
    }

    // PUT /api/hostels/:id
    if (method === 'PUT' && hostelMatch) {
      const h = hostels.find(h => h.id === Number(hostelMatch[1]));
      if (h) {
        if (parsed.name) h.name = parsed.name;
        return json(res, h);
      }
      return json(res, { message: 'Not found' }, 404);
    }

    // GET /api/rooms  (optional ?hostelId=X)
    if (method === 'GET' && path === '/api/rooms') {
      const hostelId = url.searchParams.get('hostelId');
      let rooms = allRooms;
      if (hostelId) {
        rooms = rooms.filter(r => r.hostelId === Number(hostelId));
      }
      // Add storageItems to each room
      const withItems = rooms.map(r => ({
        ...r,
        storageItems: storageItems.filter(s => s.roomId === r.id),
      }));
      return json(res, withItems);
    }

    // GET /api/rooms/:id
    const roomMatch = path.match(/^\/api\/rooms\/(\d+)$/);
    if (method === 'GET' && roomMatch) {
      const r = allRooms.find(r => r.id === Number(roomMatch[1]));
      if (r) {
        return json(res, {
          ...r,
          storageItems: storageItems.filter(s => s.roomId === r.id),
        });
      }
      return json(res, { message: 'Not found' }, 404);
    }

    // POST /api/rooms
    if (method === 'POST' && path === '/api/rooms') {
      const newRoom = {
        id: nextRoomId++,
        hostelId: parsed.hostelId,
        roomNumber: parsed.roomNumber || '999',
        roomType: parsed.roomType || 'standard',
        capacity: parsed.capacity || 1,
        occupancyCount: 0,
      };
      const hostel = hostels.find(h => h.id === parsed.hostelId);
      allRooms.push({ ...newRoom, hostel: hostel || {} });
      if (hostel) {
        hostel.rooms.push(newRoom);
        hostel.totalRooms = hostel.rooms.length;
      }
      return json(res, newRoom, 201);
    }

    // GET /api/storage-items  (optional ?roomId=X)
    if (method === 'GET' && path === '/api/storage-items') {
      const roomId = url.searchParams.get('roomId');
      let items = storageItems;
      if (roomId) {
        items = items.filter(s => s.roomId === Number(roomId));
      }
      return json(res, items);
    }

    // POST /api/storage-items
    if (method === 'POST' && path === '/api/storage-items') {
      const newItem = {
        id: nextStorageId++,
        roomId: parsed.roomId,
        description: parsed.description || '',
        photoUrl: parsed.photoUrl || null,
        belongsTo: parsed.belongsTo || 'inspection',
        takenByUserId: 'test',
        takenAt: new Date().toISOString(),
      };
      storageItems.push(newItem);
      return json(res, newItem, 201);
    }

    // GET /api/storage-items/:id
    const storageMatch = path.match(/^\/api\/storage-items\/(\d+)$/);
    if (method === 'GET' && storageMatch) {
      const s = storageItems.find(s => s.id === Number(storageMatch[1]));
      return s ? json(res, s) : json(res, { message: 'Not found' }, 404);
    }

    // 404 fallback
    json(res, { message: 'Route not found' }, 404);
  });
});

function json(res, data, status = 200) {
  res.writeHead(status, { 'Content-Type': 'application/json' });
  res.end(JSON.stringify(data));
}

server.listen(PORT, '127.0.0.1', () => {
  console.log('');
  console.log('===========================================');
  console.log(`  MOCK SERVER running on port ${PORT}`);
  console.log('  This is for testing frontend only.');
  console.log('  Delete this file when real backend runs.');
  console.log('===========================================');
  console.log('');
  console.log('Available routes:');
  console.log('  GET  /health');
  console.log('  GET  /api/users/me');
  console.log('  GET  /api/hostels');
  console.log('  POST /api/hostels');
  console.log('  GET  /api/hostels/:id');
  console.log('  PUT  /api/hostels/:id');
  console.log('  GET  /api/rooms?hostelId=X');
  console.log('  GET  /api/rooms/:id');
  console.log('  POST /api/rooms');
  console.log('  GET  /api/storage-items?roomId=X');
  console.log('  POST /api/storage-items');
  console.log('');
  console.log('Waiting for requests...');
});
