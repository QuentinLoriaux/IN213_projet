let start_server =
  let command = "fluidsynth -niq   -C0 -R0 -r22050 -l -o midi.alsa_seq.id=fs ./soundfonts/Pianoteq_8_Classical_Guitar.sf2 -s " in
  let _ = Unix.system command in ();;



let play_piano note =
  let command = Printf.sprintf "echo \"noteon 1 %i 127\" | telnet localhost 9800" note in
  let _ = Unix.system command in ();;
(* echo "noteon 1 62 100" > /dev/tcp/localhost/9800 *)

let silence l =
  let _ =
    if Unix.fork () = 0 then Unix.execvp "sleep" [| "sleep" ; string_of_float l |]
    else Unix.wait () in
  ()
;;

let note_do = 60 ;;
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
play_piano note_fa;;

(* let silence l =
  let _ =
    if Unix.fork () = 0 then Unix.execvp "sleep" [| "sleep" ; string_of_float l |]
    else Unix.wait () in
  ()
;; *)

