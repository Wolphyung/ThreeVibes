const Groq = require('groq-sdk');
const { tavily } = require('@tavily/core');
const repo = require('./chatbot.repository');

const chat = async (userMessage, codedossier = null) => {
  const client = new Groq({ apiKey: process.env.GROQ_API_KEY });
  const tavilyClient = tavily({ apiKey: process.env.TAVILY_API_KEY });

  let context = '';
  let source = 'connaissances générales'; // Source par défaut

  // 1. Priorité : Recherche d'un dossier PRÉCIS en DB
  if (codedossier) {
    const dossier = await repo.findDossierByCode(codedossier);
    if (dossier) {
      context = `Dossier : ${dossier.nomdossier}\nInstructions : ${dossier.instructions}`;
      source = 'base de données';
    }
  }

  // 2. Si aucun dossier précis n'est trouvé (ou si codedossier est nul), on va sur INTERNET
  if (!context) {
    try {
      const searchResult = await tavilyClient.search(userMessage, {
        searchDepth: 'advanced',
        includeDomains: ['torolalana.gov.mg'],
        maxResults: 5
      });

      if (searchResult.results && searchResult.results.length > 0) {
        context = searchResult.results.map(r => `Source: ${r.url}\n${r.content}`).join('\n\n');
        // On récupère l'URL du premier résultat pour être plus précis
        source = `internet (${searchResult.results[0].url})`;
      }
    } catch (err) {
      console.error('Tavily error:', err.message);
    }
  }

  // 3. Fallback : Recherche générale si toujours rien
  if (!context) {
    try {
      const searchResult = await tavilyClient.search(
        `dossier administratif Madagascar ${userMessage}`,
        { searchDepth: 'basic', maxResults: 3 }
      );
      if (searchResult.results && searchResult.results.length > 0) {
        context = searchResult.results.map(r => `Source: ${r.url}\n${r.content}`).join('\n\n');
        source = 'internet (recherche générale)';
      }
    } catch (err) {
      console.error('Tavily fallback error:', err.message);
    }
  }

  // 4. Synthèse finale
  const result = await client.chat.completions.create({
    model: 'llama-3.3-70b-versatile',
    messages: [
      {
        role: 'system',
        content: `Tu es un assistant administratif expert à Madagascar.
        Source actuelle des données : ${source}
        
        Contexte :
        ${context || "Utilise tes connaissances générales sur l'administration malgache."}
        
        Réponds toujours en français.`
      },
      { role: 'user', content: userMessage }
    ],
    max_tokens: 1024,
    temperature: 0.7
  });

  return {
    response: result.choices[0].message.content,
    source: source // Retourne la source finale mise à jour
  };
};

module.exports = { chat };