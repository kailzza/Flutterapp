-- SQL schema for scholarships table
CREATE TABLE IF NOT EXISTS scholarships (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  provider VARCHAR(255) NOT NULL,
  deadline VARCHAR(50) DEFAULT '',
  status VARCHAR(50) DEFAULT 'pending',
  notes TEXT,
  lat DOUBLE NULL,
  lng DOUBLE NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
