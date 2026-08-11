# Especificación Oficial de la API v1 — SpicyCrust Game Ecosystem

## Base URL

En producción (Hosting PHP / Apache / cPanel / Vercel PHP / Nginx):
`https://api.spicycrust.com/api/v1`

---

## 1. GET `/api/v1/health`

Verifica el estado del servicio y la salud del sistema.

### Respuesta (`200 OK`):
```json
{
  "success": true,
  "data": {
    "status": "ok",
    "version": "1.0.0",
    "timestamp": 1770769200
  }
}
```

---

## 2. GET `/api/v1/games`

Obtiene la lista de juegos activos registrados en el ecosistema SpicyCrust.

### Respuesta (`200 OK`):
```json
{
  "success": true,
  "data": [
    {
      "slug": "rhythm-slice",
      "name": "Rhythm Slice",
      "status": "active"
    },
    {
      "slug": "slice-hunter",
      "name": "Slice Hunter",
      "status": "active"
    }
  ]
}
```

---

## 3. POST `/api/v1/scores`

Registra un puntaje obtenido por un jugador en un juego.

### Headers requeridos:
- `Content-Type: application/json`
- `X-Game-Key: <secret_api_key_del_juego>`

### Payload (`Request Body`):
```json
{
  "game_slug": "rhythm-slice",
  "player_external_id": "player_abc123",
  "nickname": "MasterPizza",
  "score": 12500,
  "season_slug": "season-01",
  "metadata": {
    "combo": 48,
    "accuracy": 98.5,
    "difficulty": "hard"
  }
}
```

### Respuesta Éxito (`201 Created`):
```json
{
  "success": true,
  "data": {
    "score_id": "score_1770769200_a1b2c",
    "game_slug": "rhythm-slice",
    "player_external_id": "player_abc123",
    "nickname": "MasterPizza",
    "score": 12500,
    "season_slug": "season-01",
    "created_at": "2026-08-11T05:30:00Z"
  }
}
```

### Respuesta Error (`401 Unauthorized` / `400 Bad Request`):
```json
{
  "success": false,
  "error": {
    "code": "INVALID_GAME_KEY",
    "message": "La API Key del juego enviada no es válida"
  }
}
```

---

## 4. GET `/api/v1/leaderboard`

Obtiene el ranking de un juego específico.

### Parámetros Query:
- `game` (requerido): Slug del juego (`rhythm-slice` o `slice-hunter`).
- `season` (opcional): Slug de la temporada (por defecto la activa).
- `limit` (opcional): Límite de resultados (por defecto `50`, máximo `100`).

### Respuesta (`200 OK`):
```json
{
  "success": true,
  "data": {
    "game": {
      "slug": "rhythm-slice",
      "name": "Rhythm Slice"
    },
    "season": {
      "slug": "season-01",
      "name": "Season 01 - Inaugural"
    },
    "ranking": [
      {
        "rank": 1,
        "player_id": "player_abc123",
        "nickname": "MasterPizza",
        "score": 12500,
        "metadata": { "combo": 48, "accuracy": 98.5 }
      }
    ]
  }
}
```

---

## 5. GET `/api/v1/leaderboard/global`

Obtiene el ranking global del ecosistema SpicyCrust unificando el rendimiento en todos los juegos mediante Puntos de Ranking (Rank Points).

### Respuesta (`200 OK`):
```json
{
  "success": true,
  "data": {
    "season": {
      "slug": "season-01",
      "name": "Season 01 - Inaugural"
    },
    "ranking": [
      {
        "rank": 1,
        "player_id": "player_abc123",
        "nickname": "MasterPizza",
        "total_rank_points": 190,
        "games_played": 2
      }
    ]
  }
}
```
