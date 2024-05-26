import time
import sched
import fluidsynth

# ======= Démarrage de fluidsynth =======

fs = fluidsynth.Synth()
fs.start( driver='alsa', midi_driver='alsa_seq')  
fs.setting('synth.gain', 7.0)
scheduler = sched.scheduler(time.time, time.sleep)

timeCursor = 0
channelCount = -1
curr_octave = 4 # par défaut
curr_duration = 0 # par défaut
velocity = 70 # par défaut
delay_buffer = 0 # par défaut
debug = 0

# ========= Tools ==========
convert = {'c': 0, 'd': 2, 'e': 4, 'f': 5, 'g' : 7, 'a' : 9, 'b' : 11}
durations = [1/4, 1/2, 1.0, 2.0, 4.0]


def decipher(note):
    global bpm, curr_octave, curr_duration
    # CHOIX : la plus petite unité de durée est la double croche = 1/16e de note

    # ==== Silence ====
    if note[0] == '_':
        if len(note) >= 2: 
            if note[1] == '_':
                return 0, durations[0]*len(note) * 60.0 / bpm
            else :
                return 0, durations[0]*int(note[1:]) * 60.0 /bpm
        return 0, durations[0] * 60.0 / bpm 
    # On ne modifie pas curr_duration pour un silence
         

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
        if int(note[index_cpt+2]) > 4 :
            raise Exception('Erreur : La durée doit être comprise entre 0 et 4')
        curr_duration = int(note[index_cpt+2])

    return height, durations[curr_duration] * 60.0 /bpm


def addNote(note):
    global bpm, scheduler, timeCursor, channelCount, velocity, delay_buffer
    height, duration = decipher(note)
    if height == 0 : # silence
        timeCursor += duration
        delay_buffer = 0
    else:
        timeCursor += delay_buffer
        scheduler.enter(timeCursor,1,fs.noteon, argument=(channelCount, height, velocity))
        scheduler.enter(timeCursor + duration,1,fs.noteoff, argument=(channelCount, height))
        delay_buffer = duration # dans le cas où le prochain serait une note
    # par défaut, la note commence quand la précédente se termine. Un silence peut remplacer ce comportement
    #(différence durée note / durée entre les notes)


def addChord(notes):
    global bpm, scheduler, timeCursor, channelCount, velocity, delay_buffer
    timeCursor += delay_buffer
    minDuration = 100
    for note in notes:
        height, duration = decipher(note)
        minDuration = min(minDuration, duration)
        if height == 0 : # silence
            raise Exception('Erreur : pas de silence dans les accords')
        else:
            scheduler.enter(timeCursor,1,fs.noteon, argument=(channelCount, height, velocity))
            scheduler.enter(timeCursor + duration,1,fs.noteoff, argument=(channelCount, height))
    timeCursor += durations[0] * 60.0 / bpm
    delay_buffer = minDuration


def addSheet(instrument):
    global fs, curr_duration, curr_octave, timeCursor, channelCount
    # Reset values
    timeCursor = 0
    curr_octave = 4
    curr_duration = 0

    # Change channel
    channelCount += 1
    sfid = fs.sfload(instrument)
    fs.program_select(channelCount, sfid, 0, 0)
    


def runScheduler():
    global scheduler
    scheduler.run()

print('Python launched')




# ======= tests =======
bpm = 60


instrument1 = './soundfonts/Salsa_Brass.sf2'
instrument2 = './soundfonts/Yamaha_C3_Grand_Piano.sf2'
test = ['o4c0', 'o5c2', 'o5c4']

addSheet(instrument1)
addChord(test)
addNote('_2')
addNote('o4c4')
addSheet(instrument2)
addNote('_4')
addChord(test)
addNote('_2')
addNote('o4c4')
runScheduler()

