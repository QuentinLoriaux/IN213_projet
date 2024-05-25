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

open Parsing;;
let _ = parse_error;;
# 2 "pkparse.mly"
open Pkast ;;

# 33 "pkparse.ml"
let yytransl_const = [|
  261 (* INSTRUMENT *);
  262 (* CHORD *);
  263 (* PHRASE *);
  264 (* SHEET *);
  265 (* MAIN *);
  266 (* EQUAL *);
  267 (* LPAR *);
  268 (* RPAR *);
  269 (* LBRA *);
  270 (* RBRA *);
  271 (* COMA *);
  272 (* SEMI *);
  273 (* SHARP *);
  274 (* TITLE *);
  275 (* COMPOSER *);
  276 (* ARRANGER *);
  277 (* BPM *);
  278 (* REPEAT *);
  279 (* PLAY *);
  280 (* PRINT *);
    0|]

let yytransl_block = [|
  257 (* INT *);
  258 (* IDENT *);
  259 (* STRING *);
  260 (* NOTE *);
    0|]

let yylhs = "\255\255\
\001\000\001\000\002\000\002\000\002\000\002\000\002\000\003\000\
\004\000\004\000\004\000\004\000\008\000\008\000\009\000\009\000\
\009\000\005\000\005\000\010\000\010\000\006\000\006\000\006\000\
\006\000\007\000\007\000\000\000"

let yylen = "\002\000\
\002\000\002\000\001\000\001\000\001\000\001\000\001\000\003\000\
\004\000\005\000\005\000\008\000\002\000\000\000\002\000\004\000\
\000\000\002\000\005\000\003\000\000\000\003\000\003\000\003\000\
\003\000\001\000\001\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\026\000\027\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\028\000\000\000\003\000\004\000\
\005\000\006\000\007\000\000\000\000\000\000\000\000\000\002\000\
\000\000\000\000\000\000\000\000\000\000\018\000\001\000\000\000\
\000\000\000\000\000\000\000\000\022\000\023\000\024\000\025\000\
\000\000\008\000\009\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\013\000\010\000\000\000\015\000\011\000\
\000\000\000\000\019\000\000\000\000\000\020\000\016\000\000\000\
\012\000"

let yydgoto = "\002\000\
\013\000\047\000\015\000\016\000\017\000\018\000\019\000\045\000\
\048\000\051\000"

let yysindex = "\013\000\
\022\255\000\000\000\000\000\000\015\255\017\255\018\255\031\255\
\022\255\023\255\014\255\033\255\000\000\249\254\000\000\000\000\
\000\000\000\000\000\000\024\255\026\255\027\255\037\255\000\000\
\051\255\060\255\061\255\064\255\065\255\000\000\000\000\070\255\
\063\255\068\255\045\255\053\255\000\000\000\000\000\000\000\000\
\058\255\000\000\000\000\068\255\062\255\068\255\255\254\066\255\
\246\254\073\255\067\255\000\000\000\000\069\255\000\000\000\000\
\071\255\058\255\000\000\045\255\045\255\000\000\000\000\072\255\
\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\075\255\074\255\000\000\000\000\000\000\000\000\000\000\
\077\255\000\000\000\000\075\255\000\000\075\255\074\255\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\077\255\000\000\074\255\074\255\000\000\000\000\000\000\
\000\000"

let yygindex = "\000\000\
\069\000\255\255\000\000\000\000\000\000\000\000\000\000\223\255\
\227\255\024\000"

let yytablesize = 89
let yytable = "\014\000\
\003\000\057\000\004\000\005\000\006\000\007\000\008\000\014\000\
\031\000\046\000\052\000\032\000\054\000\001\000\032\000\010\000\
\020\000\055\000\021\000\022\000\032\000\011\000\012\000\003\000\
\029\000\004\000\005\000\006\000\007\000\008\000\063\000\064\000\
\023\000\033\000\049\000\030\000\034\000\009\000\010\000\035\000\
\025\000\026\000\027\000\028\000\011\000\012\000\003\000\036\000\
\004\000\005\000\006\000\007\000\008\000\037\000\003\000\046\000\
\004\000\005\000\006\000\007\000\008\000\010\000\038\000\039\000\
\040\000\043\000\041\000\011\000\012\000\010\000\042\000\044\000\
\050\000\053\000\058\000\011\000\012\000\024\000\059\000\056\000\
\060\000\062\000\000\000\061\000\000\000\065\000\014\000\017\000\
\021\000"

let yycheck = "\001\000\
\002\001\012\001\004\001\005\001\006\001\007\001\008\001\009\000\
\016\001\011\001\044\000\022\001\046\000\001\000\022\001\017\001\
\002\001\047\000\002\001\002\001\022\001\023\001\024\001\002\001\
\011\001\004\001\005\001\006\001\007\001\008\001\060\000\061\000\
\002\001\010\001\036\000\003\001\011\001\016\001\017\001\013\001\
\018\001\019\001\020\001\021\001\023\001\024\001\002\001\011\001\
\004\001\005\001\006\001\007\001\008\001\003\001\002\001\011\001\
\004\001\005\001\006\001\007\001\008\001\017\001\003\001\003\001\
\001\001\003\001\002\001\023\001\024\001\017\001\001\001\004\001\
\015\001\012\001\002\001\023\001\024\001\009\000\012\001\014\001\
\012\001\058\000\255\255\013\001\255\255\014\001\012\001\014\001\
\012\001"

let yynames_const = "\
  INSTRUMENT\000\
  CHORD\000\
  PHRASE\000\
  SHEET\000\
  MAIN\000\
  EQUAL\000\
  LPAR\000\
  RPAR\000\
  LBRA\000\
  RBRA\000\
  COMA\000\
  SEMI\000\
  SHARP\000\
  TITLE\000\
  COMPOSER\000\
  ARRANGER\000\
  BPM\000\
  REPEAT\000\
  PLAY\000\
  PRINT\000\
  "

let yynames_block = "\
  INT\000\
  IDENT\000\
  STRING\000\
  NOTE\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 26 "pkparse.mly"
                (_1)
# 183 "pkparse.ml"
               : Pkast.expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : Pkast.expr) in
    Obj.repr(
# 27 "pkparse.mly"
                (_2)
# 190 "pkparse.ml"
               : Pkast.expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'repeat) in
    Obj.repr(
# 34 "pkparse.mly"
          (_1)
# 197 "pkparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'createvars) in
    Obj.repr(
# 35 "pkparse.mly"
              (_1)
# 204 "pkparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'action) in
    Obj.repr(
# 36 "pkparse.mly"
          (_1)
# 211 "pkparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'description) in
    Obj.repr(
# 37 "pkparse.mly"
               (_1)
# 218 "pkparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'atom) in
    Obj.repr(
# 38 "pkparse.mly"
        (_1)
# 225 "pkparse.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 42 "pkparse.mly"
                    (ERepeat(_1, _3))
# 233 "pkparse.ml"
               : 'repeat))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 47 "pkparse.mly"
      (ELet (_2, EInstrument(_4)))
# 241 "pkparse.ml"
               : 'createvars))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'chordnotes) in
    Obj.repr(
# 49 "pkparse.mly"
      (ELet(_2, EChord(_4)))
# 249 "pkparse.ml"
               : 'createvars))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'seqsound) in
    Obj.repr(
# 51 "pkparse.mly"
      (ELet(_2, EPhrase(_4)))
# 257 "pkparse.ml"
               : 'createvars))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 6 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _7 = (Parsing.peek_val __caml_parser_env 1 : 'seqsound) in
    Obj.repr(
# 53 "pkparse.mly"
      (ELet(_2, ESheet(_4, EPhrase(_7))))
# 266 "pkparse.ml"
               : 'createvars))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'chordnotes) in
    Obj.repr(
# 57 "pkparse.mly"
                   ( ENote(_1) :: _2 )
# 274 "pkparse.ml"
               : 'chordnotes))
; (fun __caml_parser_env ->
    Obj.repr(
# 58 "pkparse.mly"
                  ( [] )
# 280 "pkparse.ml"
               : 'chordnotes))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'seqsound) in
    Obj.repr(
# 62 "pkparse.mly"
                 ( _1 :: _2 )
# 288 "pkparse.ml"
               : 'seqsound))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'chordnotes) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'seqsound) in
    Obj.repr(
# 63 "pkparse.mly"
                                 ( EChord(_2) :: _4 )
# 296 "pkparse.ml"
               : 'seqsound))
; (fun __caml_parser_env ->
    Obj.repr(
# 64 "pkparse.mly"
                  ( [] )
# 302 "pkparse.ml"
               : 'seqsound))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 69 "pkparse.mly"
               ( EPrint (_2) )
# 309 "pkparse.ml"
               : 'action))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'seqsheet) in
    Obj.repr(
# 70 "pkparse.mly"
                                ( EPlay(EIdent(_3)::_4) )
# 317 "pkparse.ml"
               : 'action))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'seqsheet) in
    Obj.repr(
# 74 "pkparse.mly"
                       ( EIdent(_2) :: _3 )
# 325 "pkparse.ml"
               : 'seqsheet))
; (fun __caml_parser_env ->
    Obj.repr(
# 75 "pkparse.mly"
                  ( [] )
# 331 "pkparse.ml"
               : 'seqsheet))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 80 "pkparse.mly"
      ( ETitle(_3) )
# 338 "pkparse.ml"
               : 'description))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 82 "pkparse.mly"
      ( EComposer(_3) )
# 345 "pkparse.ml"
               : 'description))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 84 "pkparse.mly"
      ( EArranger(_3) )
# 352 "pkparse.ml"
               : 'description))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 86 "pkparse.mly"
      ( E_BPM(_3) )
# 359 "pkparse.ml"
               : 'description))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 90 "pkparse.mly"
                 ( EIdent (_1) )
# 366 "pkparse.ml"
               : 'atom))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 91 "pkparse.mly"
                ( ENote (_1) )
# 373 "pkparse.ml"
               : 'atom))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Pkast.expr)
