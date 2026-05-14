const { Pool } = require('pg');
const { DB } = require('../config/env');

const pool = new Pool({
  user: DB.user,
  host: DB.host,
  database: DB.database,
  password: DB.password,
  port: DB.port,
});

// Test connection
pool.on('connect', () => {
  console.log('PostgreSQL database connected successfully');
});

pool.on('error', (err) => {
  console.error('Unexpected error on idle client', err);
  process.exit(-1);
});

module.exports = {
  query: (text, params) => pool.query(text, params),
  pool,
};
