export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const apiKey = process.env.RESEND_API_KEY;
  if (!apiKey) {
    return res.status(500).json({ error: 'Resend API key not configured' });
  }

  try {
    const { bride, groom, lyrics, style, email } = req.body;

    if (!bride || !groom || !lyrics || !style) {
      return res.status(400).json({ error: 'Alle Felder sind erforderlich' });
    }

    const response = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        from: 'Once In A Lifetime Song <onboarding@resend.dev>',
        to: 'dirkschieborn@googlemail.com',
        subject: `Once In A Lifetime Song – ${bride} & ${groom}`,
        text: `Neue Song-Anfrage über den Lyrics Generator\n\n` +
              `Namen: ${bride} & ${groom}\n` +
              `Musikstil: ${style}\n` +
              (email ? `Kontakt-Email: ${email}\n` : '') +
              `\n--- Lyrics ---\n\n${lyrics}\n`,
      }),
    });

    if (!response.ok) {
      const err = await response.text();
      console.error('Resend error:', err);
      return res.status(500).json({ error: 'Fehler beim Mailversand' });
    }

    return res.status(200).json({ status: 'ok' });
  } catch (error) {
    console.error('Send song error:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
}
