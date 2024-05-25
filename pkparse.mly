%{
open Pkast ;;

%}


%token <int> INT
%token <string> IDENT
%token <string> STRING
%token <string> NOTE
%token INSTRUMENT CHORD PHRASE SHEET MAIN
%token EQUAL
%token LPAR RPAR LBRA RBRA COMA
%token SEMI // fin d'instruction
%token SHARP // Début de description
%token TITLE COMPOSER ARRANGER BPM //Descriptions 
%token REPEAT // dans une sheet ou phrase
%token PLAY PRINT // actions


%start main
%type <Pkast.expr> main

%%

main: expr SEMI {$1}
    | SEMI main {$2}
;

/* Grammaire */


expr:
   repeat {$1}
|  createvars {$1}
|  action {$1}
|  description {$1}
|  atom {$1}
;

repeat:
  | expr REPEAT INT {ERepeat($1, $3)}
;

createvars:
  INSTRUMENT IDENT EQUAL STRING
      {ELet ($2, EInstrument($4))}
| CHORD IDENT LPAR chordnotes RPAR
      {ELet($2, EChord($4))}
| PHRASE IDENT LBRA seqsound RBRA
      {ELet($2, EPhrase($4))}
| SHEET IDENT LPAR expr RPAR LBRA seqsound RBRA
      {ELet($2, ESheet($4, EPhrase($7)))}
;

chordnotes:
  NOTE chordnotes  { ENote($1) :: $2 }
| /* rien */      { [] }
;

seqsound:
  expr seqsound  { $1 :: $2 }
| LPAR chordnotes RPAR seqsound  { EChord($2) :: $4 }
| /* rien */      { [] }
;


action:
  PRINT STRING { EPrint ($2) }
| PLAY LPAR IDENT seqsheet RPAR { EPlay(EIdent($3)::$4) }
;

seqsheet:
  COMA IDENT seqsheet  { EIdent($2) :: $3 }
| /* rien */      { [] }
;

description:
  SHARP TITLE STRING
      { ETitle($3) }
| SHARP COMPOSER STRING
      { EComposer($3) }
| SHARP ARRANGER STRING
      { EArranger($3) }
| SHARP BPM INT
      { E_BPM($3) }
;

atom:
| IDENT          { EIdent ($1) }  
| NOTE          { ENote ($1) }  
;

