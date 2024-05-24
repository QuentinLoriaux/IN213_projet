# IN213_projet - PressKey
Simple programming language for music composition
Highly inspired from alda



## TODO

lexer
parser
ast

<!-- scoping -->
<!-- typing -->
compile

regarder ml, mli


installer python3 + pip
télécharger des soundfonts (ex: piano.sf2)
pip install pyfluidsynth

opam install pyml
attention : eval $(opam env --switch=default)
(à mettre dans le .bashrc eventuellement)

produire un fichier qu'on lit avec un interpreteur python?  
mettre du python dans mon ocaml...
le pkloop = pkinterpret.ml jouera la musique.

in a sheet:
    load instrument once? (need != instances of fluidsynth?)

play directly notes
then add to the scheduler "noteoffs" note by note

func play (r | o4c+4 , instance_for_instrument):
    silent => unix wait
    note => play + schedule end
