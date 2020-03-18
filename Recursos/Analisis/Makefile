TARGET=main
NAME=EstudioFunciones
LATEX=/mnt/c/texlive/2018/bin/win32/pdflatex.exe
LTXMK=/mnt/c/texlive/2018/bin/win32/latexmk.exe
SAGEUTILSDIR="../../Cosas guays LaTeX/"




all: copy sage
	$(LATEX) $(TARGET)

updatePy:
	cat $(SAGEUTILSDIR)sageUtilities.tex | grep begin{sagesilent} -A 100000000 | grep end{sagesilent} -B 1000000000 | sed -n '1!p' | head -n -1 | sed -e 's/á/a/g'| sed -e 's/é/e/g'| sed -e 's/í/i/g'| sed -e 's/ó/o/g'| sed -e 's/ú/u/g'| sed -e 's/ñ/gn/g'| sed -e 's/¿//g'> PyTests/AnalisisAutomatico.py 

copy:
	cp $(SAGEUTILSDIR)sageUtilities.tex sageUtilities.notvalid

latex: tex/ $(TARGET).tex
	$(LATEX) $(TARGET)

sage: latex
	sage $(TARGET).sagetex.sage

resage:
	$(LATEX) $(TARGET)
	sage $(TARGET).sagetex.sage

clean:
	rm -r *sage*
	$(LTXMK) -C
