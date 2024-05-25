(* Ce fichier contient la d�finition du type OCaml des arbres de
 * syntaxe abstraite du langage, ainsi qu'un imprimeur des phrases
 * du langage.
*)


(* type MusNote = int * string * string * int;;
type MusChord = MusNote list;; (* Simultaneously played *)

type Sound = MusNote | MusChord;;

type MusPhrase = Sound list;; (* Sequentially played *)
type MusSheet = instrument * MusPhrase;; *)

(* Expressions : *)
type expr =
  | ETitle of string                              
  | EComposer of string                                
  | EArranger of string                                
  | E_BPM of int    
  | EInstrument of string
  | ENote of string
  | EChord of expr list
  | EPhrase of expr list
  | ESheet of (expr * expr)
  | EIdent of string
  | ELet of (string * expr)                        
  | ERepeat of  (expr * int)
  | EPrint of string
  | EPlay of expr list
;;  
  

(* Pour debug *)
let rec print_expr oc = function
  | ETitle title -> Printf.fprintf oc "Title: %s\n" title
  | EComposer composer -> Printf.fprintf oc "Composer: %s\n" composer
  | EArranger arranger -> Printf.fprintf oc "Arranger: %s\n" arranger
  | E_BPM bpm -> Printf.fprintf oc "BPM: %d\n" bpm
  | EInstrument instrument -> Printf.fprintf oc "Instrument: %s\n" instrument
  | ENote note -> Printf.fprintf oc "Note: %s\n" note
  | EChord expr_list -> 
      Printf.fprintf oc "Chord: [\n";
      List.iter (print_expr oc) expr_list;
      Printf.fprintf oc "]\n"
  | EPhrase expr_list -> 
      Printf.fprintf oc "Phrase: [\n";
      List.iter (print_expr oc) expr_list;
      Printf.fprintf oc "]\n"
  | ESheet (expr1, expr2) ->
      Printf.fprintf oc "Sheet: (\n";
      print_expr oc expr1;
      Printf.fprintf oc ",\n";
      print_expr oc expr2;
      Printf.fprintf oc ")\n"
  | EIdent ident -> Printf.fprintf oc "Ident: %s\n" ident
  | ELet (name, expr) -> 
      Printf.fprintf oc "Let: %s = (\n" name;
      print_expr oc expr;
      Printf.fprintf oc ")\n"
  | ERepeat (expr, count) ->
      Printf.fprintf oc "Repeat: (\n";
      print_expr oc expr;
      Printf.fprintf oc ", %d)\n" count
  | EPrint str -> Printf.fprintf oc "Print: %s\n" str
  | EPlay expr_list -> 
      Printf.fprintf oc "Play: [\n";
      List.iter (print_expr oc) expr_list;
      Printf.fprintf oc "]\n"
  ;;
