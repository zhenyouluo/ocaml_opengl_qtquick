OCAMLOPT=ocamlfind opt
OUT=openglunderqml
MOC=moc
CXXFLAGS=-fPIC `pkg-config --cflags Qt5Quick`
LDFLAGS=`pkg-config --libs Qt5Quick` -lGL
CC=g++ -g -std=c++0x
KAMLLIB=camlcode.o
CMX=magic.cmx


.SUFFIXES: .cpp .o .ml .cmx
.PHONY: clean all

all: $(OUT)

$(OUT): main.o kamlo.o moc_squircle.o squircle.o $(KAMLLIB)
	$(CC) $^ -L`ocamlc -where` -lasmrun -lunix -lcamlstr $(NATIVECCLIBS) $(LDFLAGS) -o $(OUT)

$(KAMLLIB): $(CMX)
	$(OCAMLOPT) -output-obj -dstartup $(CMX) -linkall -o $@

moc_squircle.o: moc_squircle.cpp

moc_%.cpp: %.h
	$(MOC) $< > $@

.ml.cmx:
	$(OCAMLOPT) -c $<

.cpp.o:
	$(CC) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f *.o *.cm[iox] camlcode.o.startup.s $(KAMLLIB) moc_squircle.cpp $(OUT)

-include  $(shell ocamlc -where)/Makefile.config