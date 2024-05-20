let sox_beep f l =
  let l_ms = l /. 1000.0 in
  let command = Printf.sprintf "play -n synth %f sin %f" l_ms f in
  let _ = Unix.system command in
  ()
;;

let silence l =
  let _ =
    if Unix.fork () = 0 then Unix.execvp "sleep" [| "sleep" ; string_of_float l |]
    else Unix.wait () in
  ()
;;

let note_do = 262.0 ;;
let note_re = 294.0 ;;
let note_mi = 330.0 ;;
let note_la = 440.0 ;;

sox_beep note_do (* Hz *) 2000.0 (* ms *) ;;
silence 0.5 (* s*) ;;
sox_beep note_re (* Hz *) 1000.0 (* ms *) ;;
silence 0.5  (* s*) ;;
sox_beep note_mi (* Hz *) 1000.0 (* ms *) ;;
