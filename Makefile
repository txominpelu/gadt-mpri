
MODULES =					\
  first_gadt				\
  interpreter				\

OCAMLC = ocamlc
OCAMLDOC = ocamldoc
OCAMLOPT = ocamlopt

BFLAGS = -dtypes

EXECUTABLE = gadt

all: $(EXECUTABLE)

$(EXECUTABLE): $(MODULES:%=%.cmo)
	$(OCAMLC) $(BFLAGS) -o $(EXECUTABLE) $(MODULES:%=%.cmo)

$(EXECUTABLE).opt: $(MODULES:%=%.cmx)
	$(OCAMLOPT) -o $(EXECUTABLE) $(MODULES:%=%.cmx)

%.cmo: %.ml
	$(OCAMLC) $(BFLAGS) -c $*.ml

%.cmi: %.mli
	$(OCAMLC) $(BFLAGS) -c $*.mli

%.cmx: %.ml
	$(OCAMLOPT) -c $*.ml
