export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const apiKey = process.env.RESEND_API_KEY;
  if (!apiKey) {
    return res.status(500).json({ error: 'Resend API key not configured' });
  }

  try {
    const { name, email, phone, date, eventType, location, guests, message, proberaum } = req.body;

    if (!name || !email || !date || !eventType || !message) {
      return res.status(400).json({ error: 'Pflichtfelder fehlen' });
    }

    const eventLabels = {
      hochzeit: 'Hochzeit',
      firmenevent: 'Firmenevent',
      festival: 'Festival / Stadtfest',
      privat: 'Private Feier',
      sonstiges: 'Sonstiges',
    };

    const response = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify({
        from: 'Dropzone Booking <onboarding@resend.dev>',
        to: 'dirkschieborn@googlemail.com',
        subject: `Neue Booking-Anfrage: ${eventLabels[eventType] || eventType} am ${date}`,
        text:
          `Neue Booking-Anfrage über dropzone-band.de\n` +
          `==========================================\n\n` +
          `Name: ${name}\n` +
          `E-Mail: ${email}\n` +
          (phone ? `Telefon: ${phone}\n` : '') +
          `Wunschtermin: ${date}\n` +
          `Art des Events: ${eventLabels[eventType] || eventType}\n` +
          (location ? `Location / Ort: ${location}\n` : '') +
          (guests ? `Anzahl Gäste: ${guests}\n` : '') +
          (proberaum ? `Proberaumkonzert: Ja, hat Interesse\n` : '') +
          `\n--- Nachricht ---\n\n${message}\n`,
      }),
    });

    if (!response.ok) {
      const err = await response.text();
      console.error('Resend error:', err);
      return res.status(500).json({ error: 'Fehler beim Mailversand' });
    }

    return res.status(200).json({ status: 'ok' });
  } catch (error) {
    console.error('Send booking error:', error);
    return res.status(500).json({ error: 'Internal server error' });
  }
}
