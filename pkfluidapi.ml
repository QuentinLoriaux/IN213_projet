
(* =================== Fonctions auxiliaires =================== *)

let error msg = raise (Failure msg) ;;

type environnement = (string -> Pkast.expr) list ;;
(* type pkval = 
      Instrumentval of string 
    | Noteval of string
    | Chordval of string list
    | Unitval
;; *)

let note_to_string = function Pkast.ENote s -> s | _ -> error (Printf.sprintf "Wrong conversion from note") ;;


let extend rho x v = rho := (x, v) :: !rho ;;
let lookup var_name rho =
  try List.assoc var_name !rho
  with Not_found -> error (Printf.sprintf "Undefined ident '%s'" var_name)
;;

(* =================== Initialisation de FluidSynth =================== *)

Py.initialize ();;

Py.Run.eval ~start:Py.File "
import time
import fluidsynth
import numpy as np

# ========= Tools ==========

convert = {'c': 0, 'd': 2, 'e': 4, 'f': 5, 'g' : 7, 'a' : 9, 'b' : 11}
durations = [1/4, 1/2, 1.0, 2.0, 4.0]

def decrypt(note, bpm):
    height = 12 + int(note[1])*12 + convert[note[2]] 
    if note[3] == '+':
        height+=1
    elif note[3]=='-':
        height-=1
    
    if note[3] != '+' and note[3] != '-':
        duration = durations[int(note[3])] * 60.0 / bpm 
    else:
        duration = durations[int(note[4])] * 60.0 / bpm 
    
    return height, duration

def scheduler(notes):
    order = np.argsort([note[1] for note in notes])
    timers = [notes[order[0]][1]]
    for k in range(len(notes)-1):
        timers.append(notes[order[k+1]][1] - notes[order[k]][1])
    return timers, order

def addNote(a):
    print('added Note')
def addSheet(a):
    print('added sheet')
def addChord(a):
    print('added chord')
";;

(* =================== API ocaml/python =================== *)

let m = Py.Import.add_module "ocaml";;

let send_bpm nb = Py.Module.set m "bpm" (Py.Int.of_int nb);
let _ = Py.Run.eval ~start:Py.File "
from ocaml import bpm
print(bpm)" in ()
;;

let create_sheet s = Py.Module.set m "instrument" (Py.String.of_string s);
    Py.Run.eval ~start:Py.File "
from ocaml import instrument
addSheet( instrument )"
;;

let send_chord notes = Py.Module.set m "aChord"
(Py.List.of_list_map Py.String.of_string notes);
let _ = Py.Run.eval ~start:Py.File "
from ocaml import aChord
addChord( aChord )" in ()
;;

let send_note n = Py.Module.set m "aNote" (Py.String.of_string n);
let _ = Py.Run.eval ~start:Py.File "
from ocaml import aNote
addNote( aNote )" in ()
;;

let play_music = let _ = Py.Run.eval ~start:Py.File "
runScheduler()" in ()
;;


(* =================== Traitement de l'arbre de syntaxe =================== *)

let rec interpret env e = 
    match e with 
     | Pkast.EIdent s -> interpret env (lookup s env)
     | Pkast.EPlay sheets -> let _ = List.iter (interpret env) sheets in play_music
     | Pkast.ESheet (Pkast.EIdent ins, phrase) -> 
                let _ =  match (lookup ins env) with 
                    | Pkast.EInstrument s -> create_sheet s
                    | _ -> error (Printf.sprintf "Wrong type for the instrument") in 
                interpret env phrase
    | Pkast.EPhrase ph -> List.iter (interpret env) ph
    | Pkast.EChord ch -> let notes = List.map note_to_string ch in send_chord notes
    | Pkast.ENote n -> send_note n
                                
     | Pkast.ERepeat (expr, nb) ->
         for i = 1 to nb  do interpret env expr done
     | _ -> error (Printf.sprintf "semantic treatment went wrong")
;;


let rec treat_expr e env = 
  match e with
  (* Affichage *)
  | Pkast.ETitle s -> Printf.fprintf stdout "Title : %s\n" s
  | Pkast.EComposer s -> Printf.fprintf stdout "Composer : %s\n" s
  | Pkast.EArranger s -> Printf.fprintf stdout "Arranger : %s\n" s
  | Pkast.E_BPM nb -> let _ = send_bpm nb in Printf.fprintf stdout "BPM : %d\n" nb
  | Pkast.EPrint s -> Printf.fprintf stdout "%s\n" s
  
  (* Création des identificateurs *)
  | Pkast.ELet (s, expr) -> extend env s expr (* ; Printf.fprintf stdout "%d\n" (List.length !env) *)

  (* Interprétation du morceau *)
  | _ -> interpret env e
;;








  (* Rien du tout *)

let path_instrument = "toto";;
let instrument = if Sys.file_exists path_instrument then path_instrument else "../soundfonts/Yamaha_C3_Grand_Piano.sf2";;






Py.Run.eval ~start:Py.File "

# ======= Params =======

instrument = './soundfonts/Yamaha_C3_Grand_Piano.sf2'
bpm = 60
test = ['o4c0', 'o5c2', 'o5c4']

# ======= Démarrage de fluidsynth =======

fs = fluidsynth.Synth()
fs.start( driver='alsa', midi_driver='alsa_seq')  
fs.setting('synth.gain', 7.0)

sfid = fs.sfload(instrument)
fs.program_select(0, sfid, 0, 0)

# ======= Traitement des notes =======

notes = [decrypt(k, bpm) for k in test]
timers, order = scheduler(notes)
print(timers)

for note in notes:
    fs.noteon(0, note[0], 70)

for k in range(len(notes)):
    # time.sleep(timers[k])
    fs.noteoff(0, notes[order[k]][0])
"
;;





(* let () = Py.initialize () in
let np = Py.import "numpy" in
let plt = Py.import "matplotlib.pyplot" in
let x = Py.Module.get_function np "arange"
  (Array.map Py.Float.of_float [| 0.; 5.; 0.1 |]) in
let y = Py.Module.get_function np "sin" [| x |] in
ignore (Py.Module.get_function plt "plot" [| x; y |]);
assert (Py.Module.get_function plt "show" [| |] = Py.none) *)