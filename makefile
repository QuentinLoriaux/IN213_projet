CAMLC=ocamlfind ocamlopt
CAMLDEP=$(BINDIR)ocamldep
CAMLLEX=$(BINDIR)ocamllex
CAMLYACC=$(BINDIR)ocamlyacc
# COMPFLAGS=-w A-4-6-9 -warn-error A -g
COMPFLAGS= -package pyml 
FLAGS = -linkpkg 

EXEC = pkplayer

# Fichiers compilés, à produire pour fabriquer l'exécutable
SOURCES = pkast.ml pkfluidapi.ml pkplay.ml 
GENERATED = pklex.ml pkparse.ml pkparse.mli
MLIS =
OBJS = $(GENERATED:.ml=.cmx) $(SOURCES:.ml=.cmx)

# Building the world
all: $(EXEC)

$(EXEC): $(OBJS)
	$(CAMLC) $(COMPFLAGS) $(FLAGS) $(OBJS) -o $(EXEC)

.SUFFIXES:
.SUFFIXES: .ml .mli .cmo .cmi .cmx
.SUFFIXES: .mll .mly

.ml.cmx:
	$(CAMLC) $(COMPFLAGS) -c $<

.mli.cmi:
	$(CAMLC) $(COMPFLAGS) -c $<

.mll.ml:
	$(CAMLLEX) $<

.mly.ml:
	$(CAMLYACC) $<

# Clean up
clean:
	rm -f *.cm[io] *.cmx *~ .*~ *.o
	rm -f parser.mli
	rm -f $(GENERATED)


# Dependencies
depend: $(SOURCES) $(GENERATED) $(MLIS)
	$(CAMLDEP) $(SOURCES) $(GENERATED) $(MLIS) > .depend

include .depend

