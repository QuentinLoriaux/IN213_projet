%{
open Pkast ;;

let rec mkfun params expr =
  match params with
  | [] -> expr
  | p :: prms -> EFun(p, mkfun prms expr)
;;

let rec mkChord notes = match notes with
  | [] -> raise (Failure "empty chord")
  | [x] -> EChord(x, ENote(x))
  | t :: q -> EChord

let rec mkSheetList sheets 
%}


%token <int> INT
%token <string> IDENT
%token <string> STRING
%token <string> NOTE
%token INSTRUMENT CHORD PHRASE SHEET MAIN
%token EQUAL
%token LPAR RPAR LBRA RBRA COMA
%token SEMI // fin d'instruction
%token SHARP TITLE COMPOSER ARRANGER BPM //informations 
%token WRITE REPEAT // dans une sheet 
%token PLAY PRINT // dans le main


%start main
%type <Pkast.expr> main

%%

main: 
      MAIN LBRA action {$3}
    | action SEMI { $1 }
    | SEMI main { $2 }
    // | action SEMI RBRA { $2 }
;

/* Grammaire */

expr:
  CHORD IDENT LPAR SEQNOTE RPAR
      {EChord($2, $4)}
| PHRASE IDENT LBRA  RBRA
      {EPhrase($2,mkphrase)}

seqnote:
  NOTE seqnote  { $1 :: $2 }
| /* rien */      { [] }
;

// note_expr:

action:
  PRINT STRING { EPrint ($2) }
| PLAY LPAR seqsheet RPAR { EPlay ($3) }
;

seqsheet:
  SHEET COMA seqsheet  { $1 :: $3 }
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



// ============== PROF


expr:
  LET REC IDENT IDENT seqident EQUAL expr IN expr
         { ELetrec ($3, $4, (mkfun $5 $7), $9) }
| LET IDENT seqident EQUAL expr IN expr
         { ELet ($2, (mkfun $3 $5) , $7) }
| FUN IDENT ARROW expr
         { EFun ($2, $4) }
| IF expr THEN expr ELSE expr
         { EIf ($2, $4, $6) }
| arith_expr
         { $1 }
;

seqident:
  IDENT seqident  { $1 :: $2 }
| /* rien */      { [] }
;

arith_expr:
  arith_expr EQUAL arith_expr        { EBinop ("=", $1, $3) }
| arith_expr GREATER arith_expr      { EBinop (">", $1, $3) }
| arith_expr GREATEREQUAL arith_expr { EBinop (">=", $1, $3) }
| arith_expr SMALLER arith_expr      { EBinop ("<", $1, $3) }
| arith_expr SMALLEREQUAL arith_expr { EBinop ("<=", $1, $3) }
| arith_expr PLUS arith_expr         { EBinop ("+", $1, $3) }
| arith_expr MINUS arith_expr        { EBinop ("-", $1, $3) }
| arith_expr MULT arith_expr         { EBinop ("*", $1, $3) }
| arith_expr DIV arith_expr          { EBinop ("/", $1, $3) }
| application                        { $1 }
;

/* On considere ci-dessous que MINUS atom est dans la categorie
 * des applications. Cela permet de traiter n - 1
 * comme une soustraction binaire, et       f (- 1)
 * comme l'application de f a l'oppose de 1.
 */

application:
  application atom { EApp ($1, $2) }
| MINUS atom       { EMonop ("-", $2) }
| atom             { $1 }
;

atom:
  INT            { EInt ($1) }
| TRUE           { EBool (true) }
| FALSE          { EBool (false) }
| STRING         { EString ($1) }
| IDENT          { EIdent ($1) }
| LPAR expr RPAR { $2 }
;
