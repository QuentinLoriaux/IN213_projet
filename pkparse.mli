type token =
  | INT of (int)
  | IDENT of (string)
  | STRING of (string)
  | NOTE of (string)
  | INSTRUMENT
  | CHORD
  | PHRASE
  | SHEET
  | MAIN
  | EQUAL
  | LPAR
  | RPAR
  | LBRA
  | RBRA
  | COMA
  | SEMI
  | SHARP
  | TITLE
  | COMPOSER
  | ARRANGER
  | BPM
  | REPEAT
  | PLAY
  | PRINT

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Pkast.expr
