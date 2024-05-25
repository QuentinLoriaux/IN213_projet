open pkast ;;

type pcfval =
  | Intval of int
  | Boolval of bool
  | Stringval of string
  | Funval of (pcfval -> pcfval)
;;

let rec printval = function
  | Intval n -> Printf.printf "%d" n
  | Boolval b -> Printf.printf "%s" (if b then "T" else "F")
  | Stringval s -> Printf.printf "\"%s\"" s
  | Funval f -> Printf.printf "<fun>"
;;

type env = string -> pcfval ;;

let init_env id =
  raise (Failure (Printf.sprintf "Unbound ident: %s" id))
;;

let extend env x v = fun y -> if x = y then v else env y ;;

let rec semant e rho =
  match e with
  | Int n -> Intval n
  | Bool b -> Boolval b
  | String s -> Stringval s
  | Ident v -> rho (v)
  | App (e1, e2) -> (
      match semant e1 rho with
      | Funval f -> f (semant e2 rho)
      | _ -> raise (Failure "Not a function")
     )
  | Monop ("-", e) -> (
      match semant e rho with
      | Intval n -> Intval (-n)
      | _ -> raise (Failure "Uminus of a non integer")
     )
  | Monop (op, _) ->
      raise (Failure (Printf.sprintf "Unknown unary op: %s" op))
  | Binop (op, e1, e2) -> (
      match (semant e1 rho, semant e2 rho) with
      | (Intval n1, Intval n2) -> (
          match op with
          | "+" -> Intval (n1 + n2)
          | "-" -> Intval (n1 - n2)
          | "*" -> Intval (n1 * n2)
          | "/" -> Intval (n1 / n2)
          | "=" -> Boolval (n1 = n2)
          | ">" -> Boolval (n1 > n2)
          | "<" -> Boolval (n1 < n2)
          | ">=" -> Boolval (n1 >= n2)
          | "<=" -> Boolval (n1 <= n2)
          | _ ->
              raise
                (Failure (Printf.sprintf "Invalid integer operator: %s" op))
         )
      | (Boolval b1, Boolval b2) -> (
          match op with
          | "=" -> Boolval(b1 = b2)
          | _ ->
              raise (Failure (Printf.sprintf "Invalid boolean operator: %s" op))
         )
      | (Stringval s1, Stringval s2) -> (
          match op with
          | "=" -> Boolval (s1 = s2)
          | _ ->
              raise (Failure (Printf.sprintf "Invalid boolean operator: %s" op))
         )
      | _ ->
          raise
            (Failure (Printf.sprintf "Invalid operands for operator: %s" op))
     )
  | If (e, e1, e2) -> (
      match semant e rho with
      | Boolval b -> semant (if b then e1 else e2) rho
      | _ -> raise (Failure "Testing a non boolean condition")
     )
  | Fun (a, e) -> Funval (fun va -> semant e (extend rho a va))
  | Let (x, e1, e2) -> semant e2 (extend rho x (semant e1 rho))
  | Letrec (f, e1, e2) ->
      (* Note : no need to put parentheses, but this makes clearer that
         extend returns a function, which can be applied to an identifier
         to obtain its value in the environment rho'.
         Need to explicitely use y to make the let rec be a function definition,
         hence it can be accepted as reursive. *)
      let rec rho' y = (extend rho f (semant e1 rho')) y in
      semant e2 rho'
;;

let eval e = semant e init_env ;;
