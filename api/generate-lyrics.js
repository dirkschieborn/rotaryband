export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    return res.status(500).json({ error: 'OpenAI API key not configured' });
  }

  try {
    const { bride, groom, story, language, mood } = req.body;

    if (!bride || !groom) {
      return res.status(400).json({ error: 'Bride and groom names are required' });
    }

    const prompt = `Schreibe einen Text für einen Hochzeitssong über ${bride} und ${groom}. Die Sprache der Lyrics soll ${language || 'Deutsch'} sein und die Stimmung "${mood || 'positiv und energetisch'}". Die Lyrics sollten sich möglichst gut reimen und cool sein. ${story || ''}`;

    const response = await fetch('https://api.openai.com/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        model: 'gpt-4o',
        messages: [
          {
            role: 'system',
            content: 'Du bist ein kreativer Songwriter. Du schreibst Songtexte für Hochzeiten. Die Texte sollen emotional, persönlich und gut gereimt sein. Schreibe nur die Lyrics (Verse, Refrain, Bridge), keine Erklärungen oder Anmerkungen.',
          },
          {
            role: 'user',
            content: prompt,
          },
        ],
        temperature: 0.9,
        max_tokens: 1500,
      }),
    });

    if (!response.ok) {
      const err = await response.text();
      console.error('OpenAI error:', err);
      return res.status(500).json({ error: 'OpenAI API error' });
    }

    const data = await response.json();
    const lyrics = data.choices?.[0]?.message?.content?.trim() || '';

    return res.status(200).json({ status: 'ok', lyrics });
  } catch (error) {
    console.error('Generate lyrics error:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
}
