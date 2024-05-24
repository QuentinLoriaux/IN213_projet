

let path_instrument = "toto"
let instrument = if Sys.file_exists path_instrument then path_instrument else "../soundfonts/Yamaha_C3_Grand_Piano.sf2";;


(* Initialisation de FluidSynth*)
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
";;



Py.Run.eval ~start:Py.File "

# ======= Params =======

instrument = '../soundfonts/Yamaha_C3_Grand_Piano.sf2'
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
    time.sleep(timers[k])
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