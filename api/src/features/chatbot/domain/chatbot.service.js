const Groq = require('groq-sdk');
const { tavily } = require('@tavily/core');
const repo = require('./chatbot.repository');

const chat = async (userMessage, codedossier = null) => {
  const client = new Groq({ apiKey: process.env.GROQ_API_KEY });
  const tavilyClient = tavily({ apiKey: process.env.TAVILY_API_KEY });

  let context = '';
  let source = '';

  // 1. Cherche dans la DB d'abord
  if (codedossier) {
    const dossier = await repo.findDossierByCode(codedossier);
    if (dossier) {
      context = `Dossier : ${dossier.nomdossier}\nInstructions : ${dossier.instructions}`;
      source = 'base de données';
    }
  } else {
    const dossiers = await repo.findAllDossiers();
    if (dossiers.length > 0) {
      context = dossiers.map(d =>
        `Dossier "${d.nomdossier}" (${d.codedossier}): ${d.instructions}`
      ).join('\n');
      source = 'base de données';
    }
  }

  // 2. Si pas trouvé en DB → recherche web
  if (!context) {
    try {
      const searchResult = await tavilyClient.search(userMessage, {
        searchDepth: 'advanced',
        includeDomains: ['torolalana.gov.mg'],
        maxResults: 5
      });

      if (searchResult.results.length > 0) {
        context = searchResult.results.map(r =>
          `Source: ${r.url}\n${r.content}`
        ).join('\n\n');
        source = 'internet (torolalana.gov.mg)';
      }
    } catch (err) {
      console.error('Tavily error:', err.message);
    }
  }

  // 3. Si toujours rien → recherche web générale
  if (!context) {
    try {
      const searchResult = await tavilyClient.search(
        `dossier administratif Madagascar ${userMessage}`,
        { searchDepth: 'basic', maxResults: 3 }
      );
      if (searchResult.results.length > 0) {
        context = searchResult.results.map(r =>
          `Source: ${r.url}\n${r.content}`
        ).join('\n\n');
        source = 'internet (recherche générale)';
      }
    } catch (err) {
      console.error('Tavily fallback error:', err.message);
    }
  }

  // 4. Groq synthétise
  const result = await client.chat.completions.create({
    model: 'llama-3.3-70b-versatile',
    messages: [
      {
        role: 'system',
        content: `Tu es un assistant administratif spécialisé dans la préparation 
        de dossiers administratifs et publics à Madagascar. 
        Réponds toujours en français, de manière claire et précise.
        Aide l'utilisateur à comprendre les documents requis et les étapes à suivre.
        
        Informations disponibles (source: ${source}) :
        ${context || "Aucune information spécifique trouvée. Réponds avec tes connaissances générales."}
        
        Si la question sort du cadre administratif, redirige poliment l'utilisateur.`
      },
      {
        role: 'user',
        content: userMessage
      }
    ],
    max_tokens: 1024,
    temperature: 0.7
  });

  return {
    response: result.choices[0].message.content,
    source
  };
};

module.exports = { chat };