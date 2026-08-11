-- Esquema SQL para la base de datos de SpicyCrust Game API (MySQL 8.0+)
-- Este esquema se utilizará cuando el sistema pase de la fase JSON (V1) a MySQL (V2).

CREATE TABLE IF NOT EXISTS games (
  id INT AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  description TEXT,
  api_key_hash VARCHAR(255) NOT NULL,
  status ENUM('active', 'inactive') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS players (
  id INT AUTO_INCREMENT PRIMARY KEY,
  external_id VARCHAR(100) NOT NULL UNIQUE,
  nickname VARCHAR(50) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS seasons (
  id INT AUTO_INCREMENT PRIMARY KEY,
  slug VARCHAR(50) NOT NULL UNIQUE,
  name VARCHAR(100) NOT NULL,
  starts_at TIMESTAMP NOT NULL,
  ends_at TIMESTAMP NOT NULL,
  status ENUM('active', 'completed') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS scores (
  id VARCHAR(64) PRIMARY KEY,
  game_id INT NOT NULL,
  player_id INT NOT NULL,
  season_id INT NOT NULL,
  score INT NOT NULL DEFAULT 0,
  metadata JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
  FOREIGN KEY (player_id) REFERENCES players(id) ON DELETE CASCADE,
  FOREIGN KEY (season_id) REFERENCES seasons(id) ON DELETE CASCADE,
  INDEX idx_game_season_score (game_id, season_id, score DESC),
  INDEX idx_player (player_id),
  INDEX idx_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
