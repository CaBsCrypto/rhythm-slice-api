# SpicyCrust Game Ecosystem API

API ligera, segura y extensible construida en **PHP 8.2+** para el ecosistema de juegos de **SpicyCrust** (`spicycrust.com`).

---

## 🏛️ Visión y Arquitectura

El núcleo común del ecosistema competitivo de SpicyCrust permite a juegos independientes (*Rhythm Slice*, *Slice Hunter*, etc.) compartir:
- **Identidad de jugador** (`players`)
- **Puntajes y metadatos** (`scores`)
- **Rankings competitivos por juego y global** (`leaderboard`)
- **Resets limpios por temporadas** (`seasons`)

---

## 📄 Documentación Técnica

- 👉 **[ARCHITECTURE_PROPOSAL.md](./ARCHITECTURE_PROPOSAL.md):** Propuesta arquitectónica detallada y modelo de dominio.
- 👉 **[docs/API.md](./docs/API.md):** Especificación completa de los contratos de la API v1 (endpoints, payloads JSON y códigos HTTP).
- 👉 **[docs/SECURITY.md](./docs/SECURITY.md):** Especificación de seguridad, autenticación por API Key y protección antifraude.

---

## 🚀 Endpoints Principales

| Método | Endpoint | Descripción | Autenticación |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/v1/health` | Estado del motor PHP y salud de la API | Pública |
| `GET` | `/api/v1/games` | Lista de juegos registrados | Pública |
| `POST` | `/api/v1/scores` | Enviar puntaje de una partida | **API Key (`X-Game-Key`)** |
| `GET` | `/api/v1/leaderboard` | Ranking por juego (`?game=rhythm-slice`) | Pública |
| `GET` | `/api/v1/leaderboard/global` | Ranking global unificado | Pública |

---

## 💻 Ejecución en Desarrollo (PHP Nativo)

```bash
# 1. Clonar el repositorio
git clone https://github.com/CaBsCrypto/rhythm-slice-api.git
cd rhythm-slice-api

# 2. Iniciar el servidor PHP integrado
php -S localhost:8000 -t public
```

---

## 🗄️ Estructura del Proyecto (PHP Límpio)

```
spicycrust-game-api/
├── public/
│   └── index.php             # Entry point / Router HTTP PHP
├── database/
│   ├── schema.sql            # Esquema MySQL 8.0+ (Fase V2)
│   └── seed.sql              # Datos semilla iniciales
├── docs/
│   ├── API.md                # Especificación de Contratos JSON
│   └── SECURITY.md           # Políticas de Seguridad
├── storage/
│   └── db.json               # Persistencia atómica inicial JSON (V1)
├── ARCHITECTURE_PROPOSAL.md   # Arquitectura oficial
└── README.md
```
