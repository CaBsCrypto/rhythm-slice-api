<?php
// Archivo de arranque principal para la API en PHP

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Game-Key, X-Request-ID');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$method = $_SERVER['REQUEST_METHOD'];

// Helper para guardar/leer storage/db.json con lock nativo flock
function getDbPath() {
    return __DIR__ . '/../storage/db.json';
}

function readDb() {
    $path = getDbPath();
    if (!file_exists($path)) {
        return ['games' => [], 'seasons' => [], 'players' => [], 'scores' => []];
    }
    $fp = fopen($path, 'r');
    if (flock($fp, LOCK_SH)) {
        $content = fread($fp, filesize($path) ?: 1);
        flock($fp, LOCK_UN);
        fclose($fp);
        return json_decode($content, true) ?: ['games' => [], 'seasons' => [], 'players' => [], 'scores' => []];
    }
    fclose($fp);
    return ['games' => [], 'seasons' => [], 'players' => [], 'scores' => []];
}

function writeDb($data) {
    $path = getDbPath();
    $fp = fopen($path, 'w');
    if (flock($fp, LOCK_EX)) {
        fwrite($fp, json_encode($data, JSON_PRETTY_PRINT));
        flock($fp, LOCK_UN);
        fclose($fp);
        return true;
    }
    fclose($fp);
    return false;
}

// 1. GET /api/v1/health
if (($uri === '/api/v1/health' || $uri === '/health') && $method === 'GET') {
    echo json_encode([
        'success' => true,
        'data' => [
            'status' => 'ok',
            'version' => '1.0.0',
            'engine' => 'PHP 8.2+ JSON Storage V1',
            'timestamp' => time()
        ]
    ]);
    exit;
}

// 2. GET /api/v1/games
if (($uri === '/api/v1/games' || $uri === '/games') && $method === 'GET') {
    $db = readDb();
    $games = array_map(function($g) {
        return [
            'slug' => $g['slug'],
            'name' => $g['name'],
            'status' => $g['status']
        ];
    }, $db['games'] ?? []);

    echo json_encode(['success' => true, 'data' => $games]);
    exit;
}

// 3. GET /api/v1/seasons
if (($uri === '/api/v1/seasons' || $uri === '/seasons') && $method === 'GET') {
    $db = readDb();
    echo json_encode(['success' => true, 'data' => $db['seasons'] ?? []]);
    exit;
}

// 4. POST /api/v1/scores
if (($uri === '/api/v1/scores' || $uri === '/scores') && $method === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    
    if (!$input || empty($input['game_slug']) || empty($input['player_external_id']) || !isset($input['score'])) {
        http_response_code(400);
        echo json_encode([
            'success' => false,
            'error' => [
                'code' => 'INVALID_PAYLOAD',
                'message' => 'Campos requeridos faltantes: game_slug, player_external_id y score son obligatorios.'
            ]
        ]);
        exit;
    }

    $db = readDb();
    
    $scoreRecord = [
        'id' => 'score_' . time() . '_' . substr(md5(uniqid()), 0, 5),
        'game_slug' => $input['game_slug'],
        'player_external_id' => $input['player_external_id'],
        'nickname' => $input['nickname'] ?? 'Player',
        'score' => (int)$input['score'],
        'season_slug' => $input['season_slug'] ?? 'season-01',
        'metadata' => $input['metadata'] ?? new stdClass(),
        'created_at' => date('c')
    ];

    $db['scores'][] = $scoreRecord;
    writeDb($db);

    http_response_code(201);
    echo json_encode([
        'success' => true,
        'data' => $scoreRecord
    ]);
    exit;
}

// 5. GET /api/v1/leaderboard
if (($uri === '/api/v1/leaderboard' || $uri === '/leaderboard') && $method === 'GET') {
    $gameSlug = $_GET['game'] ?? 'rhythm-slice';
    $db = readDb();

    $scores = array_filter($db['scores'] ?? [], function($s) use ($gameSlug) {
        return $s['game_slug'] === $gameSlug;
    });

    usort($scores, function($a, b) {
        return $b['score'] - $a['score'];
    });

    $ranking = [];
    $rank = 1;
    foreach ($scores as $s) {
        $ranking[] = [
            'rank' => $rank++,
            'player_id' => $s['player_external_id'],
            'nickname' => $s['nickname'],
            'score' => $s['score'],
            'metadata' => $s['metadata']
        ];
    }

    echo json_encode([
        'success' => true,
        'data' => [
            'game' => ['slug' => $gameSlug],
            'season' => ['slug' => 'season-01'],
            'ranking' => $ranking
        ]
    ]);
    exit;
}

// Ruta no encontrada
http_response_code(404);
echo json_encode([
    'success' => false,
    'error' => [
        'code' => 'NOT_FOUND',
        'message' => 'Endpoint no encontrado'
    ]
]);
