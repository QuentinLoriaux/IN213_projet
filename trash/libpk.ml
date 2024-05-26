(*

Cimetière des fonctions pas utilisées :

(* let start_server =
  let command = "fluidsynth -niq   -C0 -R0 -r22050 -l -o midi.alsa_seq.id=fs ./soundfonts/Pianoteq_8_Classical_Guitar.sf2 -s " in
  let _ = Unix.system command in ();;

let play_piano note =
  let command = Printf.sprintf "echo \"noteon 1 %i 127\" | telnet localhost 9800" note in
  let _ = Unix.system command in ();; *)
(* echo "noteon 1 62 100" > /dev/tcp/localhost/9800 *)

(* let play_sound instrument note = 
  let _ =  if Unix.fork () = 0 then Unix.execvp "python3" [| "python3" ; "fluidsynthPlay.py" ; instrument ; string_of_int note |] in ();;  *)

*)

let silence l =
  let _ =
    if Unix.fork () = 0 then Unix.execvp "sleep" [| "sleep" ; string_of_float l |]
    else Unix.wait () in
  ()
;;

let play_sound instrument note = 
  let command = Printf.sprintf "python3 fluidsynthPlay.py %s %i &" instrument note in
  let _ = Unix.system command in ();;

  (* let string_list = ["hello"; "world"; "from"; "OCaml"];;

let result = String.concat " " string_list;;

print_endline result;; *)

    
let piano = "./soundfonts/Yamaha_C3_Grand_Piano.sf2";;

play_sound piano 60;;
play_sound piano 62;;
play_sound piano 64;;
play_sound piano 66;;
play_sound piano 68;;
play_sound piano 70;;



(* let note_do = 60 ;;
let note_re = 62 ;;
let note_mi = 64 ;;
let note_fa = 66 ;;

start_server;;

play_piano note_do;;
play_piano note_mi;;
silence 0.5 (* s*) ;;
play_piano note_re;;
play_piano note_fa;;
silence 0.5 (* s*) ;;
play_piano note_do;;
silence 0.5 (* s*) ;;
play_piano note_re;;
silence 0.5 (* s*) ;;
play_piano note_mi;;
silence 0.5 (* s*) ;;
play_piano note_fa;; *)


