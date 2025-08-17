CREATE DATABASE IF NOT EXISTS NeoTokyo
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;
USE NeoTokyo;

-- Users
CREATE TABLE IF NOT EXISTS GhostUser (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(100) NOT NULL,
  bio TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Posts
CREATE TABLE IF NOT EXISTS DataPulse (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  content TEXT,
  image_path VARCHAR(255),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_dp_user (user_id),
  CONSTRAINT fk_dp_user
    FOREIGN KEY (user_id) REFERENCES GhostUser(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Likes (Voltage)
CREATE TABLE IF NOT EXISTS Voltage (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pulse_id INT NOT NULL,
  user_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_voltage UNIQUE (pulse_id, user_id),
  INDEX idx_volt_pulse (pulse_id),
  INDEX idx_volt_user (user_id),
  CONSTRAINT fk_volt_pulse
    FOREIGN KEY (pulse_id) REFERENCES DataPulse(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_volt_user
    FOREIGN KEY (user_id) REFERENCES GhostUser(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Follows (ShadowLink)
CREATE TABLE IF NOT EXISTS ShadowLink (
  id INT AUTO_INCREMENT PRIMARY KEY,
  follower_id INT NOT NULL,
  followed_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_follow UNIQUE (follower_id, followed_id),
  INDEX idx_follow_follower (follower_id),
  INDEX idx_follow_followed (followed_id),
  CONSTRAINT fk_follow_follower
    FOREIGN KEY (follower_id) REFERENCES GhostUser(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_follow_followed
    FOREIGN KEY (followed_id) REFERENCES GhostUser(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
