CAMLC=ocamlfind ocamlopt

EXEC= test.exe

FLAGS=-o $(EXEC) -linkpkg -package pyml 

all:  $(EXEC) run

run:
	./test.exe

# setup:
# 	eval $(opam env --switch=default)

$(EXEC) : test.ml
	$(CAMLC) $(FLAGS) $^