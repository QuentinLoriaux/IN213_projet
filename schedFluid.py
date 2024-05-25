import time
import sched
import fluidsynth
import numpy as np

# ========= Tools ==========
convert = {'c': 0, 'd': 2, 'e': 4, 'f': 5, 'g' : 7, 'a' : 9, 'b' : 11}
durations = [1/4, 1/2, 1.0, 2.0, 4.0]


def decipher(note):
    global bpm, curr_octave, curr_duration

    # ==== Silence ====
    if note[0] == 'r':
        if len(note) == 2: # Durée précisée
            curr_duration = int(note[1])
        return 0, durations[curr_duration] * 60.0 / bpm
         

    # ==== Actual Note ====
    index_cpt = 0
    if note[0] == 'o': # octave précisé
        index_cpt = 2 # indice de la lettre
        curr_octave = int(note[1])
    height = 12 + int(curr_octave)*12 + convert[note[index_cpt]] 

    if note[index_cpt+1] == '+':
        height+=1
    elif note[index_cpt+1]=='-':
        height-=1
    else:
        index_cpt -= 1 # indice avant la lettre (comme ça en faisant +2 on a la durée)
    
    if len(note) == index_cpt + 3 : # Durée précisée
        curr_duration = int(note[index_cpt+2])

    return heigh, durations[curr_duration] * 60.0 /bpm


# for i in range(num_events):
#     scheduler.enter(0, 1, my_function, argument=(i,))

def addNote(note):
    global bpm, scheduler, timeCursor, channelCount, velocity
    height, duration = decipher(note)
    scheduler.enter(timeCursor,1,fs.noteon, argument=(channelCount, height, velocity))
    scheduler.enter(timeCursor + duration,1,fs.noteoff, argument=(channelCount, height, velocity))

def addSheet(instrument):
    global fs, curr_duration, curr_octave, timeCursor, channelCount
    
    # Reset values
    timeCursor = 0
    curr_octave = 4
    curr_duration = 0

    # Change channel
    sfid = fs.sfload(instrument)
    fs.program_select(channelCount, sfid, 0, 0)
    channelCount += 1

def runScheduler():
    global scheduler
    

# def scheduler(notes):
#     order = np.argsort([note[1] for note in notes])
#     timers = [notes[order[0]][1]]
#     for k in range(len(notes)-1):
#         timers.append(notes[order[k+1]][1] - notes[order[k]][1])
#     return timers, order


# ======= Params =======
bpm = 60


instrument1 = './soundfonts/Salsa_Brass.sf2'
instrument2 = './soundfonts/Yamaha_C3_Grand_Piano.sf2'
test = ['o4c0', 'o5c2', 'o5c4']

# ======= Démarrage de fluidsynth =======

fs = fluidsynth.Synth()
fs.start( driver='alsa', midi_driver='alsa_seq')  
fs.setting('synth.gain', 7.0)
scheduler = sched.scheduler(time.time, time.sleep)

timeCursor = 0
channelCount = 0
curr_octave = 4 # par défaut
curr_duration = 0 # par défaut
velocity = 70 # par défaut



# ======= Traitement des notes =======
sfid1 = fs.sfload(instrument1)
fs.program_select(0, sfid1, 0, 0)
sfid2 = fs.sfload(instrument2)
fs.program_select(1, sfid2, 0, 0)

notes = [decipher(k, bpm) for k in test]
timers, order = scheduler(notes)
print(timers)

for note in notes:
    fs.noteon(0, note[0], 70)

for k in range(len(notes)):
    time.sleep(timers[k])
    fs.noteoff(0, notes[order[k]][0])

for note in notes:
    fs.noteon(1, note[0], 70)

for k in range(len(notes)):
    time.sleep(timers[k])
    fs.noteoff(1, notes[order[k]][0])

