#!/bin/bash

# Definir la cantidad de archivos a generar
cantidad_archivos=60

# Bucle for para generar archivos con touch y renombrarlos
for ((i = 1; i <= cantidad_archivos; i++)); do
    # Generar el archivo usando touch
 	sage generatorOfPolynomials.sage
	pdflatex PolyGenerator.tex
	pdflatex PolyGenerator.tex
	pdflatex PolyGenerator.tex
	pdflatex PolyGeneratorSolution.tex
	pdflatex PolyGeneratorSolution.tex
	pdflatex PolyGeneratorSolution.tex
    mv PolyGenerator.pdf Enunciados/Enunciado_$i.pdf
    mv PolyGeneratorSolution.pdf Soluciones/Soluciones_$i.pdf
    latexmk -C
    # Renombrar el archivo con un número según el bucle

done

