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
  hostel_code VARCHAR(20) NOT NULL UNIQUE,
  gender ENUM('male', 'female', 'co-ed') NOT NULL,
  warden_id VARCHAR(128),
  created_by VARCHAR(128),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (warden_id) REFERENCES users(id),
  FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE rooms (
  id INT AUTO_INCREMENT PRIMARY KEY,
  hostel_id INT NOT NULL,
  room_number VARCHAR(20) NOT NULL,
  created_by VARCHAR(128),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (hostel_id) REFERENCES hostels(id),
  FOREIGN KEY (created_by) REFERENCES users(id),
  UNIQUE KEY unique_hostel_room (hostel_id, room_number)
);

CREATE TABLE inspections (
  id INT AUTO_INCREMENT PRIMARY KEY,
  room_id INT NOT NULL,
  inspection_type ENUM('check_in', 'check_out') NOT NULL DEFAULT 'check_in',
  inspection_date DATE NOT NULL,
  conditions JSON NOT NULL,
  comments TEXT,
  student_signature LONGTEXT NOT NULL,
  security_signature LONGTEXT NOT NULL,
  created_by VARCHAR(128) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (room_id) REFERENCES rooms(id),
  FOREIGN KEY (created_by) REFERENCES users(id),
  INDEX inspection_room_date (room_id, inspection_date)
);

CREATE TABLE inspection_students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  inspection_id INT NOT NULL,
  name VARCHAR(150) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (inspection_id) REFERENCES inspections(id) ON DELETE CASCADE
);

CREATE TABLE inspection_media (
  id INT AUTO_INCREMENT PRIMARY KEY,
  inspection_id INT NOT NULL,
  media_type ENUM('photo', 'video') NOT NULL,
  secure_url VARCHAR(2048) NOT NULL,
  public_id VARCHAR(255) NOT NULL,
  mime_type VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (inspection_id) REFERENCES inspections(id) ON DELETE CASCADE
);
