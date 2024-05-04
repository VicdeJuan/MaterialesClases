#!/bin/bash

# Definir la cantidad de archivos a generar
cantidad_archivos=60

# Bucle for para generar archivos con touch y renombrarlos
for ((i = 1; i <= cantidad_archivos; i++)); do
    # Generar el archivo usando touch
    zsh generateAll.sh

    # Renombrar el archivo con un número según el bucle
    mv PolyGenerator.pdf Enunciado_$i.pdf
    mv PolyGeneratorSolution.pdf Soluciones_$i.pdf    
done
