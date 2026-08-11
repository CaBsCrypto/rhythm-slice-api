// Objeto de almacenamiento compartido en memoria global del proceso Node.js
global.scoresMemoryDb = global.scoresMemoryDb || [];

module.exports = async function handler(req, res) {
  // CORS Headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'POST') {
    try {
      const { playerName, playerEmail, walletAddress, score, accuracy, songId, difficulty } = req.body || {};

      if (!playerName || !playerEmail) {
        return res.status(400).json({ 
          error: 'Campos requeridos faltantes: playerName y playerEmail son obligatorios.' 
        });
      }

      const newRecord = {
        id: `rec_${Date.now()}_${Math.random().toString(36).substring(2, 7)}`,
        playerName: String(playerName).trim(),
        playerEmail: String(playerEmail).trim().toLowerCase(),
        walletAddress: walletAddress || null,
        score: Number(score) || 0,
        accuracy: Number(accuracy) || 0,
        songId: songId || 'default_song',
        difficulty: difficulty || 'normal',
        timestamp: Math.floor(Date.now() / 1000),
        createdAt: new Date().toISOString()
      };

      global.scoresMemoryDb.push(newRecord);

      return res.status(201).json({
        success: true,
        message: 'Puntaje y datos de contacto registrados exitosamente',
        record: newRecord
      });
    } catch (err) {
      return res.status(500).json({ error: 'Error procesando la solicitud', details: err.message });
    }
  }

  return res.status(405).json({ error: 'Método no permitido' });
};
