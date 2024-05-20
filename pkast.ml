(* Ce fichier contient la d�finition du type OCaml des arbres de
 * syntaxe abstraite du langage, ainsi qu'un imprimeur des phrases
 * du langage.
*)



(* Expressions : *)
type expr =
  | ETitle of string                               (* 1, 2, 3 *)
  | EComposer of string                                 (* 1, 2, 3 *)
  | EArranger of string                                 (* 1, 2, 3 *)
  | E_BPM of int                                 (* 1, 2, 3 *)
  
  | ESheet of ()
  | ENote of (int * string * string * int)                                 (* 1, 2, 3 *)
  | EChord of (string * expr * expr)                                 (* 1, 2, 3 *)
  | EChord of (string * expr * expr)                                 (* 1, 2, 3 *)
  
  | EPrint of expr
  | EPlay of (expr * expr)     
  
  
  (* 1, 2, 3 *)
  | EBool of bool                               (* true, false *)
  | EString of string                           (* "hello" *)
  | EIdent of string                            (* x, toto, fact *)
  | EApp of (expr * expr)                       (* application e1 e2 *)
  | EMonop of (string * expr)                   (* -e *)
  | EBinop of (string * expr * expr)            (* e1 + e2 *)
  | EIf of (expr * expr * expr)                 (* if e1 then e2 else e3 *)
  | EFun of (string * expr)                     (* fun v -> e *)
  | ELet of (string * expr * expr)              (* let x = e1 in e2 *)
  | ELetrec of (string * string * expr * expr)  (* let rec f x = e1 in e2 *)
;;


type expr =
  | EInt of int                                 (* 1, 2, 3 *)
  | EBool of bool                               (* true, false *)
  | EString of string                           (* "hello" *)
  | EIdent of string                            (* x, toto, fact *)
  | EApp of (expr * expr)                       (* application e1 e2 *)
  | EMonop of (string * expr)                   (* -e *)
  | EBinop of (string * expr * expr)            (* e1 + e2 *)
  | EIf of (expr * expr * expr)                 (* if e1 then e2 else e3 *)
  | EFun of (string * expr)                     (* fun v -> e *)
  | ELet of (string * expr * expr)              (* let x = e1 in e2 *)
  | ELetrec of (string * string * expr * expr)  (* let rec f x = e1 in e2 *)
;;


(* Extrait les parametres d'une fonction anonyme
          (fun x1 -> fun x2 -> ... -> e)
   et produit
          ([x1; x2; ...], e)
 *)
let params_body e =
  let rec un_body params expr = match expr with
  | EFun( p, e) -> un_body (p::params) e
  | e -> (List.rev params, e) in
  un_body [] e
;;


(* Note : dans le printf d'OCaml, le format %a
   correspond a 2 arguments consecutifs :
        - une fonction d'impression de type (out_channel -> 'a -> unit)
        - un argument a imprimer, de type 'a
   Voir le cas EApp ci-dessous.
 *)
let rec print oc = function
  | EInt n -> Printf.fprintf oc "%d" n
  | EBool b -> Printf.fprintf oc "%s" (if b then "true" else "false")
  | EIdent s -> Printf.fprintf oc "%s" s
  | EString s -> Printf.fprintf oc "\"%s\"" s
  | EApp (e1, e2) -> Printf.fprintf oc "(%a %a)" print e1 print e2
  | ELet (f, e1, e2) ->
      let (params, e) = params_body e1 in
      Printf.fprintf oc "(let %s %a= %a in %a)"
        f
        (fun oc -> List.iter (fun s -> Printf.fprintf oc "%s " s)) params
        print e
        print e2
  | ELetrec (f, x, e1, e2) ->
      let (params, e) = params_body e1 in
      Printf.fprintf oc "(let rec %s %s %a= %a in %a)"
        f x
        (fun oc -> List.iter (fun s -> Printf.fprintf oc "%s " s)) params
        print e
        print e2
  | EFun (x, e) -> Printf.fprintf oc "(fun %s -> %a)"  x print e
  | EIf (test, e1, e2) ->
      Printf.fprintf oc "(if %a then %a else %a)" print test print e1 print e2
  | EBinop (op,e1,e2) ->
      Printf.fprintf oc "(%a %s %a)" print e1 op print e2
  | EMonop (op,e) -> Printf.fprintf oc "%s%a" op print e
;;
