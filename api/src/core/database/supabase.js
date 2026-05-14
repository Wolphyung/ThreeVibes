const { createClient } = require('@supabase/supabase-js');
const { SUPABASE } = require('../config/env');
const WebSocket = require('ws'); // Ensure this is imported

if (!SUPABASE.url || !SUPABASE.key) {
  console.warn('Supabase credentials are missing.');
}

const supabase = createClient(SUPABASE.url, SUPABASE.key, {
  auth: {
    persistSession: false, // Good practice for Node.js
  },
  realtime: {
    transport: WebSocket,
  },
});

// console.log(supabase.storage)

module.exports = supabase;