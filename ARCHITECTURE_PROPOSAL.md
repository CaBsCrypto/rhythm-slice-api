# ARCHITECTURE_PROPOSAL.md — SpicyCrust Game Ecosystem API (V1)

## 1. Problema y Visión

**SpicyCrust** (`spicycrust.com`) posee un ecosistema de juegos web (actualmente *Rhythm Slice* y *Slice Hunter*, con capacidad de incorporar nuevos juegos en el futuro).

Actualmente, no existe un núcleo de persistencia común que permita:
- Compartir la identidad del jugador transversalmente entre juegos.
- Mantener rankings competitivos por juego y un leaderboard global del ecosistema.
- Gestionar resets competitivos limpios mediante **Seasons (Temporadas)** sin destruir el historial de partidas.

### Visión de la API:
Crear una API ligera, segura, mantenible y extensible en **PHP 8.2+** sin frameworks pesados ni dependencias innecesarias, capaz de correr en cualquier hosting tradicional (Apache/Nginx) o servidor PHP estándar.

---

## 2. Principio de Desacoplamiento (Game Logic vs. API)

- **El Juego conoce las reglas:** *Rhythm Slice* conoce qué es combo, precisión y notas. *Slice Hunter* conoce sus propias mecánicas.
- **La API sólo entiende:**
  - Qué juego reporta (`game_slug`).
  - Qué jugador reporta (`player_id` / `nickname`).
  - Qué score obtuvo (`score`).
  - Metadata adicional flexible (`metadata` JSON).
  - A qué temporada pertenece (`season_slug`).
  - Si la petición proviene de un juego autorizado (`X-Game-Key`).

---

## 3. Arquitectura del Proyecto (PHP 8.2+ Modular Simplicidad)

```
spicycrust-game-api/
├── public/
│   ├── index.php             # Front controller / Router HTTP
│   └── .htaccess             # Redirección de URLs a index.php
├── src/
│   ├── Config/               # Cargador de entorno .env y configuraciones
│   ├── Database/             # Storage Manager (Driver JSON V1 con flock() / PDO MySQL V2)
│   ├── Security/             # Autenticación de API Keys, Rate Limiting y CORS
│   ├── Games/                # Servicio y gestión de juegos registrados
│   ├── Players/              # Identidad y catálogo de jugadores
│   ├── Scores/               # Registro y validación semántica de puntajes
│   ├── Seasons/              # Gestión de temporadas (Season 01, Season 02...)
│   └── Leaderboard/          # Servicios de ranking por juego y ranking global
├── storage/
│   ├── db.json               # Almacenamiento primario JSON atómico (V1)
│   └── logs/                 # Registros de log con X-Request-ID
├── database/
│   ├── schema.sql            # Esquema SQL para la migración a MySQL V2
│   └── seed.sql              # Datos iniciales (juegos y temporada inicial)
├── docs/
│   └── API.md                # Especificación completa de los contratos de API
├── .env.example
├── .gitignore
├── composer.json
└── README.md
```

---

## 4. Entidades y Esquema de Datos

### A. Games (Juegos)
- `id`: Identificador único (UUID o autoincremental).
- `slug`: String único (ej. `rhythm-slice`, `slice-hunter`).
- `name`: Nombre público (ej. "Rhythm Slice").
- `api_key_hash`: Hash seguro de la API Key del juego (para autenticar peticiones `POST /scores`).
- `status`: `active` | `inactive`.

### B. Players (Jugadores)
- `id`: ID interno de la plataforma.
- `external_id`: String único asignado al jugador (ej. `player_abc123`).
- `nickname`: Apodo público desplegable en leaderboards.

### C. Seasons (Temporadas)
- `id`: ID único.
- `slug`: Identificador único (ej. `season-01`).
- `name`: Nombre (ej. "Season 01 - Verano 2026").
- `starts_at`: ISO 8601 Timestamp.
- `ends_at`: ISO 8601 Timestamp.
- `status`: `active` | `completed`.

### D. Scores (Puntajes)
- `id`: Identificador único de puntaje (`score_xyz123`).
- `game_slug`: Slug del juego.
- `player_external_id`: External ID del jugador.
- `season_slug`: Temporada activa en la que se registró el score.
- `score`: Entero `>= 0` (puntuación principal).
- `metadata`: Objeto JSON flexible (ej. `{"combo": 45, "accuracy": 98.2}`).
- `created_at`: Timestamp de registro.

---

## 5. Estrategia de Leaderboards (Separados y Global)

### A. Leaderboard por Juego (`GET /api/v1/leaderboard?game=rhythm-slice`)
Filtra los mejores puntajes del juego solicitado en la temporada activa, ordenados de mayor a menor.

### B. Leaderboard Global (`GET /api/v1/leaderboard/global`)
Sistema de **Rank Points (Puntos por Posición)**:
- Para cada juego en la temporada activa:
  - 1° lugar: 100 Puntos de Ranking
  - 2° lugar: 90 Puntos de Ranking
  - 3° lugar: 80 Puntos de Ranking
  - 4° al 10° lugar: Puntos proporcionales (70 pts a 10 pts)
- El Leaderboard Global suma los **Rank Points** de cada jugador en los 2 juegos (*Rhythm Slice* + *Slice Hunter*) para obtener la tabla unificada del ecosistema SpicyCrust.

---

## 6. Endpoints de la API (v1)

| Método | Endpoint | Descripción | Autenticación |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/v1/health` | Estado del sistema (salud de la API) | Pública |
| `GET` | `/api/v1/games` | Lista de juegos registrados | Pública |
| `GET` | `/api/v1/games/{slug}` | Detalle de un juego específico | Pública |
| `POST` | `/api/v1/scores` | Registrar un puntaje | **API Key del Juego (`X-Game-Key`)** |
| `GET` | `/api/v1/leaderboard` | Ranking por juego (parámetros: `game`, `season`, `limit`) | Pública |
| `GET` | `/api/v1/leaderboard/global` | Ranking global unificado del ecosistema | Pública |
| `GET` | `/api/v1/seasons` | Lista de temporadas | Pública |
| `GET` | `/api/v1/seasons/current` | Temporada activa actual | Pública |

---

## 7. Estrategia de Persistencia (V1 JSON -> V2 MySQL)

1. **V1 (JSON Storage):**
   - Todos los datos residen en `storage/db.json`.
   - Las lecturas/escrituras utilizan locks de archivo nativos (`flock(LOCK_EX)`) para garantizar escrituras atómicas y prevenir corrupción en concurrencia.
2. **V2 (MySQL PDO):**
   - Se proveerá `database/schema.sql` con índices optimizados (`idx_game_season_score`, `idx_player`).
   - El cambio entre JSON y MySQL se activará cambiando la variable de entorno `DB_DRIVER=json` o `DB_DRIVER=mysql`.

---

## 8. Seguridad y Anti-Abuso

- **Header de Autenticación:** `X-Game-Key: <secret_key>` en `POST /api/v1/scores`. Se verifica mediante hash para evitar la exposición de credenciales.
- **Validaciones Semánticas:** Filtrado estricto para evitar scores negativos, valores `NaN`, payloads abusivos o metadata excesivamente grande (>2KB).
- **Request IDs (`X-Request-ID`):** Generación de identificador único por petición para trazabilidad en logs sin almacenar información confidencial.
- **CORS Configurable:** Permitir orígenes autorizados (`spicycrust.com`, `rhythmslice.spicycrust.com`, `slicehunter.spicycrust.com`).

---

## 9. Lo que NO se implementará en la V1

Para mantener el proyecto liviano y fácil de mantener:
- ❌ Sin Redis, Kafka, RabbitMQ ni colas complejas.
- ❌ Sin frameworks pesados (Laravel/Symfony).
- ❌ Sin Docker obligatorio (compatibilidad 100% con PHP nativo / cPanel).
- ❌ Sin datos personales innecesarios (emails, teléfonos, contraseñas de jugadores).
