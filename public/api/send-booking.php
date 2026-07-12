<?php
// Nimmt Booking-Anfragen als JSON entgegen und schickt sie per Mail an die Band.
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
if (!is_array($data)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid JSON']);
    exit;
}

// Zeilenumbrüche entfernen (Schutz vor Header-Injection), Werte begrenzen
function clean($value, $maxLen = 500) {
    $value = trim(str_replace(["\r", "\n"], ' ', (string)($value ?? '')));
    return mb_substr($value, 0, $maxLen);
}

$name      = clean($data['name'] ?? '', 200);
$email     = clean($data['email'] ?? '', 200);
$phone     = clean($data['phone'] ?? '', 100);
$date      = clean($data['date'] ?? '', 50);
$eventType = clean($data['eventType'] ?? '', 50);
$location  = clean($data['location'] ?? '', 300);
$guests    = clean($data['guests'] ?? '', 20);
$message   = trim((string)($data['message'] ?? ''));
$message   = mb_substr($message, 0, 5000);

if ($name === '' || $email === '' || $message === '' || !filter_var($email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(['error' => 'Name, gültige E-Mail und Nachricht sind Pflichtfelder']);
    exit;
}

$eventLabels = [
    'hochzeit'    => 'Hochzeit',
    'firmenevent' => 'Firmenevent',
    'festival'    => 'Festival / Stadtfest',
    'privat'      => 'Private Feier',
    'sonstiges'   => 'Sonstiges',
];

$body = "Neue Booking-Anfrage über rotary-band.de\n"
      . "==========================================\n\n"
      . "Name:        $name\n"
      . "E-Mail:      $email\n"
      . "Telefon:     " . ($phone ?: '–') . "\n"
      . "Wunschtermin: " . ($date ?: '–') . "\n"
      . "Art des Events: " . ($eventLabels[$eventType] ?? $eventType ?: '–') . "\n"
      . "Location/Ort: " . ($location ?: '–') . "\n"
      . "Gäste (ca.): " . ($guests ?: '–') . "\n\n"
      . "Nachricht:\n$message\n";

$subject = '=?UTF-8?B?' . base64_encode("Booking-Anfrage von $name" . ($date ? " ($date)" : '')) . '?=';

$headers = "From: Rotary Band Website <noreply@rotary-band.de>\r\n"
         . "Reply-To: $name <$email>\r\n"
         . "Content-Type: text/plain; charset=utf-8\r\n"
         . "Content-Transfer-Encoding: 8bit";

$sent = mail('info@rotary-band.de', $subject, $body, $headers);

if ($sent) {
    echo json_encode(['status' => 'ok']);
} else {
    http_response_code(500);
    echo json_encode(['error' => 'Mail konnte nicht versendet werden']);
}
