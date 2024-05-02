#coding: utf-8

import re
var('x')
var('y')
var('z')
var('a')
var('b')
var('c')
var('d')
var('e')
var('s')
var('t')
var('g')

__letras = [x,y,z,a,b,c,d,e,s,t,g]
#set_random_seed(0)

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

def __no_str_just_pol(ss,counter,sols):
    return ss 

def _str_just_pol(ss,counter):
    ### Conseguir soluciones!
    return ss

def _str_just_pol_no_sol(ss,counter):
    poly=ss[0]
    return "\\$P_{" + str(counter) + "}(x) = " + _latex(poly) + "$"


def str_just_pol(ss,counter,sols):
    if sols:
        return _str_just_pol(ss,counter)
    else:
        return _str_just_pol_no_sol(ss,counter)

def str_poly(ss,counter,sols):
    if sols:
        return _str_poly_sol(ss,counter)
    else:
        return _str_poly_no_sol(ss,counter)

def _str_poly_sol(ss,counter):    
    poly=ss[0]
    roots=""
    i=1
    _rootDict=countDups(ss[1])
    for r in _rootDict:
        roots += "x_"+str(i)+" = " + _latex(r)
        if _rootDict[r] > 1:
            roots+= "["+ _latex(_rootDict[r]) + "]"
        roots+=" ; "
        i+=1

    return "\\subitem $P_{" + str(counter) + "}(x) = " + _latex(poly) + "$ con raices: $" + _latex(roots) + " $"

def _str_poly_no_sol(ss,counter):    
    poly=ss

    return "\\subitem $P_{" + str(counter) + "}(x) = " + _latex(poly) + "$"


def mystr(s,funstr):
    return funstr(s)
    
def coprime(n):
    return [i for i in range(n) if gcd(i, n) == 1 and i != 1]
    
    
def random_between(mn,mx,integer):
    retval = random()*(mx-mn)+mn
    if integer:
        return int(retval)
    return retval

def _random_not_null(mn,mx,integer,reclim):
    retval = random_between(mn,mx,integer)
    if retval == 0:
        if mn == 0 and (mx == 1 or mx == 0):
            return 1
        elif reclim > 0:
            return _random_not_null(mn,mx,integer,reclim-1)
        else:
            return 1
    else:
        return retval


def random_not_null(mn,mx,integer):
    retval = random_between(mn,mx,integer)
    if retval == 0:
        if mn == 0 and (mx == 1 or mx == 0):
            return 1
        else:
            return _random_not_null(mn,mx,integer,5)
    else:
        return retval

def _genIrreductiblePoly():
    P(x)=x*x+random_not_null(0,5,true)
    return P(x)

def __sum(a,b):
    return a+b
def __prod(a,b):
    return a*b




def _genP(grado,fixedroots,rfrac,rootsRank,coefRank,degree2):
    P(x) = 1
    raices=[]

    denAcum=1
    
    for i in range(degree2):
        if degree2 and grado>2:
            grado-=2
            P(x) = P(x) * _genIrreductiblePoly()

    for i in range(grado):
        if fixedroots == []:
            _r=random_not_null(rootsRank[0],rootsRank[1],true)
            den=1
            

            if rfrac and _r!=0:
                if _r == 1 or _r == -1:
                    den = random_between(2,4,true)
                else:
                    den = getDenominator(_r)
                rfrac-=1
            raices.append(Rational(1.0*_r/den))
            denAcum *= den
        else:
            raices.append(fixedroots.pop())

        P(x) = P(x) * (x-raices[i])
    if denAcum == 1:
        coef=int(random_between(coefRank[0],coefRank[1],true))
        if coef == 0:
            coef=1
    else:
        coef=denAcum
    return [coef*P(x),raices]
    

#Funcion para generar una cadena de texto a partir de un polinomio generado por la funcion auxiliar _genP,
#a partir de los argumentos recibidos.
def genP(grado,fixedroots,rfrac,printsol,strfun,counter,rootsRank,coefRank,degree2):
    _r=_genP(grado,fixedroots,rfrac,rootsRank,coefRank,degree2)    
    allPols.append(_r[0].expand())
    if printsol:
        return strfun([_r[0].expand(),_r[1]],counter,printsol)
    else:
        return strfun(_r[0].expand(),counter,printsol)



def _genPolNoRoots(grado,letters,printsol,strfun,coefRank,numTerms):
    return [reduce(__sum,[
                reduce(__prod, [
                    random_not_null(coefRank[0],coefRank[1],True)*l**random_not_null(1,ceil(grado/len(letters)),True) 
                for l in letters])
            for i in range(numTerms)]),""]

# Función para generar una cadena de texto a partir de un polinomio generado por la funcion auxiliar 
# _genPolNoRoots a partir de los argumentos recibidos.
def genPolNoRoots(grado,letters,printsol,strfun,coefRank,numTerms,counter):
    _r=_genPolNoRoots(grado,letters,printsol,strfun,coefRank,numTerms)    
    allPols.append(_r[0].expand())
    if printsol:
        return strfun([_r[0].expand(),_r[1]],counter,printsol)
    else:
        return strfun(_r[0].expand(),counter,printsol)

def identity(x):
    return x


def getDenominator(num):
    cps = coprime(num*num)
    den = cps[random_between(0,len(cps),true)]
    if den == 0:
        getDenominator(num)
    else:
        return den





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
        deg2 = " (contiene un polinomio irreducible de grado 2)"
    
    return "" # "\\textbf{Polinomios de grado " + str(deg) + "} " #+ fracroots + " raices fraccionarias" + deg2 + ".\\\\\\"

# Devuelve el coeficniente principal del polinomio dado.
def getCoefPoly(poly):
    return [a[0] for a in poly.coefficients() if a[1] == poly.degree(x)][0]

# Construye el código látex de una función definida a trozos.
def construir_a_trozos(name,funs,fronts):
    retval = name + "=\\left\{\\begin{array}{ccc}"

    for i in range(len(funs)):
        if i == 0:
            _f = "x<"+str(fronts[i])
        elif i == (len(funs)-1):
            _f = "x>="+str(fronts[i-1])
        else:
            _f = str(fronts[i-1])+"<=x<"+str(fronts[i])
        retval += latex(funs[i]) + "& si & " + _f+"\\\\"
    retval+="\\end{array}\\right."
    return retval



def __getIntervalsFromIneq(tosolve):
    solutions = tosolve.solve(x)

    __aux = []
    for i in solutions:
        if type(i) == type(x+1):
            __aux.append(RealSet(i))
        elif type(i) == type([]):
            __aux.append(reduce(RealSet.intersection,[RealSet(a) for a in i]))
        else:
            __aux.append(RealSet(i[0]))

    if len(solutions) > 1:
        openpar = "\\left"
        closepar = "\\right"
    else:
        openpar = ""
        closepar = ""

    __intervals__ = " \\cup ".join(map(str,__aux))
    return openpar + "("+ __intervals__ + closepar + ")"



def genIdentidadNotable(tipo,fraccion,numletras,strfun):

    exp1 = random_not_null(2,7,true)
    if fraccion >= 2:
        den = getDenominator(exp1)
        exp1 = Rational(exp1*1.0/den)
    letras_utilizadas=[]
    n=random_between(2,numletras,true)
    for b in range(n):
        letras_utilizadas.append(__letras[b])
        exp1 = exp1*__letras[b]
       


    exp2 = random_not_null(1,9,true)
    if fraccion >= 1:
        den = getDenominator(exp2)
        exp2 = Rational(exp2*1.0/den)
    letras_para_usar = [item for item in __letras if item not in letras_utilizadas]
    for b in range(random_between(0,numletras - len(letras_utilizadas) ,true)):
        exp2 = exp2*letras_para_usar[b]


    if tipo == "suma":
        return "\\left(" + strfun(exp1) + "+" + strfun(exp2) + "\\right)^2"
    elif tipo == "resta":
        return "\\left(" + strfun(exp1) + "-" + strfun(exp2) + "\\right)^2"
    elif tipo == "sumaresta":
      return "\\left(" + strfun(exp1) + "+" + strfun(exp2) + "\\right)" + "\\left(" + strfun(exp1) + "-" + strfun(exp2) + "\\right)"
          


def GenerarListaCompletaSoluciones():
    rootsRank=[-3,4]            # Rango de valores que pueden tomar las raices
    coefRank=[-3,3]             # Rango de valores que pueden tomar los coeficientes principales.
    numToGen= 6                 # Numero de polinomios a generar de cada tipo.
    printsol = false            # Imprimir las raices de cada polinomio.
    num_rfrac_max = 5           # Numero maximo de raices fraccionarias.
    num_rfrac_min = 2           # Numero minimo de raices fraccionarias.
    num=0                       # Contador auxiliar para llevar la numeracion de los polinomios generados.
    numDegree2Pols = 1          # Numero maximo de polinomios irreducibles de grado 2.
    degree_max = 5              # Grado maximo de los polinomios.
    degree_min = 3              # Grado minimo de los polinomios.
    topMargin_solutions = 1.2   # Margen vertical entre soluciones

    for _numDegree2Pols in range(numDegree2Pols+1):
        if _numDegree2Pols:
            print("\\section{Con " + str(_numDegree2Pols) + " polinomio/s irreducible/s de grado 2}")
        else:
            print("\\section{Sin polinomios irreducibles de grado 2}")

        for rfrac in range(num_rfrac_max-num_rfrac_min+1): # rfrac: numero de raices fraccionarias por polinomio.
            num_rfrac_real = rfrac + num_rfrac_min
            print("\\subsection{Hasta "+str(num_rfrac_real) + " raices fraccionarias}")
            for _deg in range(degree_max-degree_min+1): 
                deg=_deg+degree_min  # deg: grado del polinomio.
                if num_rfrac_real>deg:
                    num_rfrac_real=deg

                print(ppart(rfrac=num_rfrac_real,deg=deg,degree2=_numDegree2Pols))
                for i in xrange(numToGen): 
                    num = num + 1
                    print(genP(grado=deg,
                            fixedroots=[],
                            rfrac=num_rfrac_real,
                            printsol = printsol, 
                            strfun=str_poly, 
                            counter = num,
                            rootsRank = rootsRank,
                            coefRank = coefRank,
                            degree2 = _numDegree2Pols))
                    print("")

    print("\\newpage\\section{Soluciones}")
    for i in xrange(len(allPols)):
        p=allPols[i]
        print("\\subitem \\begin{dmath*}P_{"+str(i+1)+"}(x) = " + latex(p.factor())+"\\end{dmath*}\\vspace{-" + str(topMargin_solutions) + "cm}")
    print("")

########################################## MAIN
allPols=[]

# Generar exámenes
rootsRank=[-3,4]            # Rango de valores que pueden tomar las raices
coefRank=[-4,4]             # Rango de valores que pueden tomar los coeficientes principales.
numToGen= 6                 # Numero de polinomios a generar de cada tipo.
degree_max = 5              # Grado maximo de los polinomios.
degree_min = 3              # Grado minimo de los polinomios.
Enunciado=""
Solucion=""

genPolNoRoots(grado = degree_max,
            letters = [x,y,z],
            printsol = True,
            strfun = str_just_pol,
            coefRank = coefRank,
            numTerms = 5,
            counter = 0)

#P1=genP(grado=3,fixedroots=[],rfrac=1,printsol = True, strfun=str_just_pol, counter = 0,rootsRank = rootsRank,coefRank = coefRank,degree2 = 0)
#P2=genP(grado=2,fixedroots=[],rfrac=1,printsol = True, strfun=str_just_pol, counter = 0,rootsRank = rootsRank,coefRank = coefRank,degree2 = 0)

#Enunciado ="\\paragraph{[4 puntos] 1) Dados $P(x) = "+latex(P1[0])+"$ y $Q(x) = "+latex(P2[0])+"$, realiza las siguientes operaciones:}"
#Enunciado += "\\begin{itemize}\\item\\textit{1 pto}\;\; $P(x) - Q(x)$\\item \\textit{1pto}\;\; $\\left(-2x^2\\right) \\cdot P(x)$\\item\\textit{2ptos}\;\;$P(x)\\cdot Q(x)$  \\end{itemize}"
#Enunciado += "\\paragraph{[6 puntos] 2) Resuelve las siguientes operaciones:}"
#Enunciado += "\\begin{itemize}"
#all_items = []
#all_items.append("\\item $" + genIdentidadNotable("suma",0,3,latex)+"$")
#all_items.append("\\item $" + genIdentidadNotable("suma",1,3,latex)+"$")
#all_items.append("\\item $" + genIdentidadNotable("resta",0,3,latex)+"$")
#all_items.append("\\item $" + genIdentidadNotable("resta",1,5,latex)+"$")
#all_items.append("\\item $" + genIdentidadNotable("sumaresta",0,1,latex)+"$")
#all_items.append("\\item $" + genIdentidadNotable("sumaresta",2,2,latex)+"$")
#shuffle(all_items)
#Enunciado += " ".join(all_items)
#Enunciado += "\\end{itemize}"


genPolNoRoots(grado = degree_max,
            letters = [x,y,z],
            printsol = True,
            strfun = str_just_pol,
            coefRank = coefRank,
            numTerms = 5,
            counter = 0)

def genPolNoRoots_2024_05_02(letras,grado_max,nTerms,contador):
    return genPolNoRoots(grado = grado_max,
            letters = letras,
            printsol = True,
            strfun = __no_str_just_pol,
            coefRank = [-4,4],
            numTerms = nTerms,
            counter = contador)

Enunciado_2024_05_02 = "\\paragraph{ Realiza las siguientes operaciones }"
Solucion_2024_05_02 = ""

def _concat_with_plus(a,b):
    if a[0] == "-" and b[0] != "-":
        return b + " + " + a
    elif b[0] == "-" and a[0] == "-":
        return a + " + (" + b +")"
    else:
        return a + " + " + b

## EJERCICIO 1
## Solo suma de 3 polinomios de 3 letras
for a in range(5):
    grado_max = 7
    nTerms = 3
    letras = [x]
    P1 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    P2 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    P3 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    Enunciado_2024_05_02 += "\\subitem ["+str(a)+"]$" + reduce(_concat_with_plus,[latex(P1[0]),latex(P2[0]),latex(P3[0])]) + "$"
    Solucion_2024_05_02 += "\\subitem ["+str(a)+"]$" + reduce(_concat_with_plus,[latex(P1[0]),latex(P2[0]),latex(P3[0])]) + " = " + latex(P1[0]+P2[0]+P3[0])+ "$"


## EJERCICIO 2
## Solo suma de 3 polinomios de 3 letras
for a in range(5):
    grado_max = 7
    nTerms = 3
    letras = [x,y,a]
    P1 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    P2 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    P3 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    Enunciado_2024_05_02 += "\\subitem ["+str(a)+"]$" + reduce(_concat_with_plus,[latex(P1[0]),latex(P2[0]),latex(P3[0])]) + "$"
    Solucion_2024_05_02 += "\\subitem ["+str(a)+"]$" + reduce(_concat_with_plus,[latex(P1[0]),latex(P2[0]),latex(P3[0])]) + " = " + latex(P1[0]+P2[0]+P3[0])+ "$"

## EJERCICIO 3
## Suma y resta de 3 polinomios de 3 letras
for a in range(5):
    grado_max = 7
    nTerms = 3
    letras = [x,y,a]
    P1 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    P2 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    P3 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    Enunciado_2024_05_02 += "\\subitem ["+str(a)+"]$" + latex(P1[0])+" + "+latex(P2[0])+ "- (" + latex(P3[0])+")" + "$"
    Solucion_2024_05_02 += "\\subitem ["+str(a)+"]$" + latex(P1[0])+" + "+latex(P2[0])+ "- (" + latex(P3[0])+")" + " = " + latex(P1[0]+P2[0]-P3[0])+ "$"

## EJERCICIO 4
## Multiplicación de monomios

for a in range(5):
    grado_max = 3*12+1
    nTerms = 1
    letras = [x,y,z,a,b]
    P1 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    P2 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    P3 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    Enunciado_2024_05_02 += "\\subitem ["+str(a)+"]$ (" + latex(P1[0])+") · ("+latex(P2[0])+ ")$"
    Solucion_2024_05_02 += "\\subitem ["+str(a)+"]$ (" + latex(P1[0])+") · ("+latex(P2[0])+ ") = " + latex(P1[0]*P2[0])+ "$"


## EJERCICIO 5
## Multiplicación de polinomios

for a in range(5):
    grado_max = 3
    nTerms = 3
    letras = [x]
    P1 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    P2 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    P3 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    Enunciado_2024_05_02 += "\\subitem ["+str(a)+"]$ (" + latex(P1[0])+") · ("+latex(P2[0])+ ")$"
    Solucion_2024_05_02 += "\\subitem ["+str(a)+"]$ (" + latex(P1[0])+") · ("+latex(P2[0])+ ") = " + latex(P1[0]*P2[0])+ "$"

## EJERCICIO 5
## Multiplicación de polinomios

for a in range(5):
    grado_max = 3
    nTerms = 4
    letras = [x]
    P1 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    P2 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    P3 = genPolNoRoots_2024_05_02(letras,grado_max,nTerms,a)
    Enunciado_2024_05_02 += "\\subitem ["+str(a)+"]$ (" + latex(P1[0])+") · ("+latex(P2[0])+ ")$"
    Solucion_2024_05_02 += "\\subitem ["+str(a)+"]$ (" + latex(P1[0])+") · ("+latex(P2[0])+ ") = " + latex(P1[0]*P2[0])+ "$"




print(Enunciado_2024_05_02)
print(Solucion_2024_05_02)


f=open("polys.tex","w")
f.write(Enunciado_2024_05_02)
f.close()
g=open("polysSol.tex","w")
g.write(Solucion_2024_05_02)
g.close()
