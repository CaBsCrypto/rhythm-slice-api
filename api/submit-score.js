const { neon } = require('@neondatabase/serverless');

// Base de datos Neon Postgres si existe DATABASE_URL, POSTGRES_URL o POSTGRES_URL_NON_POOLING
const getDb = () => {
  const dbUrl = process.env.DATABASE_URL || process.env.POSTGRES_URL || process.env.POSTGRES_URL_NON_POOLING;
  if (dbUrl) {
    return neon(dbUrl);
  }
  return null;
};

// Fallback en memoria si aún no han puesto la DATABASE_URL
global.scoresMemoryDb = global.scoresMemoryDb || [];

async function ensureTableExists(sql) {
  if (!sql) return;
  try {
    await sql`
      CREATE TABLE IF NOT EXISTS scores (
        id VARCHAR(64) PRIMARY KEY,
        player_name VARCHAR(100) NOT NULL,
        player_email VARCHAR(150) NOT NULL,
        wallet_address VARCHAR(100),
        score INT NOT NULL,
        accuracy FLOAT NOT NULL,
        song_id VARCHAR(50),
        difficulty VARCHAR(20),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
      );
    `;
  } catch (err) {
    console.error('Error al inicializar la tabla de Neon Postgres:', err);
  }
}

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

      const id = `rec_${Date.now()}_${Math.random().toString(36).substring(2, 7)}`;
      const name = String(playerName).trim();
      const email = String(playerEmail).trim().toLowerCase();
      const wallet = walletAddress || null;
      const finalScore = Number(score) || 0;
      const finalAcc = Number(accuracy) || 0;
      const song = songId || 'default_song';
      const diff = difficulty || 'normal';
      const createdAt = new Date().toISOString();

      const sql = getDb();

      if (sql) {
        // Conexión real a Neon Database (PostgreSQL)
        await ensureTableExists(sql);
        await sql`
          INSERT INTO scores (id, player_name, player_email, wallet_address, score, accuracy, song_id, difficulty, created_at)
          VALUES (${id}, ${name}, ${email}, ${wallet}, ${finalScore}, ${finalAcc}, ${song}, ${diff}, ${createdAt})
        `;
      } else {
        // Fallback a memoria si no hay DATABASE_URL en Vercel aún
        global.scoresMemoryDb.push({
          id,
          playerName: name,
          playerEmail: email,
          walletAddress: wallet,
          score: finalScore,
          accuracy: finalAcc,
          songId: song,
          difficulty: diff,
          createdAt
        });
      }

      return res.status(201).json({
        success: true,
        message: 'Puntaje y datos de contacto registrados exitosamente',
        storage: sql ? 'Neon Postgres' : 'Memory Fallback',
        record: {
          id,
          playerName: name,
          playerEmail: email,
          walletAddress: wallet,
          score: finalScore,
          accuracy: finalAcc,
          songId: song,
          difficulty: diff,
          createdAt
        }
      });
    } catch (err) {
      return res.status(500).json({ error: 'Error procesando la solicitud en Neon Postgres', details: err.message });
    }
  }

  return res.status(405).json({ error: 'Método no permitido' });
};
