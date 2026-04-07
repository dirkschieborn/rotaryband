export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const apiKey = process.env.RESEND_API_KEY;
  if (!apiKey) {
    return res.status(500).json({ error: 'Resend API key not configured' });
  }

  try {
    const { name, email, phone, message, wunschtermin, kalkulation } = req.body;

    if (!name || !email) {
      return res.status(400).json({ error: 'Pflichtfelder fehlen' });
    }

    const response = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        from: 'Dropzone Kostenrechner <kostenrechner@dropzone-band.de>',
        to: 'info@dropzone-band.de',
        subject: `Kostenrechner – Verfügbarkeitsanfrage${wunschtermin ? ` am ${wunschtermin}` : ''}`,
        text:
          `Neue Verfügbarkeitsanfrage über den Kostenrechner\n` +
          `==================================================\n\n` +
          `Name: ${name}\n` +
          `E-Mail: ${email}\n` +
          (phone ? `Telefon: ${phone}\n` : '') +
          (wunschtermin ? `Wunschtermin: ${wunschtermin}\n` : '') +
          (kalkulation ? `\n--- Kalkulation ---\n\n${kalkulation}\n` : '') +
          (message ? `\n--- Nachricht ---\n\n${message}\n` : ''),
      }),
    });

    if (!response.ok) {
      const err = await response.text();
      console.error('Resend error:', err);
      return res.status(500).json({ error: 'Fehler beim Mailversand' });
    }

    return res.status(200).json({ status: 'ok' });
  } catch (error) {
    console.error('Send kostenrechner error:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
}
