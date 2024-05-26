# IN213_projet - PressKey

Petit langage de programmation pour composer de la musique. Très fortement inspiré de [ALDA](https://alda.io/). Il a été réalisé avec :
- le générateur de lexer : [ocamllex](https://ocaml.org/manual/5.2/lexyacc.html)
- le générateur de parser : [ocamlyacc](https://ocaml.org/manual/5.2/lexyacc.html)
- La librairie Python3 [pyfluidsynth](https://github.com/nwhitehead/pyfluidsynth) pour jouer les sons à partir des soundfonts
- la librairie ocaml [pyml](https://github.com/thierry-martinez/pyml) pour intégrer l'environnement python dans le traitement de l'arbre de syntaxe abstraite. 

## Overview

Le langage inclut :
- quelques éléments de syntaxe pour afficher les informations générales d'un morceau
- la possibilité d'utiliser des **variables** pour les accords (chord), les phrases (phrase)
- la possibilité de choisir l'**instrument** qui jouera la partition (on stocke son chemin dans une variable instrument d'abord)
- la possibilité de **répéter** une note, un accord ou une phrase (element*nb)
- Beaucoup de sucres syntaxiques similaires à ceux d'ALDA (on retient la durée et l'octave précédents entre les notes successives)
- les **commentaires** sur une ligne ("//") ou sur tout un bloc (entouré de "'''")
- Une fonction **print** pour afficher des messages entre deux parties du morceau.

## Règles

- Toute expression finit par un ";".
- Pour utiliser une soundfont (fichier .sf2 **compatible fluidsynth**), il faut stocker son chemin dans une variable instrument et utiliser l'identificateur dans une partition.
- Une note s'écrit sous cette forme : \<note\> de a à g | \<octave\> de 0 à 7 | \<décalage\> dièse '+' ou bemol '-' | \<durée \> de 0 (double croche) à 4 (ronde) . Exemple : c4+'2 permet de jouer une C4# noire. c4'3 permet de jouer une C4 blanche.
- \<octave\> et \<durée \> sont facultatifs, ils ont d'abord une valeur par défaut au début du morceau puis correspondent à l'octave/durée de la note précédente. Pas de raccourci pour les accords cependant.
- Les notes des accords sont regroupées dans des parenthèses (pour la création des variables comme pour l'utilisation directe).
- Les silences se notent "_" et sont des multiples d'1/16e de note. 4* 1/16e de silence peut s'écrire : "____" ou "_4" ou "_*4".
- Par défaut, pour 2 notes successives, la 2e commence quand la 1ère termine. La 2e peut commencer plus tôt si on introduit un silence entre les deux. Pour les accords, la note suivante commence quand la plus courte note termine. 
- On peut imbriquer des phrases dans des phrases et les utiliser dans les sheets.
- La durée des notes et l'espacement entre chaque note est calculée à l'aide du BPM
- pour jouer les partitions (sheets), on les entre en paramètre de "play". Elles sont alors jouées simultanément. Les différents "play" sont joués séquentiellement.

**Astuce** : ça peut être très pratique d'utiliser un [piano_virtuel](https://virtualpiano.net/) pour gagner du temps à la composition.

**Astuce** : Créer des variables pour les différentes longueurs de silences à utiliser

## Exemple de code

```
# TITLE "Still Alive";
# COMPOSER "Jonathan Coulton";
# ARRANGER "Jarret Heather";
# BPM 120;

// Commentaire très perspicace
'''
(Long commentaire!)
Création de variables réutilisables
'''

instrument piano = "../soundfonts/Yamaha_C3_Grand_Piano.sf2"; // très agréable à l'oreille

chord accord1 (a1+'1 b2'2 c3-'3);
chord accord2 (a4'1 a5'1 c6'1);

phrase melodie1 {
    accord1 a2+'1 b- g3'4*2
    accord2 _ (c4'3 c3'2 c5'2) 
};

sheet mainDroite (piano) {
    // _ melodie1 _ accord1*2 melodie1*2 // ceci est commenté
    accord2 accord2 accord2
};

sheet mainGauche (piano) {
    accord2 _ melodie1
};

// Interprétation de la musique
print "pressKey va vous jouer quelques sons dissonants";
play(mainGauche, mainDroite); //jouées simultanément

print "Il en reste encore un peu...";
play(mainDroite);
```

## Installation

- Lancer installpk1.sh en root puis lancer installpk2.sh PAS en root.
- lancer la commande "make" (puis "make clean" parce que quand même ça fait beaucoup de fichiers...)
- Il est conseillé de [télécharger](https://musical-artifacts.com/artifacts?apps=fluidsynth) quelques soundfonts à mettre dans un dossier dont on indiquera le chemin.

## Explications

L'idée était de faire un langage pour jouer des partitions sous forme de code, semblables à du langage C. Finalement, c'est un mélange de Python et de C dont la structure apparait clairement, mais pourrait causer un peu de confusion au début car on alterne entre {}, (), et la simple séparation par un espace. 

Il est difficile de jouer des sons depuis Ocaml ou par ligne de commande (l'utilisation de FluidSynth en CLI demandait la création d'un serveur TCP...). J'ai donc opté pour une implémentation python de fluidsynth. Au début, j'appelais un programme python pour chaque son mais il s'est révélé que c'était mauvais en performances/synchronisation car Python lance une machine virtuelle dès qu'on l'appelle. Pour ne travailler qu'avec un seul environnement et simplifier les communications, j'ai utilisé pyml qui permet de très facilement executer du python depuis ocaml et échanger des variables. 

Pour programmer la succession des notes, je lis au fur et à mesure les partitions en substituant bien les identificateurs et phrases pour n'avoir que des notes et des accords. Chaque fois qu'un son (note/accord) est lu, son traitement (début/fin) est placé dans un scheduler, et à la fin de la lecture des partitions, le scheduler se lance et joue tous les sons au bon moment!

Petite différence avec le cours : je me suis familiarisé avec le gestionnaire de paquets ocaml [opam](https://opam.ocaml.org/) pour facilement installer pyml, et cela m'a aussi conduit à essayer le compilateur ocamlopt au lieu d'ocamlc, pour de meilleures performances au prix de la portabilité (il produit du ncode natif au lieu de bytecode). Je suis convaincu que ça ne fera pas de différence pour ce projet.

