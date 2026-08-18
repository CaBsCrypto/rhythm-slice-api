-- =========================================================
-- SPICYCRUST GAME API
-- Datos semilla para inicializar la base de datos
-- =========================================================


-- =========================================================
-- TEMPORADAS
-- =========================================================

INSERT INTO seasons (
    slug,
    name,
    starts_at,
    ends_at,
    status
) VALUES (
    'season-01',
    'Season 01 - Inaugural',
    '2026-08-01 00:00:00',
    '2026-10-31 23:59:59',
    'active'
);


-- =========================================================
-- JUEGOS
-- =========================================================

INSERT INTO games (
    slug,
    name,
    description,
    api_key_hash,
    status
) VALUES

-- Rhythm Slice
(
    'rhythm-slice',
    'Rhythm Slice',
    'Juego de ritmo y cortar pizzas al compás de la música',
    '$2y$10$e8w61P0Qf.xY3iN/Y9gDVOwR0yB6C9RzN9s8k.L4A5V6B7C8D9E0F',
    'active'
),

-- Slash Slice
(
    'slash-slice',
    'Slash Slice',
    'Juego de acción y recolección de rebanadas legendarias',
    '$2y$10$f9x72Q1R.yZ4jO/Z0hEWWP1s1zC7D0S0O0t9l.M5B6W7C8D9E0F1',
    'active'
);

-- Slice Hunter
(
    'slice-hunter',
    'Slice Hunter',
    'Juego preparado para futura integración con rankings y estadísticas',
    '$2y$10$PLACEHOLDER_HASH_FOR_SLICE_HUNTER',
    'active'
);