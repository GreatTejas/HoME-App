INSERT INTO users (id, name, email, role)
VALUES ('admin', 'Local Admin', 'admin@example.com', 'admin')
ON DUPLICATE KEY UPDATE name = VALUES(name), email = VALUES(email), role = VALUES(role);

INSERT INTO hostels (id, name, hostel_code, gender, created_by)
VALUES
  (1, 'Maple Residence', 'MR', 'male', 'admin'),
  (2, 'Oak Hall', 'OH', 'female', 'admin'),
  (3, 'Cedar House', 'CH', 'co-ed', 'admin')
ON DUPLICATE KEY UPDATE name = VALUES(name), hostel_code = VALUES(hostel_code), gender = VALUES(gender);

INSERT INTO rooms (hostel_id, room_number, room_type, capacity, occupancy_count, created_by)
VALUES
  (1, '101', 'standard', 2, 1, 'admin'),
  (1, '102', 'standard', 2, 0, 'admin'),
  (1, '201', 'standard', 2, 1, 'admin'),
  (2, '101', 'standard', 2, 1, 'admin'),
  (2, '102', 'standard', 2, 0, 'admin'),
  (3, '101', 'common', 1, 0, 'admin'),
  (3, '201', 'standard', 2, 1, 'admin')
ON DUPLICATE KEY UPDATE room_type = VALUES(room_type), capacity = VALUES(capacity), occupancy_count = VALUES(occupancy_count);

INSERT INTO storage_items (description, photo_url, belongs_to, room_id, taken_by_user_id)
SELECT 'Ceiling Fan: Broken blade', NULL, 'inspection', rooms.id, 'admin'
FROM rooms
WHERE rooms.hostel_id = 1 AND rooms.room_number = '101'
LIMIT 1;
