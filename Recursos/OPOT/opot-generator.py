#encoding: utf-8
#!/usr/bin/python



import sys

if len(sys.argv) == 1:
	print "Error, falta argumento"
	exit()	

listnumber = int(sys.argv[1])

def _getDigits(listnumber):
	return [(listnumber - listnumber%10)/10,listnumber%10]

#def generateSolution(dec,unit):


def generateData(dec,unit):
	return [2,"x+y=2","A(0,0)","B(2,2)"]


listnumber = 15
_ENUNCIADO = "Halla el/los punto/s del plano que están a distancia %d de la recta $%s$ y equidistan de los puntos $%s$ y $%s$"
[dec,unit] = _getDigits(listnumber)
[dist, recta, A,B] = generateData(dec,unit)
print(_ENUNCIADO % tuple(generateData(dec,unit)))
