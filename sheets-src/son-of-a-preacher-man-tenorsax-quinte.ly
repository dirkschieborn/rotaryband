\version "2.24.0"

% Son of a Preacher Man – Tenorsax-Stimme aus dem Bläsersatz
% (Horns Trans./Arr. Ryan Gabbart), komplett mit allen Pausentakten.
%
% Original: E-Dur klingend, Tenorsax notiert in Fis-Dur, Schluss in H-Dur.
% Hier eine Quinte höher: notiert Des-Dur, Schluss Fis-Dur
% (klingend H-Dur, Schluss E-Dur).
%
% Die Noten unten stehen wie im Original-PDF und werden im Score
% transponiert. Lage: eine Oktave unter der wörtlichen Quinte aufwärts –
% sonst läge fast alles oberhalb von F''' (Ges''' bis A''').
%
% PDF erzeugen:
%   lilypond -o public/sheets/son-of-a-preacher-man-tenorsax-quinte sheets-src/son-of-a-preacher-man-tenorsax-quinte.ly

\header {
  title = "Son of a Preacher Man"
  subtitle = "Tenorsax in B – eine Quinte höher"
  subsubtitle = "notiert Des-Dur, Schluss-Chorus Fis-Dur (klingend H-Dur / E-Dur)"
  composer = "Ronnie Wilkins, John Hurley"
  arranger = "Horns Trans./Arr. Ryan Gabbart · Stimme für 2R2B"
  tagline = \markup \small "Original: „Son of a Preacher Man – Horns“, RyanGabbart.com (E-Dur klingend)"
}

\paper {
  #(set-paper-size "a4")
  indent = 0
}

% Doppelvorzeichen, Eis/His/Ces/Fes nach dem Transponieren vereinfachen
% (nach LSR „Transposing pitches with minimum accidentals“)
#(define (naturalize-pitch p)
   (let ((o (ly:pitch-octave p))
         (a (* 4 (ly:pitch-alteration p)))
         (n (ly:pitch-notename p)))
     (cond
      ((and (> a 1) (or (eqv? n 6) (eqv? n 2)))
       (set! a (- a 2))
       (set! n (+ n 1)))
      ((and (< a -1) (or (eqv? n 0) (eqv? n 3)))
       (set! a (+ a 2))
       (set! n (- n 1))))
     (cond
      ((> a 2) (set! a (- a 4)) (set! n (+ n 1)))
      ((< a -2) (set! a (+ a 4)) (set! n (- n 1))))
     (if (< n 0) (begin (set! o (- o 1)) (set! n (+ n 7))))
     (if (> n 6) (begin (set! o (+ o 1)) (set! n (- n 7))))
     (ly:make-pitch o n (/ a 4))))

#(define (naturalize music)
   (let ((es (ly:music-property music 'elements))
         (e (ly:music-property music 'element))
         (p (ly:music-property music 'pitch)))
     (if (pair? es)
         (ly:music-set-property! music 'elements (map naturalize es)))
     (if (ly:music? e)
         (ly:music-set-property! music 'element (naturalize e)))
     (if (ly:pitch? p)
         (ly:music-set-property! music 'pitch (naturalize-pitch p)))
     music))

naturalizeMusic = #(define-music-function (m) (ly:music?) (naturalize m))

fall = \bendAfter #-4

sektion = #(define-music-function (buchstabe text) (string? string?)
  #{ \mark \markup { \box \bold #buchstabe \hspace #1 \bold #text } #})

chorus = {
  r2 r4 r8 fis''8-^\f |
  fis'4-> r4 r4 cis''16--\mf dis''8-. fis''16-- |
  r2 r4 r8 fis''8-^\f |
  fis'4-> r4 r2 |
}

schleife = {
  r2 r4 fis''16-- gis''8-. b''16->~ |
  b''2.. d'''8-> \fall |
}

% Takt 1–39 (Original Fis-Dur)
teilEins = {
  \key fis \major
  \tempo "Light R&B Shuffle" 4 = 88
  \mark \markup \bold "Intro"
  R1 | R1 | R1 | R1 |
  \bar "||"
  \sektion "A" "Verse"
  R1 | R1 | R1 | R1 |
  cis''1->\p\< | cis''1->\mp\< | gis''1->\mf\< |
  \bar "||"
  \sektion "B" "Chorus"
  \chorus
  r4 ais''4->\mf^\markup \tiny "scoop" r4 gis''4->( | fis''2) r2 |
  r4 bis'16-- cis''8-. fis''16->~ fis''2 |
  r4 d''16-- cis''8-. fis'16->~ fis'2\< |
  \bar "||"
  \sektion "C" "Verse"
  R1\! | R1 | R1 | R1 |
  cis''16->(\mp\< cis'' cis''8~ cis''2.) |
  gis''16->(\mf\< gis'' gis''8~ gis''2.) |
  \bar "||"
  \sektion "D" "Chorus"
  \chorus
  R1 | R1 |
  \bar "||"
  \sektion "E" "Bridge"
  r8 b''4.->\f b''16( b''-.) r16 b''-- r16 b''-- r16 b''-- |
  b''2-> r8. b''16-- r16 b''-- r16 b''-- |
  gis''1->~ |
  gis''2 r8. b''16-- r16 b''-- r16 b''-- |
  b''2.->~ b''8 ais''8^\markup \tiny "bend" |
  b''2-> r2 |
  e''1->\mf |
  ais''1->\< |
  \bar "||"
}

% Takt 40–57 (Original H-Dur)
teilZwei = {
  \key b \major
  \sektion "F" "Chorus"
  r2 r4 r8 b''8-^\f^\markup \tiny "rip" |
  b'4-> r4 r4 fis''16-- gis''8-. b''16-> \fall |
  r2 r4 r8 b''8-^ |
  b'4-> r4 r2 |
  R1 |
  r8 d''8->~\mf\< d''2 fis''16--\f gis''8-. b''16->~ |
  \bar "||"
  \sektion "G" "Ending"
  b''1~ |
  b''4 r4 r4 fis''16-- gis''8-. b'16->~ |
  b'2.. d''8-> \fall |
  r2 r4 fis''16-- gis''8-. b''16->~ |
  b''2.. d'''8-> \fall |
  \mark \markup \small \italic "beliebig oft wiederholen"
  \repeat volta 2 {
    \schleife
  }
  \alternative {
    { \schleife }
    {
      r2 r4 fis''16-- gis''8-. b''16-> \fall |
      r4 ais''4->^\markup \bold "C#7" \fall r4 gis''4\fermata^\markup \bold "B7" |
      a''1\fermata^\markup \bold "F#7" |
    }
  }
  \bar "|."
}

\score {
  \new Staff \with {
    instrumentName = ""
  } {
    \naturalizeMusic \transpose cis des \transpose c g, \teilEins
    \transpose c g, \teilZwei
  }
  \layout {
    \context {
      \Score
      \override RehearsalMark.self-alignment-X = #LEFT
      \override RehearsalMark.padding = #2
      \override BarNumber.break-visibility = #end-of-line-invisible
    }
  }
}
