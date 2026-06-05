CREATE TABLE users (
  id VARCHAR(128) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  phone_number VARCHAR(20),
  role ENUM('admin', 'warden', 'security', 'secratery', 'home office') NOT NULL,
  created_by VARCHAR(128),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE hostels (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  hostel_code VARCHAR(10) NOT NULL,
  gender ENUM('male', 'female', 'co-ed') NOT NULL,
  warden_id VARCHAR(128),
  total_rooms INT DEFAULT 0,
  total_students INT DEFAULT 0,
  created_by VARCHAR(128),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (warden_id) REFERENCES users(id),
  FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE rooms (
  id INT AUTO_INCREMENT PRIMARY KEY,
  hostel_id INT NOT NULL,
  room_number VARCHAR(20) NOT NULL,
  room_type ENUM('common', 'standard', 'study', 'other'),
  capacity INT NOT NULL DEFAULT 1,
  occupancy_count INT NOT NULL DEFAULT 0,
  created_by VARCHAR(128),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (hostel_id) REFERENCES hostels(id),
  FOREIGN KEY (created_by) REFERENCES users(id),
  UNIQUE KEY unique_hostel_room (hostel_id, room_number)
);

CREATE TABLE storage_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  description TEXT,
  photo_url VARCHAR(255),
  belongs_to VARCHAR(10),
  room_id INT NOT NULL,
  taken_by_user_id VARCHAR(128),
  taken_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (room_id) REFERENCES rooms(id),
  FOREIGN KEY (taken_by_user_id) REFERENCES users(id)
);
