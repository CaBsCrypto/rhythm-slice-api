# 🍕 SpicyCrust Game Ecosystem API (v1)

[![PHP Version](https://img.shields.io/badge/PHP-8.2%2B-blue.svg)](https://www.php.net/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Bienvenido al repositorio oficial de la **API del Ecosistema de Juegos SpicyCrust** (`spicycrust.com`).

Esta API es el núcleo ligero de persistencia y competencia que conecta todos los juegos del ecosistema (*Rhythm Slice*, *Slice Hunter*, etc.) compartiendo la **identidad de los jugadores**, **puntajes**, **temporadas (seasons)** y **leaderboards (por juego y global)**.

---

## 📌 Guía Rápida para Desarrolladores

Si eres desarrollador de un juego (*Rhythm Slice*, *Slice Hunter*, o un nuevo juego), consulta estas guías según tu rol:

1. 🎮 **[Cómo integrar la API en tu juego (SDK / JavaScript Integration Guide)](#-cómo-integrar-la-api-en-tu-juego-javascript)**
2. 📄 **[Especificación Completa de Contratos JSON (docs/API.md)](./docs/API.md)**
3. 🏗️ **[Propuesta de Arquitectura y Visión del Ecosistema (ARCHITECTURE_PROPOSAL.md)](./ARCHITECTURE_PROPOSAL.md)**
4. 🔒 **[Políticas de Seguridad y Antifraude (docs/SECURITY.md)](./docs/SECURITY.md)**
5. ➕ **[Cómo agregar un nuevo juego al ecosistema](#-cómo-agregar-un-nuevo-juego-al-ecosistema)**

---

## 🚀 Endpoints de la API v1

Todas las peticiones responden en formato JSON y utilizan la versión `/api/v1/`:

| Método | Endpoint | Descripción | Autenticación |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/v1/health` | Estado del motor y salud del sistema | Pública |
| `GET` | `/api/v1/games` | Lista de juegos registrados | Pública |
| `POST` | `/api/v1/scores` | Registrar un puntaje al terminar partida | **API Key (`X-Game-Key`)** |
| `GET` | `/api/v1/leaderboard` | Ranking de un juego (`?game=rhythm-slice`) | Pública |
| `GET` | `/api/v1/leaderboard/global` | Ranking global del ecosistema (Rank Points) | Pública |
| `GET` | `/api/v1/seasons` | Lista de temporadas competitivas | Pública |

---

## 🎮 Cómo integrar la API en tu juego (JavaScript)

Puedes incluir esta pequeña clase cliente o función en tu juego en JavaScript / TypeScript para enviar los puntajes de los jugadores fácilmente.

### Ejemplo de Cliente en JavaScript (`SpicyCrustClient.js`):

```javascript
class SpicyCrustAPI {
  constructor(apiBaseUrl, gameKey) {
    this.baseUrl = apiBaseUrl; // Ej: 'https://api.spicycrust.com' o 'http://localhost:8000'
    this.gameKey = gameKey;     // La X-Game-Key secreta de tu juego
  }

  /**
   * Enviar puntaje al finalizar la partida
   */
  async submitScore({ gameSlug, playerExternalId, nickname, score, metadata = {} }) {
    try {
      const response = await fetch(`${this.baseUrl}/api/v1/scores`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Game-Key': this.gameKey
        },
        body: JSON.stringify({
          game_slug: gameSlug,
          player_external_id: playerExternalId,
          nickname: nickname,
          score: Math.floor(score),
          metadata: metadata
        })
      });

      const data = await response.json();
      return data;
    } catch (error) {
      console.error('Error enviando score a SpicyCrust API:', error);
      return { success: false, error };
    }
  }

  /**
   * Consultar el ranking de tu juego
   */
  async getLeaderboard(gameSlug, limit = 50) {
    const response = await fetch(`${this.baseUrl}/api/v1/leaderboard?game=${gameSlug}&limit=${limit}`);
    return await response.json();
  }

  /**
   * Consultar el ranking global del ecosistema
   */
  async getGlobalLeaderboard() {
    const response = await fetch(`${this.baseUrl}/api/v1/leaderboard/global`);
    return await response.json();
  }
}

// Ejemplo de uso al terminar la partida de Rhythm Slice:
const spicyAPI = new SpicyCrustAPI('https://api.spicycrust.com', 'rhythm_slice_secret_key_2026');

// Al perder o ganar:
spicyAPI.submitScore({
  gameSlug: 'rhythm-slice',
  playerExternalId: 'player_user_123',
  nickname: 'PizzaKing',
  score: 14500,
  metadata: {
    combo: 64,
    accuracy: 99.1,
    difficulty: 'hard'
  }
}).then(res => console.log('Score Guardado:', res));
```

---

## ➕ Cómo agregar un nuevo juego al ecosistema

La API está diseñada desacoplada. Para agregar un juego nuevo (ej. `slice-hunter` o `pizza-runner`):

1. **Registra el juego en la Base de Datos:**
   - **En V1 (JSON `storage/db.json`):** Agrega un objeto al array `games`:
     ```json
     {
       "id": 3,
       "slug": "pizza-runner",
       "name": "Pizza Runner",
       "api_key_hash": "$2y$10$hash_generado_aqui...",
       "status": "active"
     }
     ```
   - **En V2 (MySQL `database/schema.sql`):**
     ```sql
     INSERT INTO games (slug, name, api_key_hash, status) 
     VALUES ('pizza-runner', 'Pizza Runner', '$2y$10$hash...', 'active');
     ```

2. **Entrega la API Key al desarrollador del nuevo juego.**
3. **El nuevo juego ya puede enviar puntajes inmediatamente a `/api/v1/scores`** y aparecerá en el leaderboard individual y global sin tocar una sola línea de código del backend.

---

## 🛠️ Ejecución Local (PHP 8.2+)

```bash
# 1. Clonar el repositorio
git clone https://github.com/CaBsCrypto/rhythm-slice-api.git
cd rhythm-slice-api

# 2. Iniciar servidor local PHP integrado
php -S localhost:8000 -t public
```

---

## 📂 Estructura del Repositorio

```
spicycrust-game-api/
├── public/
│   └── index.php             # Router principal PHP 8.2+
├── database/
│   ├── schema.sql            # Esquema MySQL 8.0+ (Fase V2)
│   └── seed.sql              # Datos iniciales (Rhythm Slice, Slice Hunter)
├── docs/
│   ├── API.md                # Especificación detallada de contratos JSON
│   └── SECURITY.md           # Guía de seguridad y autenticación
├── storage/
│   └── db.json               # Base de datos atómica en JSON V1
├── ARCHITECTURE_PROPOSAL.md   # Documento de arquitectura oficial
└── README.md                 # Este documento
```
