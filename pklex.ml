# 1 "pklex.mll"
 
 open Pkparse ;;
  exception Eoi ;;

(* To buffer string literals *)

let initial_string_buffer = Bytes.create 256;;
  let string_buff = ref initial_string_buffer;;
  let string_index = ref 0;;

let reset_string_buffer () =
  string_buff := initial_string_buffer;
  string_index := 0;;

let store_string_char c =
  if !string_index >= Bytes.length (!string_buff) then begin
    let new_buff = Bytes.create (Bytes.length (!string_buff) * 2) in
    Bytes.blit (!string_buff) 0 new_buff 0 (Bytes.length (!string_buff));
    string_buff := new_buff
  end;
  Bytes.unsafe_set (!string_buff) (!string_index) c;
  incr string_index;;

let get_stored_string () =
  let s = Bytes.to_string (Bytes.sub (!string_buff) 0 (!string_index)) in
  string_buff := initial_string_buffer;
  s;;

(* To translate escape sequences *)

let char_for_backslash c = match c with
| 'n' -> '\010'
| 'r' -> '\013'
| 'b' -> '\008'
| 't' -> '\009'
| c   -> c

let char_for_decimal_code lexbuf i =
  let c = 100 * (Char.code(Lexing.lexeme_char lexbuf i) - 48) +
      10 * (Char.code(Lexing.lexeme_char lexbuf (i+1)) - 48) +
                  (Char.code(Lexing.lexeme_char lexbuf (i+2)) - 48) in
  if (c < 0 || c > 255)
  then raise (Failure ("Illegal_escape: " ^ (Lexing.lexeme lexbuf)))
  else Char.chr c;;

let char_for_hexadecimal_code lexbuf i =
  let d1 = Char.code (Lexing.lexeme_char lexbuf i) in
  let val1 = if d1 >= 97 then d1 - 87
  else if d1 >= 65 then d1 - 55
  else d1 - 48
  in
  let d2 = Char.code (Lexing.lexeme_char lexbuf (i+1)) in
  let val2 = if d2 >= 97 then d2 - 87
  else if d2 >= 65 then d2 - 55
  else d2 - 48
  in
  Char.chr (val1 * 16 + val2);;

exception LexError of (Lexing.position * Lexing.position) ;;
let line_number = ref 0 ;;

let incr_line_number lexbuf =
  let pos = lexbuf.Lexing.lex_curr_p in
  lexbuf.Lexing.lex_curr_p <- { pos with
    Lexing.pos_lnum = pos.Lexing.pos_lnum + 1 ;
    Lexing.pos_bol = pos.Lexing.pos_cnum }


# 71 "pklex.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base =
   "\000\000\237\255\238\255\004\000\011\000\241\255\242\255\243\255\
    \244\255\245\255\246\255\247\255\248\255\249\255\250\255\061\000\
    \160\000\235\000\136\000\001\000\254\255\255\255\054\001\080\001\
    \147\001\252\255\157\001\167\001\240\255\006\000\239\255\215\001\
    \248\255\249\255\002\000\250\255\202\001\255\255\251\255\236\001\
    \212\001\254\255\222\001\253\255\019\002\252\255\145\000\253\255\
    \254\255\255\255\113\000\253\255\254\255\007\000\021\000\255\255\
    \184\000\254\255\004\000\255\255";
  Lexing.lex_backtrk =
   "\255\255\255\255\255\255\018\000\018\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\018\000\
    \003\000\018\000\002\000\001\000\255\255\255\255\004\000\255\255\
    \003\000\255\255\003\000\004\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\005\000\255\255\007\000\255\255\255\255\004\000\
    \004\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\001\000\255\255\255\255\
    \255\255\255\255\000\000\255\255";
  Lexing.lex_default =
   "\001\000\000\000\000\000\255\255\255\255\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\255\255\
    \255\255\255\255\255\255\255\255\000\000\000\000\255\255\255\255\
    \255\255\000\000\255\255\255\255\000\000\255\255\000\000\032\000\
    \000\000\000\000\255\255\000\000\038\000\000\000\000\000\255\255\
    \255\255\000\000\255\255\000\000\255\255\000\000\048\000\000\000\
    \000\000\000\000\052\000\000\000\000\000\255\255\255\255\000\000\
    \057\000\000\000\255\255\000\000";
  Lexing.lex_trans =
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\021\000\020\000\020\000\035\000\019\000\059\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \021\000\000\000\006\000\005\000\000\000\000\000\000\000\003\000\
    \012\000\011\000\014\000\029\000\008\000\030\000\054\000\004\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\028\000\007\000\055\000\013\000\000\000\000\000\
    \000\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\017\000\
    \015\000\015\000\016\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\010\000\021\000\009\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \053\000\000\000\000\000\049\000\000\000\000\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\059\000\000\000\000\000\058\000\000\000\000\000\
    \000\000\000\000\000\000\026\000\000\000\026\000\000\000\000\000\
    \025\000\025\000\025\000\025\000\025\000\025\000\025\000\025\000\
    \025\000\025\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\000\000\000\000\000\000\000\000\000\000\
    \002\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\023\000\023\000\023\000\023\000\023\000\
    \023\000\023\000\023\000\023\000\023\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \000\000\051\000\000\000\000\000\000\000\000\000\000\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\047\000\000\000\000\000\000\000\000\000\000\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\024\000\024\000\024\000\024\000\024\000\024\000\024\000\
    \255\255\000\000\000\000\000\000\000\000\000\000\026\000\000\000\
    \026\000\000\000\024\000\025\000\025\000\025\000\025\000\025\000\
    \025\000\025\000\025\000\025\000\025\000\025\000\025\000\025\000\
    \025\000\025\000\025\000\025\000\025\000\025\000\025\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\035\000\000\000\000\000\034\000\000\000\000\000\000\000\
    \000\000\000\000\041\000\000\000\041\000\000\000\000\000\000\000\
    \000\000\041\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\037\000\040\000\040\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\042\000\042\000\042\000\042\000\
    \042\000\042\000\042\000\042\000\042\000\042\000\043\000\043\000\
    \043\000\043\000\043\000\043\000\043\000\043\000\043\000\043\000\
    \000\000\000\000\000\000\000\000\044\000\044\000\044\000\044\000\
    \044\000\044\000\044\000\044\000\044\000\044\000\041\000\000\000\
    \000\000\000\000\000\000\000\000\041\000\044\000\044\000\044\000\
    \044\000\044\000\044\000\036\000\000\000\000\000\000\000\000\000\
    \041\000\000\000\000\000\000\000\041\000\000\000\041\000\000\000\
    \000\000\000\000\039\000\045\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\045\000\045\000\045\000\044\000\044\000\044\000\
    \044\000\044\000\044\000\000\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\255\255\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\033\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000";
  Lexing.lex_check =
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\019\000\034\000\000\000\058\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\255\255\000\000\000\000\255\255\255\255\255\255\000\000\
    \000\000\000\000\000\000\003\000\000\000\029\000\053\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\004\000\000\000\054\000\000\000\255\255\255\255\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \050\000\255\255\255\255\046\000\255\255\255\255\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \015\000\015\000\015\000\015\000\015\000\015\000\015\000\015\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\056\000\255\255\255\255\056\000\255\255\255\255\
    \255\255\255\255\255\255\016\000\255\255\016\000\255\255\255\255\
    \016\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\255\255\255\255\255\255\255\255\255\255\
    \000\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\016\000\016\000\016\000\016\000\016\000\
    \016\000\016\000\016\000\017\000\017\000\017\000\017\000\017\000\
    \017\000\017\000\017\000\017\000\017\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\017\000\017\000\017\000\017\000\
    \017\000\017\000\017\000\017\000\017\000\017\000\017\000\017\000\
    \017\000\017\000\017\000\017\000\017\000\017\000\017\000\017\000\
    \017\000\017\000\017\000\017\000\017\000\017\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\017\000\017\000\017\000\017\000\
    \017\000\017\000\017\000\017\000\017\000\017\000\017\000\017\000\
    \017\000\017\000\017\000\017\000\017\000\017\000\017\000\017\000\
    \017\000\017\000\017\000\017\000\017\000\017\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \255\255\050\000\255\255\255\255\255\255\255\255\255\255\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\046\000\255\255\255\255\255\255\255\255\255\255\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\022\000\022\000\022\000\022\000\022\000\022\000\022\000\
    \022\000\023\000\023\000\023\000\023\000\023\000\023\000\023\000\
    \056\000\255\255\255\255\255\255\255\255\255\255\024\000\255\255\
    \024\000\255\255\023\000\024\000\024\000\024\000\024\000\024\000\
    \024\000\024\000\024\000\024\000\024\000\026\000\026\000\026\000\
    \026\000\026\000\026\000\026\000\026\000\026\000\026\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\031\000\255\255\255\255\031\000\255\255\255\255\255\255\
    \255\255\255\255\036\000\255\255\036\000\255\255\255\255\255\255\
    \255\255\036\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\031\000\036\000\036\000\036\000\036\000\036\000\036\000\
    \036\000\036\000\036\000\036\000\040\000\040\000\040\000\040\000\
    \040\000\040\000\040\000\040\000\040\000\040\000\042\000\042\000\
    \042\000\042\000\042\000\042\000\042\000\042\000\042\000\042\000\
    \255\255\255\255\255\255\255\255\039\000\039\000\039\000\039\000\
    \039\000\039\000\039\000\039\000\039\000\039\000\036\000\255\255\
    \255\255\255\255\255\255\255\255\036\000\039\000\039\000\039\000\
    \039\000\039\000\039\000\031\000\255\255\255\255\255\255\255\255\
    \036\000\255\255\255\255\255\255\036\000\255\255\036\000\255\255\
    \255\255\255\255\036\000\044\000\044\000\044\000\044\000\044\000\
    \044\000\044\000\044\000\044\000\044\000\039\000\039\000\039\000\
    \039\000\039\000\039\000\255\255\044\000\044\000\044\000\044\000\
    \044\000\044\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\044\000\044\000\044\000\044\000\
    \044\000\044\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\036\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\031\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255";
  Lexing.lex_base_code =
   "";
  Lexing.lex_backtrk_code =
   "";
  Lexing.lex_default_code =
   "";
  Lexing.lex_trans_code =
   "";
  Lexing.lex_check_code =
   "";
  Lexing.lex_code =
   "";
}

let rec lex lexbuf =
   __ocaml_lex_lex_rec lexbuf 0
and __ocaml_lex_lex_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 77 "pklex.mll"
      ( lex lexbuf )
# 321 "pklex.ml"

  | 1 ->
# 79 "pklex.mll"
      ( incr_line_number lexbuf ;
        lex lexbuf )
# 327 "pklex.ml"

  | 2 ->
let
# 81 "pklex.mll"
                  lxm
# 333 "pklex.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 82 "pklex.mll"
      ( INT(int_of_string lxm) )
# 337 "pklex.ml"

  | 3 ->
let
# 83 "pklex.mll"
                                                              lxm
# 343 "pklex.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 84 "pklex.mll"
    (NOTE(lxm) )
# 347 "pklex.ml"

  | 4 ->
let
# 85 "pklex.mll"
                                                           lxm
# 353 "pklex.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 86 "pklex.mll"
      ( match lxm with
          "TITLE" -> TITLE
        | "COMPOSER" -> COMPOSER
        | "ARRANGER" -> ARRANGER
        | "BPM" -> BPM
        | "instrument" -> INSTRUMENT
        | "chord" -> CHORD
        | "phrase" -> PHRASE
        | "sheet" -> SHEET
        | "main" -> MAIN
        | "play" -> PLAY
        | "print" -> PRINT
        | _ -> IDENT(lxm) )
# 369 "pklex.ml"

  | 5 ->
# 99 "pklex.mll"
          ( REPEAT )
# 374 "pklex.ml"

  | 6 ->
# 100 "pklex.mll"
          ( EQUAL )
# 379 "pklex.ml"

  | 7 ->
# 101 "pklex.mll"
          ( LPAR )
# 384 "pklex.ml"

  | 8 ->
# 102 "pklex.mll"
          ( RPAR )
# 389 "pklex.ml"

  | 9 ->
# 103 "pklex.mll"
          ( LBRA )
# 394 "pklex.ml"

  | 10 ->
# 104 "pklex.mll"
          ( RBRA )
# 399 "pklex.ml"

  | 11 ->
# 105 "pklex.mll"
          ( COMA )
# 404 "pklex.ml"

  | 12 ->
# 106 "pklex.mll"
          ( SEMI )
# 409 "pklex.ml"

  | 13 ->
# 107 "pklex.mll"
          ( reset_string_buffer();
            in_string lexbuf;
            STRING (get_stored_string()) )
# 416 "pklex.ml"

  | 14 ->
# 110 "pklex.mll"
          ( SHARP )
# 421 "pklex.ml"

  | 15 ->
# 111 "pklex.mll"
          ( in_cpp_comment lexbuf )
# 426 "pklex.ml"

  | 16 ->
# 112 "pklex.mll"
              ( in_long_comment lexbuf )
# 431 "pklex.ml"

  | 17 ->
# 113 "pklex.mll"
          ( raise Eoi )
# 436 "pklex.ml"

  | 18 ->
# 114 "pklex.mll"
          ( raise (LexError (lexbuf.Lexing.lex_start_p,
                             lexbuf.Lexing.lex_curr_p)) )
# 442 "pklex.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_lex_rec lexbuf __ocaml_lex_state

and in_string lexbuf =
   __ocaml_lex_in_string_rec lexbuf 31
and __ocaml_lex_in_string_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 119 "pklex.mll"
      ( () )
# 454 "pklex.ml"

  | 1 ->
# 121 "pklex.mll"
      ( store_string_char(char_for_backslash(Lexing.lexeme_char lexbuf 1));
        in_string lexbuf )
# 460 "pklex.ml"

  | 2 ->
# 124 "pklex.mll"
      ( store_string_char(char_for_decimal_code lexbuf 1);
        in_string lexbuf )
# 466 "pklex.ml"

  | 3 ->
# 127 "pklex.mll"
      ( store_string_char(char_for_hexadecimal_code lexbuf 2);
         in_string lexbuf )
# 472 "pklex.ml"

  | 4 ->
let
# 129 "pklex.mll"
              chars
# 478 "pklex.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos (lexbuf.Lexing.lex_start_pos + 2) in
# 130 "pklex.mll"
      ( skip_to_eol lexbuf; raise (Failure("Illegal escape: " ^ chars)) )
# 482 "pklex.ml"

  | 5 ->
let
# 131 "pklex.mll"
               s
# 488 "pklex.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 132 "pklex.mll"
      ( for i = 0 to String.length s - 1 do
          store_string_char s.[i];
        done;
        in_string lexbuf
      )
# 496 "pklex.ml"

  | 6 ->
# 138 "pklex.mll"
      ( raise Eoi )
# 501 "pklex.ml"

  | 7 ->
let
# 139 "pklex.mll"
         c
# 507 "pklex.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 140 "pklex.mll"
      ( store_string_char c; in_string lexbuf )
# 511 "pklex.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_in_string_rec lexbuf __ocaml_lex_state

and in_cpp_comment lexbuf =
   __ocaml_lex_in_cpp_comment_rec lexbuf 46
and __ocaml_lex_in_cpp_comment_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 143 "pklex.mll"
         ( lex lexbuf )
# 523 "pklex.ml"

  | 1 ->
# 144 "pklex.mll"
         ( in_cpp_comment lexbuf )
# 528 "pklex.ml"

  | 2 ->
# 145 "pklex.mll"
         ( raise Eoi )
# 533 "pklex.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_in_cpp_comment_rec lexbuf __ocaml_lex_state

and in_long_comment lexbuf =
   __ocaml_lex_in_long_comment_rec lexbuf 50
and __ocaml_lex_in_long_comment_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 148 "pklex.mll"
             ( lex lexbuf )
# 545 "pklex.ml"

  | 1 ->
# 149 "pklex.mll"
         ( in_long_comment lexbuf )
# 550 "pklex.ml"

  | 2 ->
# 150 "pklex.mll"
         ( raise Eoi )
# 555 "pklex.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_in_long_comment_rec lexbuf __ocaml_lex_state

and skip_to_eol lexbuf =
   __ocaml_lex_skip_to_eol_rec lexbuf 56
and __ocaml_lex_skip_to_eol_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 153 "pklex.mll"
            ( () )
# 567 "pklex.ml"

  | 1 ->
# 154 "pklex.mll"
            ( skip_to_eol lexbuf )
# 572 "pklex.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_skip_to_eol_rec lexbuf __ocaml_lex_state

;;
