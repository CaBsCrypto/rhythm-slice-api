# Rhythm Slice API — Documentación para Practicantes

API de puntajes y registro de jugadores del juego **Rhythm Slice (Guitar Pizza)**.

Este repositorio contiene la documentación técnica y los endpoints serverless listos para que el equipo de practicantes pueda consumir, probar y extender la API.

---

## 📄 Documentación

La especificación completa de la API con payloads, respuestas y ejemplos de cURL/Postman se encuentra en:

👉 **[api_score.md](./api_score.md)**

---

## 🚀 Endpoints Disponibles

| Método | Endpoint | Descripción |
| :--- | :--- | :--- |
| `POST` | `/api/submit-score` | Registrar puntaje + nombre + email del jugador |
| `GET` | `/api/leaderboard` | Consultar ranking de puntajes registrados |

---

## 🛠️ Cómo Ejecutar Localmente

```bash
# 1. Clonar el repositorio
git clone https://github.com/CaBsCrypto/rhythm-slice-api.git
cd rhythm-slice-api

# 2. Instalar dependencias
npm install

# 3. Iniciar el servidor de desarrollo
npx vercel dev
```

El servidor arrancará en `http://localhost:3000`.

---

## 🧪 Prueba Rápida con cURL

```bash
# Enviar un puntaje
curl -X POST http://localhost:3000/api/submit-score \
  -H "Content-Type: application/json" \
  -d '{"playerName":"Tester","playerEmail":"test@email.com","score":9999,"accuracy":99.1}'

# Consultar el leaderboard
curl http://localhost:3000/api/leaderboard
```

---

## 📁 Estructura del Proyecto

```
rhythm-slice-api/
├── api/
│   ├── submit-score.js    # Endpoint POST - registrar puntaje
│   └── leaderboard.js     # Endpoint GET  - consultar rankings
├── api_score.md           # Documentación técnica de la API
├── package.json
├── vercel.json
└── README.md
```

---

## 📜 Licencia

Proyecto interno de **Stellar Game Studio / AntiGravity**.
