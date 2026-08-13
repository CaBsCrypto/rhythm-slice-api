-- Esquema SQL para la base de datos de SpicyCrust Game API (MySQL 8.0+)
-- Adaptado para permitir identificación opcional mediante correo electrónico.
--
-- Flujo esperado:
-- 1. El usuario puede jugar sin registrarse.
-- 2. Al finalizar, puede elegir guardar su puntaje.
-- 3. Si desea guardarlo, se identifica mediante correo + nickname.
-- 4. Se crea o recupera el jugador.
-- 5. Se guarda el puntaje asociado al jugador, juego y temporada.


-- =========================================================
-- JUEGOS
-- =========================================================

CREATE TABLE IF NOT EXISTS games (
  id INT AUTO_INCREMENT PRIMARY KEY,

  -- Identificador utilizado por la API.
  -- Ejemplo: rhythm-slice
  slug VARCHAR(50) NOT NULL UNIQUE,

  -- Nombre visible del juego.
  -- Ejemplo: Rhyme Slice
  name VARCHAR(100) NOT NULL,

  -- Descripción opcional del juego.
  description TEXT,

  -- Hash de la API key utilizada para identificar/autenticar al juego.
  api_key_hash VARCHAR(255) NOT NULL,

  -- Permite desactivar un juego sin eliminar sus datos.
  status ENUM('active', 'inactive') DEFAULT 'active',

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  updated_at TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- JUGADORES
-- =========================================================

CREATE TABLE IF NOT EXISTS players (
  id INT AUTO_INCREMENT PRIMARY KEY,

  -- ID opcional proporcionado por un juego u otro sistema.
  -- Se mantiene por compatibilidad con el template original.
  external_id VARCHAR(100) UNIQUE,

  -- Correo utilizado para identificar a un jugador que desea
  -- guardar su puntaje.
  email VARCHAR(255) NOT NULL UNIQUE,

  -- Nombre público mostrado en leaderboards.
  nickname VARCHAR(50) NOT NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  updated_at TIMESTAMP
    DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TEMPORADAS
-- =========================================================

CREATE TABLE IF NOT EXISTS seasons (
  id INT AUTO_INCREMENT PRIMARY KEY,

  -- Identificador de la temporada utilizado por la API.
  -- Ejemplo: season-01
  slug VARCHAR(50) NOT NULL UNIQUE,

  -- Nombre visible.
  -- Ejemplo: Temporada 1
  name VARCHAR(100) NOT NULL,

  starts_at TIMESTAMP NOT NULL,

  ends_at TIMESTAMP NOT NULL,

  status ENUM('active', 'completed') DEFAULT 'active',

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- PUNTAJES
-- =========================================================

CREATE TABLE IF NOT EXISTS scores (
  -- El template utiliza un identificador de texto para los puntajes.
  id VARCHAR(64) PRIMARY KEY,

  -- Qué juego generó el puntaje.
  game_id INT NOT NULL,

  -- Qué jugador obtuvo el puntaje.
  player_id INT NOT NULL,

  -- A qué temporada pertenece.
  season_id INT NOT NULL,

  -- Puntaje obtenido.
  score INT NOT NULL DEFAULT 0,

  -- Información adicional específica de cada juego.
  -- Ejemplo:
  -- {"combo": 25, "accuracy": 98.5}
  metadata JSON,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (game_id)
    REFERENCES games(id)
    ON DELETE CASCADE,

  FOREIGN KEY (player_id)
    REFERENCES players(id)
    ON DELETE CASCADE,

  FOREIGN KEY (season_id)
    REFERENCES seasons(id)
    ON DELETE CASCADE,

  -- Facilita obtener leaderboards rápidamente.
  INDEX idx_game_season_score (game_id, season_id, score DESC),

  -- Facilita buscar todos los puntajes de un jugador.
  INDEX idx_player (player_id),

  -- Facilita estadísticas basadas en fechas.
  INDEX idx_created (created_at)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;