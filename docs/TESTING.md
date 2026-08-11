# SpicyCrust API — Testing & Integration

Guía rápida para probar la API de SpicyCrust desde clientes externos como Postman, cURL u otras aplicaciones.

## Base URL

```text
https://spicycrust-api.chiledao.cl/api/v1
```

La API utiliza JSON y actualmente no requiere autenticación para las operaciones documentadas en este archivo.

---

## Endpoints disponibles

| Método | Endpoint | Descripción |
|---|---|---|
| `GET` | `/health` | Estado de la API |
| `GET` | `/games` | Lista de juegos |
| `GET` | `/seasons` | Lista de temporadas |
| `POST` | `/scores` | Registrar un score |
| `GET` | `/leaderboard` | Obtener ranking de un juego |

---

# 1. Health Check

### Request

```http
GET https://spicycrust-api.chiledao.cl/api/v1/health
```

### cURL

```bash
curl https://spicycrust-api.chiledao.cl/api/v1/health
```

### Response esperada

```json
{
  "success": true,
  "data": {
    "status": "ok",
    "version": "1.0.0",
    "engine": "PHP 8.2+ JSON Storage V1",
    "timestamp": 1234567890
  }
}
```

---

# 2. Obtener juegos

### Request

```http
GET https://spicycrust-api.chiledao.cl/api/v1/games
```

### cURL

```bash
curl https://spicycrust-api.chiledao.cl/api/v1/games
```

### Response

```json
{
  "success": true,
  "data": [
    {
      "slug": "rhythm-slice",
      "name": "Rhythm Slice",
      "status": "active"
    }
  ]
}
```

Los valores dependen de los juegos registrados actualmente en la base de datos JSON.

---

# 3. Obtener temporadas

### Request

```http
GET https://spicycrust-api.chiledao.cl/api/v1/seasons
```

### cURL

```bash
curl https://spicycrust-api.chiledao.cl/api/v1/seasons
```

### Response

```json
{
  "success": true,
  "data": []
}
```

---

# 4. Registrar un score

Este es el endpoint principal para integrar un juego externo con SpicyCrust.

### Request

```http
POST https://spicycrust-api.chiledao.cl/api/v1/scores
```

### Headers

```http
Content-Type: application/json
Accept: application/json
```

### Body

```json
{
  "game_slug": "rhythm-slice",
  "player_external_id": "player-001",
  "nickname": "PlayerOne",
  "score": 15000,
  "season_slug": "season-01",
  "metadata": {
    "source": "external-game",
    "test": true
  }
}
```

### cURL

```bash
curl -X POST \
  "https://spicycrust-api.chiledao.cl/api/v1/scores" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "game_slug": "rhythm-slice",
    "player_external_id": "player-001",
    "nickname": "PlayerOne",
    "score": 15000,
    "season_slug": "season-01",
    "metadata": {
      "source": "external-game",
      "test": true
    }
  }'
```

### Response esperada

HTTP:

```text
201 Created
```

```json
{
  "success": true,
  "data": {
    "id": "score_...",
    "game_slug": "rhythm-slice",
    "player_external_id": "player-001",
    "nickname": "PlayerOne",
    "score": 15000,
    "season_slug": "season-01",
    "metadata": {
      "source": "external-game",
      "test": true
    },
    "created_at": "2026-08-11T..."
  }
}
```

---

# 5. Obtener leaderboard

El leaderboard puede filtrarse por juego mediante el parámetro `game`.

### Request

```http
GET https://spicycrust-api.chiledao.cl/api/v1/leaderboard?game=rhythm-slice
```

### cURL

```bash
curl "https://spicycrust-api.chiledao.cl/api/v1/leaderboard?game=rhythm-slice"
```

### Response

```json
{
  "success": true,
  "data": {
    "game": {
      "slug": "rhythm-slice"
    },
    "season": {
      "slug": "season-01"
    },
    "ranking": [
      {
        "rank": 1,
        "player_id": "player-001",
        "nickname": "PlayerOne",
        "score": 15000,
        "metadata": {
          "source": "external-game",
          "test": true
        }
      }
    ]
  }
}
```

El ranking se ordena de mayor a menor score.

---

# Flujo completo de integración

Un juego externo puede utilizar la API siguiendo este flujo:

```text
┌───────────────────────┐
│      External Game    │
│                       │
│     Rhythm Slice      │
└───────────┬───────────┘
            │
            │ POST /scores
            ▼
┌────────────────────────────┐
│      SpicyCrust API        │
│                            │
│  /api/v1/scores            │
│  /api/v1/leaderboard       │
│  /api/v1/games             │
│  /api/v1/seasons           │
└────────────┬───────────────┘
             │
             ▼
       JSON Storage
```

Un juego no necesita conocer ni acceder directamente al almacenamiento de SpicyCrust.

La integración se realiza exclusivamente mediante HTTP/JSON.

---

# Flujo recomendado para un juego

Al cargar el juego:

```text
GET /api/v1/games
```

Al finalizar una partida:

```text
POST /api/v1/scores
```

Para mostrar el ranking:

```text
GET /api/v1/leaderboard?game=rhythm-slice
```

---

# Identificación del jugador

El campo:

```json
"player_external_id": "player-001"
```

permite que el juego mantenga su propia identificación de jugadores.

SpicyCrust no necesita conocer necesariamente la identidad real del jugador.

Ejemplo:

```json
{
  "game_slug": "rhythm-slice",
  "player_external_id": "user_12345",
  "nickname": "Mauro",
  "score": 23000
}
```

---

# Metadata

El campo `metadata` permite que cada juego envíe información adicional sin modificar el contrato principal del score.

Ejemplo:

```json
{
  "metadata": {
    "level": 4,
    "difficulty": "hard",
    "combo": 37,
    "duration_ms": 18200,
    "source": "rhythm-slice"
  }
}
```

La metadata debe utilizarse para información complementaria y no para reemplazar los campos principales del score.

---

# Validación de errores

## Endpoint inexistente

```http
404 Not Found
```

```json
{
  "success": false,
  "error": {
    "code": "NOT_FOUND",
    "message": "Endpoint no encontrado"
  }
}
```

## Payload inválido

```http
400 Bad Request
```

```json
{
  "success": false,
  "error": {
    "code": "INVALID_PAYLOAD",
    "message": "Campos requeridos faltantes: game_slug, player_external_id y score son obligatorios."
  }
}
```

---

# Prueba rápida con Postman

Se recomienda crear una colección:

```text
SpicyCrust API
├── Health
├── Games
├── Seasons
├── Create Score
└── Leaderboard
```

### Variables

Definir:

```text
base_url = https://spicycrust-api.chiledao.cl/api/v1
```

Entonces los requests pueden utilizar:

```text
{{base_url}}/health
{{base_url}}/games
{{base_url}}/seasons
{{base_url}}/scores
{{base_url}}/leaderboard?game=rhythm-slice
```

---

# Orden recomendado de pruebas

Para verificar una instalación completa:

```text
1. GET  /health
2. GET  /games
3. GET  /seasons
4. POST /scores
5. GET  /leaderboard?game=rhythm-slice
```

Si los cinco requests responden correctamente, la API está disponible para integración externa.

---

# Estado actual de seguridad

Actualmente los endpoints de score no requieren una API key.

Aunque el servidor permite los headers:

```http
Authorization
X-Game-Key
X-Request-ID
```

la implementación actual todavía no valida `X-Game-Key`.

Por lo tanto, **esta versión debe considerarse una API de prototipo**.

Para producción se recomienda implementar autenticación por juego:

```text
External Game
      │
      │ X-Game-Key
      ▼
SpicyCrust API
      │
      ├── Validate Game
      ├── Validate API Key
      ├── Validate Payload
      └── Store Score
```

Esto permitirá que cada juego tenga una credencial independiente sin entregar acceso al almacenamiento interno.

---

# Próximos pasos sugeridos

La siguiente evolución natural de la API es:

1. Autenticación por `X-Game-Key`.
2. Validación de que `game_slug` corresponda a la API key.
3. `X-Request-ID` para trazabilidad.
4. Protección contra envío duplicado de scores.
5. Rate limiting.
6. Leaderboards por temporada.
7. Leaderboard global.
8. Endpoint para obtener información de un juego.
9. Documentación OpenAPI/Swagger.
10. Cliente JavaScript reutilizable para integrar nuevos juegos.

La intención es que un juego pueda integrarse sin conocer la implementación interna de SpicyCrust:

```text
GAME
  │
  │ HTTP + JSON
  ▼
SPICYCRUST API
  │
  ▼
SCORES / PLAYERS / SEASONS / LEADERBOARDS
```

El API actúa como una capa común entre múltiples experiencias de juego.