# Documentación Técnica de API - Rhythm Slice (Guitar Pizza)

Especificación técnica de los endpoints de la API para el **Equipo Backend / API**.

---

## 1. Endpoints Base (Rutas Relativas)

Todas las peticiones utilizan **rutas relativas** estándar. Funcionan de manera transparente tanto en entornos de desarrollo como en producción Vercel:

- **Formatos:** JSON (`Content-Type: application/json`).
- **Ruta de Producción en Vercel:** `/api/...`

---

## 2. Endpoints Disponibles

### A. Enviar Puntaje y Datos de Jugador (`POST /api/submit-score`)

Registra el puntaje del jugador al finalizar una partida junto con su correo y nombre.

* **Endpoint:** `/api/submit-score`
* **Método:** `POST`
* **Headers:** `Content-Type: application/json`

#### Payload de Ejemplo (Request):
```json
{
  "playerName": "Mario Rossi",
  "playerEmail": "mario@pizzeria.com",
  "walletAddress": "0x71C7656EC7ab88b098defB751B7401B5f6d8976F",
  "score": 14250,
  "accuracy": 98.4,
  "songId": "tarantella_hard",
  "difficulty": "hard"
}
```

#### Respuesta de Éxito (`201 Created`):
```json
{
  "success": true,
  "message": "Puntaje y datos de contacto registrados exitosamente",
  "record": {
    "id": "rec_1770769200000_a1b2c",
    "playerName": "Mario Rossi",
    "playerEmail": "mario@pizzeria.com",
    "walletAddress": "0x71C7656EC7ab88b098defB751B7401B5f6d8976F",
    "score": 14250,
    "accuracy": 98.4,
    "songId": "tarantella_hard",
    "difficulty": "hard",
    "timestamp": 1770769200,
    "createdAt": "2026-08-10T20:20:00.000Z"
  }
}
```

---

### B. Consultar Registros de Jugadores (`GET /api/leaderboard`)

Obtiene la lista de los mejores puntajes y correos registrados.

* **Endpoint:** `/api/leaderboard`
* **Método:** `GET`

#### Respuesta de Éxito (`200 OK`):
```json
{
  "success": true,
  "description": "API de registros de jugadores de Rhythm Slice / Guitar Pizza",
  "totalRecords": 1,
  "records": [
    {
      "id": "rec_1770769200000_a1b2c",
      "playerName": "Mario Rossi",
      "playerEmail": "mario@pizzeria.com",
      "score": 14250,
      "accuracy": 98.4,
      "createdAt": "2026-08-10T20:20:00.000Z"
    }
  ]
}
```

---

## 3. Código de Integración Estándar

Llamada limpia con ruta relativa `/api/...`:

```typescript
const response = await fetch('/api/submit-score', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    playerName: name,
    playerEmail: email,
    walletAddress: userWalletAddress,
    score: finalScore,
    accuracy: hitAccuracy,
    songId: 'song_01',
    difficulty: 'medium'
  }),
});

const data = await response.json();
console.log('Registro exitoso:', data);
```

---

## 4. Guía de Pruebas con Postman y cURL

¡Sí! La API es **100% testeable directamente con Postman, Bruno, Insomnia o cURL**.

### A. Prueba de Registro (`POST /api/submit-score`)

- **Método en Postman:** `POST`
- **URL:** `https://guitar-pizza-antigravity.vercel.app/api/submit-score` (o `http://localhost:3000/api/submit-score`)
- **Headers:** `Content-Type: application/json`
- **Body (raw JSON):**
  ```json
  {
    "playerName": "Tester Postman",
    "playerEmail": "test@postman.com",
    "walletAddress": "0x1234567890abcdef",
    "score": 9999,
    "accuracy": 99.1,
    "songId": "song_test",
    "difficulty": "hard"
  }
  ```

#### Comando cURL para Terminal:
```bash
curl -X POST https://guitar-pizza-antigravity.vercel.app/api/submit-score \
  -H "Content-Type: application/json" \
  -d '{"playerName":"Tester","playerEmail":"test@postman.com","score":9999,"accuracy":99.1}'
```

---

### B. Prueba de Consulta de Rankings (`GET /api/leaderboard`)

- **Método en Postman:** `GET`
- **URL:** `https://guitar-pizza-antigravity.vercel.app/api/leaderboard`

#### Comando cURL para Terminal:
```bash
curl -X GET https://guitar-pizza-antigravity.vercel.app/api/leaderboard
```
