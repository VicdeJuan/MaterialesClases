import re
var('x')
def _latex(ss):
    s=str(ss)
    for gs in map(list,re.findall("([0-9]+)/([0-9]+)",s)):
        s=re.sub(gs[0]+"/"+gs[1],"\\\\frac{"+gs[0]+"}{"+gs[1]+"}",s)
    s=s.replace("*","")
    return s

def countDups(l):
    d={}
    for e in l:
        if e not in d:
            d[e]=1
        else:
            d[e]+=1
    
    return d

def str_poly(ss,counter):
    poly=ss[0]
    roots=""
    i=1
    _rootDict=countDups(ss[1])
    for r in _rootDict:
        roots += "x_"+str(i)+" = " + _latex(r) + " text{ de multiplicidad }" + _latex(_rootDict[r]) + " ; "
        i+=1

    return "\\subitem $P_{" + str(counter) + "}(x) = " + _latex(poly) + "$ con raices: $" + _latex(roots) + "$"


def mystr(s,funstr):
    return funstr(s)

def coprime(n):
    return [i for i in range(n) if gcd(i, n) == 1]

def random_between(mn,mx,integer):
    retval = random()*(mx-mn)+mn
    if integer:
        return int(retval)
    return retval

def random_not_null(mn,mx,integer):
    retval = random_between(mn,mx,integer)
    if retval == 0:
        return random_not_null(mn,mx,integer)
    else:
        return retval

def _genIrreductiblePoly():
    P(x)=x*x+random_between(1,5,true)
    return P(x)


def _genP(grado,fixedroots,rfrac,rootsRank,coefRank,degree2):
    P(x) = 1
    raices=[]
    
    if degree2 and grado>1:
        grado-=2
        P(x) = _genIrreductiblePoly()

    for i in range(grado):
        if fixedroots == []:
            _r=random_not_null(rootsRank[0],rootsRank[1],true)
            den=1
            

            if rfrac and _r!=0:
                if _r == 1 or _r == -1:
                    den = random_between(2,4,true)
                else:
                    cps = coprime(_r*_r)
                    den = cps[random_between(0,len(cps),true)]
            rfrac-=1
            raices.append(Rational(1.0*_r/den))
        else:
            raices.append(fixedroots.pop())
        P(x) = P(x) * (x-raices[i])
    coef=int(random_between(coefRank[0],coefRank[1],true))
    if coef == 0:
        coef=1
    return [coef*P(x),raices]
    

#Funcion para generar una cadena de texto a partir de un polinomio generado por la funcion auxiliar _genP,
#a partir de los argumentos recibidos.
def genP(grado,fixedroots,rfrac,printsol,strfun,counter,rootsRank,coefRank,degree2):
    _r=_genP(grado,fixedroots,rfrac,rootsRank,coefRank,degree2)    
    if printsol:
        return strfun([_r[0].expand(),_r[1]],counter)
    else:
        return strfun(_r[0].expand(),counter)
 
# Escribimos el titulo. Recibe la informacion necesaria para describir el tipo de polinomios que viene a continuacion.
# int rfrac: Numero de raices fraccionarias
# int deg:   Grado de los polinomios.
# boolean degree2:  Si posee o no polinomios de segundo grado irreducibles.
def ppart(rfrac,deg,degree2):
    if rfrac:
        fracroots = "con hasta " + str(rfrac)  
    else:
        fracroots = "sin"

    deg2=""
    if degree2:
        deg2 = " (contiene polinomios irreducibles de grado 2)"
    
    return "\\item Polinomios de grado: " + str(deg) + " " + fracroots + " raices fraccionarias" + deg2 + ".\\\\\\"




rootsRank=[-2,3]            # Rango de valores que pueden tomar las raices
coefRank=[2,7]              # Rango de valores que pueden tomar los coeficientes principales.
numToGen=1                  # Numero de polinomios a generar de cada tipo.
printsol = true             # Imprimir las raices de cada polinomio.
num=0                       # Contador auxiliar para llevar la numeracion de los polinomios generados.
hasDegree2Pols = true       # Contiene 1 polinomio de grado 2 irreducible.
degree = 10                 # Grado maximo de los polinomios.

for rfrac in range(4): # rfrac: numero de raices fraccionarias por polinomio.
    for _deg in range(degree-1): 
        deg=_deg+2  # deg: grado del polinomio.
        print(ppart(rfrac=rfrac,deg=deg,degree2=hasDegree2Pols))
        for i in xrange(numToGen): 
            num = num + 1
            print genP(grado=deg,
                    fixedroots=[],
                    rfrac=rfrac,
                    printsol = printsol, 
                    strfun=str_poly, 
                    counter = num,
                    rootsRank = rootsRank,
                    coefRank = coefRank,
                    degree2 = hasDegree2Pols)
            print
