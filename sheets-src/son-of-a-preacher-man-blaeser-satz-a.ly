\version "2.24.0"

% Son of a Preacher Man – Bläsersatz (Horns Trans./Arr. Ryan Gabbart)
% Original: E-Dur klingend, Schluss-Chorus in A-Dur.
% Hier eine Quarte höher: A-Dur klingend, Schluss-Chorus in D-Dur.
%
% Die Stimmen unten sind so notiert wie im Original-PDF (Trompete und
% Tenorsax in B, Posaune klingend) und werden im Score mit
% \transpose c f eine Quarte nach oben gesetzt.
% \tiefer = Stelle eine Oktave tiefer als das Original (sonst zu hoch).
%
% PDF erzeugen:
%   lilypond -o public/sheets/son-of-a-preacher-man-blaeser-satz-a sheets-src/son-of-a-preacher-man-blaeser-satz-a.ly

\header {
  title = "Son of a Preacher Man"
  subtitle = "Bläsersatz – eine Quarte höher (klingend A-Dur, Schluss-Chorus D-Dur)"
  composer = "Ronnie Wilkins, John Hurley"
  arranger = "Horns Trans./Arr. Ryan Gabbart · transponiert für 2R2B"
  tagline = \markup \small \center-column {
    "Original: „Son of a Preacher Man – Horns“, RyanGabbart.com (E-Dur klingend)"
    "Trompete T. 11, 40–43 und 51–55 sowie Tenorsax-Achtel T. 50/52/54 eine Oktave tiefer als im Original (Lage)"
  }
}

\paper {
  #(set-paper-size "a4")
  indent = 22\mm
  short-indent = 10\mm
}

tiefer = #(define-music-function (music) (ly:music?)
  #{ \transpose c c, { $music } #})

fall = \bendAfter #-4

sektion = #(define-music-function (buchstabe text) (string? string?)
  #{ \mark \markup { \box \bold #buchstabe \hspace #1 \bold #text } #})

% ---------------------------------------------------------------- Trompete

tptChorus = {
  r2 r4 r8 fis''8-^\f |
  fis'4-> r4 r4 cis'16--\mf dis'8-. fis'16-- |
  r2 r4 r8 fis''8-^\f |
  fis'4-> r4 r2 |
}

tptSchleife = {
  r2 r4 fis''16-- gis''8-. b''16->~ |
  b''2.. e'''8-> \fall |
}

trompete = {
  \key fis \major
  \tempo "Light R&B Shuffle" 4 = 88
  \mark \markup \bold "Intro"
  R1*4
  \sektion "A" "Verse"
  R1*4 |
  cis''1->\p\< | eis''1->\mp\< | \tiefer { cis'''1->\mf\< } |
  \bar "||"
  \sektion "B" "Chorus"
  \tptChorus
  r4 fis'4->\mf^\markup \tiny "scoop" r4 eis'4->( | dis'2) r2 |
  r4 bis'16-- cis''8-. fis''16->~ fis''2 |
  r4 d''16-- cis''8-. fis'16->~ fis'2\< |
  \bar "||"
  \sektion "C" "Verse"
  R1*4\! |
  cis''16->(\mp\< cis'' cis''8~ cis''2.) |
  eis''16->(\mf\< eis'' eis''8~ eis''2.) |
  \bar "||"
  \sektion "D" "Chorus"
  \tptChorus
  R1*2 |
  \bar "||"
  \sektion "E" "Bridge"
  r8 e''4.->\f e''16( e''-.) r16 e''-- r16 e''-- r16 e''-- |
  e''2-> r8. e''16-- r16 e''-- r16 e''-- |
  dis''1->~ |
  dis''2 r8. dis''16-- r16 dis''-- r16 dis''-- |
  eis''2.->~ eis''8 e''8^\markup \tiny "bend" |
  eis''2-> r2 |
  ais'1->\mf |
  fis''1->\< |
  \bar "||"
  \key b \major
  \sektion "F" "Chorus"
  \tiefer {
    r2 r4 r8 b''8-^\f^\markup \tiny "rip" |
    b'4-> r4 r4 fis'16-- gis'8-. b'16-> \fall |
    r2 r4 r8 b''8-^ |
    b'4-> r4 r2 |
  }
  R1 |
  r8 gis'8->~\mf\< gis'2 fis'16--\f gis'8-. b'16->~ |
  \bar "||"
  \sektion "G" "Ending"
  b'1~ |
  b'4 r4 r4 fis'16-- gis'8-. b16->~ |
  b2.. d'8-> \fall |
  r2 r4 fis'16-- gis'8-. b'16->~ |
  b'2.. e''8-> \fall |
  \mark \markup \small \italic "beliebig oft wiederholen"
  \repeat volta 2 {
    \tiefer \tptSchleife
  }
  \alternative {
    { \tiefer \tptSchleife }
    {
      \tiefer { r2 r4 fis''16-- gis''8-. b''16-> \fall | }
      r4 e''4->^\markup \bold "B7" \fall r4 e''4\fermata^\markup \bold "A7" |
      fis''1\fermata^\markup \bold "E7" |
    }
  }
  \bar "|."
}

% ---------------------------------------------------------------- Tenorsax

saxChorus = {
  r2 r4 r8 fis''8-^\f |
  fis'4-> r4 r4 cis''16--\mf dis''8-. fis''16-- |
  r2 r4 r8 fis''8-^\f |
  fis'4-> r4 r2 |
}

saxSchleife = {
  r2 r4 fis''16-- gis''8-. b''16->~ |
  b''2.. \tiefer { d'''8-> \fall } |
}

tenorsax = {
  \key fis \major
  R1*4 |
  R1*4 |
  cis''1->\p\< | cis''1->\mp\< | gis''1->\mf\< |
  \saxChorus
  r4 ais''4->\mf^\markup \tiny "scoop" r4 gis''4->( | fis''2) r2 |
  r4 bis'16-- cis''8-. fis''16->~ fis''2 |
  r4 d''16-- cis''8-. fis'16->~ fis'2\< |
  R1*4\! |
  cis''16->(\mp\< cis'' cis''8~ cis''2.) |
  gis''16->(\mf\< gis'' gis''8~ gis''2.) |
  \saxChorus
  R1*2 |
  r8 b''4.->\f b''16( b''-.) r16 b''-- r16 b''-- r16 b''-- |
  b''2-> r8. b''16-- r16 b''-- r16 b''-- |
  gis''1->~ |
  gis''2 r8. b''16-- r16 b''-- r16 b''-- |
  b''2.->~ b''8 ais''8^\markup \tiny "bend" |
  b''2-> r2 |
  e''1->\mf |
  ais''1->\< |
  \key b \major
  r2 r4 r8 b''8-^\f^\markup \tiny "rip" |
  b'4-> r4 r4 fis''16-- gis''8-. b''16-> \fall |
  r2 r4 r8 b''8-^ |
  b'4-> r4 r2 |
  R1 |
  r8 d''8->~\mf\< d''2 fis''16--\f gis''8-. b''16->~ |
  b''1~ |
  b''4 r4 r4 fis''16-- gis''8-. b'16->~ |
  b'2.. d''8-> \fall |
  r2 r4 fis''16-- gis''8-. b''16->~ |
  b''2.. \tiefer { d'''8-> \fall } |
  \repeat volta 2 {
    \saxSchleife
  }
  \alternative {
    { \saxSchleife }
    {
      r2 r4 fis''16-- gis''8-. b''16-> \fall |
      r4 ais''4->^\markup \bold "B7" \fall r4 gis''4\fermata^\markup \bold "A7" |
      a''1\fermata^\markup \bold "E7" |
    }
  }
}

% ---------------------------------------------------------------- Posaune

posChorus = {
  r2 r4 r8 e8-^\f |
  e,4-> r4 r4 b,16--\mf cis8-. e16-- |
  r2 r4 r8 e8-^\f |
  e,4-> r4 r2 |
}

posSchleife = {
  r2 r4 e16-- fis8-. a16->~ |
  a2.. d'8-> \fall |
}

posaune = {
  \clef bass
  \key e \major
  R1*4 |
  R1*4 |
  b1->\p\< | b1->\mp\< | dis'1->\mf\< |
  \posChorus
  r4 cis'4->\mf^\markup \tiny "scoop" r4 b4->( | a2) r2 |
  r4 ais,16-- b,8-. e16->~ e2 |
  r4 c16-- b,8-. e,16->~ e,2\< |
  R1*4\! |
  b16->(\mp\< b b8~ b2.) |
  dis'16->(\mf\< dis' dis'8~ dis'2.) |
  \posChorus
  R1*2 |
  d,1->\f~ |
  d,2 r2 |
  a,1->~ |
  a,2 r8. a,16-- r16 a,-- r16 a,-- |
  b,2.->~ b,8 a,8 |
  b,2-> r2 |
  e,1->\mf |
  d'1->\< |
  \key a \major
  r2 r4 r8 a8-^\f^\markup \tiny "rip" |
  a,4-> r4 r4 e16-- fis8-. a16-> \fall |
  r2 r4 r8 a8-^ |
  a,4-> r4 r2 |
  R1 |
  r8 a8->~\mf\< a2 e16--\f fis8-. a16->~ |
  a1~ |
  a4 r4 r4 e16-- fis8-. a,16->~ |
  a,2.. a,8-> \fall |
  r2 r4 e16-- fis8-. a16->~ |
  a2.. d'8-> \fall |
  \repeat volta 2 {
    \posSchleife
  }
  \alternative {
    { \posSchleife }
    {
      r2 r4 e16-- fis8-. a16-> \fall |
      r4 b4->^\markup \bold "A7" \fall r4 c'4\fermata^\markup \bold "G7" |
      cis'1\fermata^\markup \bold "D7" |
    }
  }
}

% ---------------------------------------------------------------- Score

\score {
  \new StaffGroup <<
    \new Staff \with {
      instrumentName = "Trompete in B"
      shortInstrumentName = "Tpt."
    } \transpose c f \trompete
    \new Staff \with {
      instrumentName = "Tenorsax"
      shortInstrumentName = "T. Sax"
    } \transpose c f \tenorsax
    \new Staff \with {
      instrumentName = "Posaune"
      shortInstrumentName = "Pos."
    } \transpose c f \posaune
  >>
  \layout {
    \context {
      \Score
      skipBars = ##t
      \override RehearsalMark.self-alignment-X = #LEFT
      \override RehearsalMark.padding = #2
      \override MultiMeasureRest.expand-limit = #1
    }
  }
}
