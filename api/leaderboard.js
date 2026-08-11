const { neon } = require('@neondatabase/serverless');

const getDb = () => {
  if (process.env.DATABASE_URL) {
    return neon(process.env.DATABASE_URL);
  }
  return null;
};

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
    try {
      const sql = getDb();

      if (sql) {
        // Consultar de Neon Postgres
        const records = await sql`
          SELECT 
            id,
            player_name AS "playerName",
            player_email AS "playerEmail",
            wallet_address AS "walletAddress",
            score,
            accuracy,
            song_id AS "songId",
            difficulty,
            created_at AS "createdAt"
          FROM scores
          ORDER BY score DESC
          LIMIT 100
        `;

        return res.status(200).json({
          success: true,
          description: 'API de registros de jugadores de Rhythm Slice / Guitar Pizza (Neon Postgres)',
          totalRecords: records.length,
          records
        });
      } else {
        // Fallback a memoria si no hay DATABASE_URL
        const sortedRecords = [...global.scoresMemoryDb].sort((a, b) => b.score - a.score);
        return res.status(200).json({
          success: true,
          description: 'API de registros de jugadores de Rhythm Slice / Guitar Pizza (Memory Fallback)',
          totalRecords: sortedRecords.length,
          records: sortedRecords
        });
      }
    } catch (err) {
      return res.status(500).json({ error: 'Error al consultar Neon Postgres', details: err.message });
    }
  }

  return res.status(405).json({ error: 'Método no permitido' });
};
