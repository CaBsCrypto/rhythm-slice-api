-- =========================================================
-- SPICYCRUST GAME API
-- Datos de prueba para desarrollo
-- =========================================================
--
-- Este archivo contiene jugadores y puntajes ficticios
-- utilizados únicamente para probar la base de datos.
-- =========================================================


-- =========================================================
-- JUGADORES DE PRUEBA
-- =========================================================

INSERT INTO players (
    external_id,
    email,
    nickname
) VALUES
(
    NULL,
    'ana@test.cl',
    'Ana'
),
(
    NULL,
    'benjamin@test.cl',
    'Benjamin'
),
(
    NULL,
    'camila@test.cl',
    'Camila'
),
(
    NULL,
    'diego@test.cl',
    'Diego'
),
(
    NULL,
    'elena@test.cl',
    'Elena'
);


-- =========================================================
-- PUNTAJES DE PRUEBA
-- =========================================================

-- Rhythm Slice
INSERT INTO scores (
    id,
    game_id,
    player_id,
    season_id,
    score,
    metadata
) VALUES
(
    'test-rhythm-001',
    (SELECT id FROM games WHERE slug = 'rhythm-slice'),
    (SELECT id FROM players WHERE email = 'ana@test.cl'),
    (SELECT id FROM seasons WHERE slug = 'season-01'),
    98500,
    '{"accuracy": 97.5, "max_combo": 42}'
),
(
    'test-rhythm-002',
    (SELECT id FROM games WHERE slug = 'rhythm-slice'),
    (SELECT id FROM players WHERE email = 'benjamin@test.cl'),
    (SELECT id FROM seasons WHERE slug = 'season-01'),
    125600,
    '{"accuracy": 99.1, "max_combo": 58}'
),
(
    'test-rhythm-003',
    (SELECT id FROM games WHERE slug = 'rhythm-slice'),
    (SELECT id FROM players WHERE email = 'camila@test.cl'),
    (SELECT id FROM seasons WHERE slug = 'season-01'),
    87200,
    '{"accuracy": 94.2, "max_combo": 31}'
),
(
    'test-rhythm-004',
    (SELECT id FROM games WHERE slug = 'rhythm-slice'),
    (SELECT id FROM players WHERE email = 'diego@test.cl'),
    (SELECT id FROM seasons WHERE slug = 'season-01'),
    110400,
    '{"accuracy": 98.0, "max_combo": 49}'
),
(
    'test-rhythm-005',
    (SELECT id FROM games WHERE slug = 'rhythm-slice'),
    (SELECT id FROM players WHERE email = 'elena@test.cl'),
    (SELECT id FROM seasons WHERE slug = 'season-01'),
    76300,
    '{"accuracy": 91.8, "max_combo": 25}'
);


-- Slash Slice
INSERT INTO scores (
    id,
    game_id,
    player_id,
    season_id,
    score,
    metadata
) VALUES
(
    'test-slash-001',
    (SELECT id FROM games WHERE slug = 'slash-slice'),
    (SELECT id FROM players WHERE email = 'ana@test.cl'),
    (SELECT id FROM seasons WHERE slug = 'season-01'),
    143200,
    '{"max_combo": 37}'
),
(
    'test-slash-002',
    (SELECT id FROM games WHERE slug = 'slash-slice'),
    (SELECT id FROM players WHERE email = 'benjamin@test.cl'),
    (SELECT id FROM seasons WHERE slug = 'season-01'),
    119800,
    '{"max_combo": 29}'
),
(
    'test-slash-003',
    (SELECT id FROM games WHERE slug = 'slash-slice'),
    (SELECT id FROM players WHERE email = 'camila@test.cl'),
    (SELECT id FROM seasons WHERE slug = 'season-01'),
    156700,
    '{"max_combo": 45}'
),
(
    'test-slash-004',
    (SELECT id FROM games WHERE slug = 'slash-slice'),
    (SELECT id FROM players WHERE email = 'diego@test.cl'),
    (SELECT id FROM seasons WHERE slug = 'season-01'),
    101500,
    '{"max_combo": 24}'
),
(
    'test-slash-005',
    (SELECT id FROM games WHERE slug = 'slash-slice'),
    (SELECT id FROM players WHERE email = 'elena@test.cl'),
    (SELECT id FROM seasons WHERE slug = 'season-01'),
    134900,
    '{"max_combo": 33}'
);