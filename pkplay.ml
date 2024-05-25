let version = "0.1" ;;


let usage () =
  let _ =
    Printf.eprintf
      "Usage: %s [file]\n\tRead a PressKey program from a file\n%!"
    Sys.argv.(0) in
  exit 1
;;



let main() =
  let _ = Printf.printf "        Welcome to PressKey, version %s\n%!" version in
  (* Chargement du fichier *)
  if (Array.length Sys.argv) != 2 then usage() else 
  let lexbuf = Lexing.from_channel 
    begin try open_in Sys.argv.(1) 
          with _ -> Printf.eprintf "Opening %s failed\n%!" Sys.argv.(1); exit 1
    end in

  (* Création de l'environnement *)
  let mainEnv = ref [] in

  while true do
    try
      let e = Pkparse.main Pklex.lex lexbuf in
      (* do stuff *)
      (* let _ = Printf.printf "Recognized: " in
      let _ = Pkast.print_expr stdout e in *)
      let _ = Pkfluidapi.treat_expr e mainEnv in ()

    (* Traitement des exceptions *)
    with 
      Pklex.Eoi -> Printf.printf  "End of the music.\n%!" ; exit 0
    | Failure msg -> Printf.printf "Erreur: %s\n\n" msg
    | Parsing.Parse_error ->
        let sp = Lexing.lexeme_start_p lexbuf in
        let ep = Lexing.lexeme_end_p lexbuf in
        Format.printf
          "File %S, line %i, characters %i-%i: Syntax error.\n"
          sp.Lexing.pos_fname
          sp.Lexing.pos_lnum
          (sp.Lexing.pos_cnum - sp.Lexing.pos_bol)
          (ep.Lexing.pos_cnum - sp.Lexing.pos_bol)
    | Pklex.LexError (sp, ep) ->
        Printf.printf
          "File %S, line %i, characters %i-%i: Lexical error.\n"
          sp.Lexing.pos_fname
          sp.Lexing.pos_lnum
          (sp.Lexing.pos_cnum - sp.Lexing.pos_bol)
          (ep.Lexing.pos_cnum - sp.Lexing.pos_bol)
  done
;;

if !Sys.interactive then () else main();;
