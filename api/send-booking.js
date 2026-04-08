export default async function handler(req, res) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  // Mailversand vorübergehend deaktiviert
  return res.status(200).json({ status: 'ok' });
}
