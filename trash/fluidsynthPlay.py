import time
import fluidsynth
import sys
import os
import numpy as np

# ========= Tools ==========

convert = {"c": 0, "d": 2, "e": 4, "f": 5, "g" : 7, "a" : 9, "b" : 11}
durations = [1/4, 1/2, 1.0, 2.0, 4.0] # de double croche à ronde

def decrypt(note, bpm):
    height = 12 # correspond à C0
    height += int(note[1])*12 # l'octave
    height += convert[note[2]] # la lettre
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


# ======= Traitement des arguments =======

lenArgs = len(sys.argv)
if lenArgs < 2 :
    print("Arguments :\n1. bpm \n2 : path to .sf2 file \n3,...,n : <note>   (format : o5a+2)")
    exit()
print(sys.argv[0])

# ======= Démarrage de fluidsynth =======

fs = fluidsynth.Synth()
fs.start( driver="alsa", midi_driver="alsa_seq")  
fs.setting('synth.gain', 7.0)

# ======= Choix de l'instrument =======

instrument = sys.argv[2]
sfid = fs.sfload('./soundfonts/Salsa_Brass.sf2')  
if (os.path.exists(instrument)):
    print("instrument : " , instrument)
    sfid = fs.sfload(instrument)
fs.program_select(0, sfid, 0, 0)

# ======= Traitement des notes =======

bpm = 60
bpm = float(sys.argv[1])
# test = ["o4c0", "o5c2", "o5c4"]


notes = [decrypt(k, bpm) for k in sys.argv[3:]]
timers, order = scheduler(notes)
# print(timers)

# ---- frappe simultanée des notes
for note in notes:
    fs.noteon(0, note[0], 70)

# ---- arrêts différés
for k in range(len(notes)):
    time.sleep(timers[k])
    fs.noteoff(0, notes[order[k]][0])






# fs.noteon(channel, note, taper fort = velocité)






# import numpy
# import pyaudio
# seq = fluidsynth.Sequencer()
# fs = fluidsynth.Synth()
# fs.start(device = 'hw:1')  # on Windows, use "driver = 'dsound'"

# sfid = fs.sfload('./soundfonts/Yamaha_C3_Grand_Piano.sf2')  # replace path as needed
# fs.program_select(0, sfid, 0, 0)


# synthID = seq.register_fluidsynth(fs)

# seq.note_on(time=500, absolute=False, channel=0, key=60, velocity=80, dest=synthID)