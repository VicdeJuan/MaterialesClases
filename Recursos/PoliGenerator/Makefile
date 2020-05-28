LATEX=/mnt/c/texlive/2018/bin/win32/pdflatex.exe
LTXMK=/mnt/c/texlive/2018/bin/win32/latexmk.exe


all:
	echo "Error, no definida regla all"


genPolys:
	sage generatorOfPolynomials.sage

compile: 
	$(LATEX) PolyGenerator.tex	
	#$(LATEX) PolyGenerator.tex	
	#$(LATEX) PolyGenerator.tex	
	$(LATEX) PolyGeneratorSolution.tex	


generarExamen: genPolys	compile	
	mv PolyGenerator.pdf "Examen$(shell cat num).pdf"
	mv PolyGeneratorSolution.pdf "Sol_Examen$(shell cat num).pdf"
	python -c "print($(shell cat num)+1)" > num

reset:
	echo 0 > num

clean: reset
	rm Examen*.pdf
	rm Sol_Examen*.pdf
	$(LTXMK) -C


test: reset
	python -c 'print(open("num","r").read())' 
	NUM=$(shell cat num)
	echo $(NUM)
	
