global.scoresMemoryDb = global.scoresMemoryDb || [];

module.exports = async function handler(req, res) {
  // CORS Headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method === 'GET') {
    // Retorna todos los puntajes guardados, ordenados descendentemente por puntaje
    const sortedRecords = [...global.scoresMemoryDb].sort((a, b) => b.score - a.score);

    return res.status(200).json({
      success: true,
      description: 'API de registros de jugadores de Rhythm Slice / Guitar Pizza para Practicantes',
      totalRecords: sortedRecords.length,
      records: sortedRecords
    });
  }

  return res.status(405).json({ error: 'Método no permitido' });
};
