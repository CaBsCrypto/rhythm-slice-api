-- =========================================================
-- SPICYCRUST GAME API
-- Base de datos sin datos de prueba
-- =========================================================
--
-- Este archivo contiene la estructura actual de la base de
-- datos y los datos base necesarios para el funcionamiento
-- del sistema.
--
-- NO incluye jugadores ni puntajes utilizados durante las
-- pruebas de desarrollo.
--
-- Al importar este archivo se creará automáticamente la
-- base de datos `spicycrust_game_api` si no existe.
--
-- Exportado desde phpMyAdmin.
-- Versión phpMyAdmin: 5.2.1
-- Host: 127.0.0.1
-- Fecha de generación: 19 de agosto de 2026, 00:02
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12
-- =========================================================


-- =========================================================
-- CREACIÓN DE LA BASE DE DATOS
-- =========================================================

CREATE DATABASE IF NOT EXISTS `spicycrust_game_api`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `spicycrust_game_api`;


-- =========================================================
-- CONFIGURACIÓN INICIAL
-- =========================================================

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;


-- =========================================================
-- TABLA: games
-- =========================================================

-- Estructura de la tabla `games`

CREATE TABLE `games` (
    `id` int(11) NOT NULL,
    `slug` varchar(50) NOT NULL,
    `name` varchar(100) NOT NULL,
    `description` text DEFAULT NULL,
    `api_key_hash` varchar(255) NOT NULL,
    `status` enum('active','inactive') DEFAULT 'active',
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
        ON UPDATE current_timestamp()
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- Datos base de la tabla `games`

INSERT INTO `games` (
    `id`,
    `slug`,
    `name`,
    `description`,
    `api_key_hash`,
    `status`,
    `created_at`,
    `updated_at`
) VALUES

(
    1,
    'rhythm-slice',
    'Rhythm Slice',
    'Juego de ritmo y cortar pizzas al compás de la música',
    '$2y$10$e8w61P0Qf.xY3iN/Y9gDVOwR0yB6C9RzN9s8k.L4A5V6B7C8D9E0F',
    'active',
    '2026-08-18 21:28:43',
    '2026-08-18 21:28:43'
),

(
    2,
    'slash-slice',
    'Slash Slice',
    'Juego de acción y recolección de rebanadas legendarias',
    '$2y$10$f9x72Q1R.yZ4jO/Z0hEWWP1s1zC7D0S0O0t9l.M5B6W7C8D9E0F1',
    'active',
    '2026-08-18 21:28:43',
    '2026-08-18 21:28:43'
),

(
    3,
    'slice-hunter',
    'Slice Hunter',
    'Juego preparado para futura integración con rankings y estadísticas',
    '$2y$10$f9x72Q1R.yZ4jO/Z0hEWWP1s1zC7D0S0O0t9l.M5B6W7C8D9E0F1',
    'active',
    '2026-08-18 21:28:43',
    '2026-08-18 21:28:43'
);


-- =========================================================
-- TABLA: players
-- =========================================================

-- Estructura de la tabla `players`
-- No se incluyen jugadores de prueba en este archivo.

CREATE TABLE `players` (
    `id` int(11) NOT NULL,
    `external_id` varchar(100) DEFAULT NULL,
    `email` varchar(255) NOT NULL,
    `nickname` varchar(50) NOT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
    `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
        ON UPDATE current_timestamp()
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABLA: scores
-- =========================================================

-- Estructura de la tabla `scores`
-- No se incluyen puntajes de prueba en este archivo.

CREATE TABLE `scores` (
    `id` varchar(64) NOT NULL,
    `game_id` int(11) NOT NULL,
    `player_id` int(11) NOT NULL,
    `season_id` int(11) NOT NULL,
    `score` int(11) NOT NULL DEFAULT 0,
    `metadata` longtext
        CHARACTER SET utf8mb4
        COLLATE utf8mb4_bin
        DEFAULT NULL
        CHECK (json_valid(`metadata`)),
    `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- =========================================================
-- TABLA: seasons
-- =========================================================

-- Estructura de la tabla `seasons`

CREATE TABLE `seasons` (
    `id` int(11) NOT NULL,
    `slug` varchar(50) NOT NULL,
    `name` varchar(100) NOT NULL,
    `starts_at` datetime NOT NULL,
    `ends_at` datetime NOT NULL,
    `status` enum('active','completed') DEFAULT 'active',
    `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- Datos base de la tabla `seasons`

INSERT INTO `seasons` (
    `id`,
    `slug`,
    `name`,
    `starts_at`,
    `ends_at`,
    `status`,
    `created_at`
) VALUES (
    1,
    'season-01',
    'Season 01 - Inaugural',
    '2026-08-01 00:00:00',
    '2026-10-31 23:59:59',
    'active',
    '2026-08-18 21:28:24'
);


-- =========================================================
-- ÍNDICES
-- =========================================================


-- Índices de la tabla `games`

ALTER TABLE `games`
    ADD PRIMARY KEY (`id`),
    ADD UNIQUE KEY `slug` (`slug`);


-- Índices de la tabla `players`

ALTER TABLE `players`
    ADD PRIMARY KEY (`id`),
    ADD UNIQUE KEY `email` (`email`),
    ADD UNIQUE KEY `external_id` (`external_id`);


-- Índices de la tabla `scores`

ALTER TABLE `scores`
    ADD PRIMARY KEY (`id`),
    ADD KEY `season_id` (`season_id`),
    ADD KEY `idx_game_season_score` (`game_id`, `season_id`, `score`),
    ADD KEY `idx_player` (`player_id`),
    ADD KEY `idx_created` (`created_at`);


-- Índices de la tabla `seasons`

ALTER TABLE `seasons`
    ADD PRIMARY KEY (`id`),
    ADD UNIQUE KEY `slug` (`slug`);


-- =========================================================
-- AUTO_INCREMENT
-- =========================================================


-- AUTO_INCREMENT de la tabla `games`

ALTER TABLE `games`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT=4;


-- AUTO_INCREMENT de la tabla `players`

ALTER TABLE `players`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


-- AUTO_INCREMENT de la tabla `seasons`

ALTER TABLE `seasons`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,
    AUTO_INCREMENT=2;


-- =========================================================
-- RELACIONES Y CLAVES FORÁNEAS
-- =========================================================

-- Cada puntaje pertenece a un juego, un jugador
-- y una temporada.

ALTER TABLE `scores`

    ADD CONSTRAINT `scores_ibfk_1`
        FOREIGN KEY (`game_id`)
        REFERENCES `games` (`id`)
        ON DELETE CASCADE,

    ADD CONSTRAINT `scores_ibfk_2`
        FOREIGN KEY (`player_id`)
        REFERENCES `players` (`id`)
        ON DELETE CASCADE,

    ADD CONSTRAINT `scores_ibfk_3`
        FOREIGN KEY (`season_id`)
        REFERENCES `seasons` (`id`)
        ON DELETE CASCADE;


-- =========================================================
-- FINALIZAR TRANSACCIÓN
-- =========================================================

COMMIT;


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;