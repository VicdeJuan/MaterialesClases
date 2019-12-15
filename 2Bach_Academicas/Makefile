TARGET=main
NAME=CuadernoMatesII
LATEX=/mnt/c/texlive/2018/bin/win32/pdflatex.exe
LTXMK=/mnt/c/texlive/2018/bin/win32/latexmk.exe
SAGEUTILSDIR="../Cosas guays LaTeX/"




all: copy sage
	$(LATEX) $(TARGET)

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
