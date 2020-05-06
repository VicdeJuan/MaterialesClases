#coding: utf-8

# This file was *autogenerated* from the file generatorOfPolynomials.sage
from sage.all_cmdline import *   # import sage library

_sage_const_3 = Integer(3); _sage_const_2 = Integer(2); _sage_const_1 = Integer(1); _sage_const_0 = Integer(0); _sage_const_6 = Integer(6); _sage_const_5 = Integer(5); _sage_const_4 = Integer(4); _sage_const_1p0 = RealNumber('1.0'); _sage_const_1p2 = RealNumber('1.2'); _sage_const_0p3 = RealNumber('0.3'); _sage_const_10 = Integer(10)
import re
var('x')

#set_random_seed(0)

def _latex(ss):
    s=str(ss)
    for gs in map(list,re.findall("([0-9]+)/([0-9]+)",s)):
        s=re.sub(gs[_sage_const_0 ]+"/"+gs[_sage_const_1 ],"\\\\frac{"+gs[_sage_const_0 ]+"}{"+gs[_sage_const_1 ]+"}",s)
    s=s.replace("*","")
    return s

def countDups(l):
    d={}
    for e in l:
        if e not in d:
            d[e]=_sage_const_1 
        else:
            d[e]+=_sage_const_1 
    
    return d

def _str_just_pol(ss,counter):
    ### Conseguir soluciones!
    return ss

def _str_just_pol_no_sol(ss,counter):
    return ss

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
    poly=ss[_sage_const_0 ]
    roots=""
    i=_sage_const_1 
    _rootDict=countDups(ss[_sage_const_1 ])
    for r in _rootDict:
        roots += "x_"+str(i)+" = " + _latex(r)
        if _rootDict[r] > _sage_const_1 :
            roots+= "["+ _latex(_rootDict[r]) + "]"
        roots+=" ; "
        i+=_sage_const_1 

    return "\\subitem $P_{" + str(counter) + "}(x) = " + _latex(poly) + "$ con raices: $" + _latex(roots) + " $"

def _str_poly_no_sol(ss,counter):    
    poly=ss

    return "\\subitem $P_{" + str(counter) + "}(x) = " + _latex(poly) + "$"


def mystr(s,funstr):
    return funstr(s)

def coprime(n):
    return [i for i in range(n) if gcd(i, n) == _sage_const_1 ]

def random_between(mn,mx,integer):
    retval = random()*(mx-mn)+mn
    if integer:
        return int(retval)
    return retval

def random_not_null(mn,mx,integer):
    retval = random_between(mn,mx,integer)
    if retval == _sage_const_0 :
        return random_not_null(mn,mx,integer)
    else:
        return retval

def _genIrreductiblePoly():
    __tmp__=var("x"); P = symbolic_expression(x*x+random_not_null(_sage_const_0 ,_sage_const_5 ,true)).function(x)
    return P(x)


def _genP(grado,fixedroots,rfrac,rootsRank,coefRank,degree2):
    __tmp__=var("x"); P = symbolic_expression(_sage_const_1 ).function(x)
    raices=[]

    denAcum=_sage_const_1 
    
    for i in range(degree2):
        if degree2 and grado>_sage_const_2 :
            grado-=_sage_const_2 
            __tmp__=var("x"); P = symbolic_expression(P(x) * _genIrreductiblePoly()).function(x)

    for i in range(grado):
        if fixedroots == []:
            _r=random_not_null(rootsRank[_sage_const_0 ],rootsRank[_sage_const_1 ],true)
            den=_sage_const_1 
            

            if rfrac and _r!=_sage_const_0 :
                if _r == _sage_const_1  or _r == -_sage_const_1 :
                    den = random_between(_sage_const_2 ,_sage_const_4 ,true)
                else:
                    cps = coprime(_r*_r)
                    den = cps[random_between(_sage_const_0 ,len(cps),true)]
                rfrac-=_sage_const_1 
            raices.append(Rational(_sage_const_1p0 *_r/den))
            denAcum *= den
        else:
            raices.append(fixedroots.pop())

        __tmp__=var("x"); P = symbolic_expression(P(x) * (x-raices[i])).function(x)
    if denAcum == _sage_const_1 :
        coef=int(random_between(coefRank[_sage_const_0 ],coefRank[_sage_const_1 ],true))
        if coef == _sage_const_0 :
            coef=_sage_const_1 
    else:
        coef=denAcum
    return [coef*P(x),raices]
    

#Funcion para generar una cadena de texto a partir de un polinomio generado por la funcion auxiliar _genP,
#a partir de los argumentos recibidos.
def genP(grado,fixedroots,rfrac,printsol,strfun,counter,rootsRank,coefRank,degree2):
    _r=_genP(grado,fixedroots,rfrac,rootsRank,coefRank,degree2)    
    allPols.append(_r[_sage_const_0 ].expand())
    if printsol:
        return strfun([_r[_sage_const_0 ].expand(),_r[_sage_const_1 ]],counter,printsol)
    else:
        return strfun(_r[_sage_const_0 ].expand(),counter,printsol)

 
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
    return [a[_sage_const_0 ] for a in poly.coefficients() if a[_sage_const_1 ] == poly.degree(x)][_sage_const_0 ]

# Construye el código látex de una función definida a trozos.
def construir_a_trozos(name,funs,fronts):
    retval = name + "=\\left\{\\begin{array}{ccc}"

    for i in range(len(funs)):
        if i == _sage_const_0 :
            _f = "x<"+str(fronts[i])
        elif i == (len(funs)-_sage_const_1 ):
            _f = "x>="+str(fronts[i-_sage_const_1 ])
        else:
            _f = str(fronts[i-_sage_const_1 ])+"<=x<"+str(fronts[i])
        retval += latex(funs[i]) + "& si & " + _f+"\\\\"
    retval+="\\end{array}\\right."
    return retval



def __getIntervalsFromIneq(tosolve):
    solutions = tosolve.solve(x)

    __aux = []
    for i in solutions:
        if type(i) == type(x+_sage_const_1 ):
            __aux.append(RealSet(i))
        elif type(i) == type([]):
            __aux.append(reduce(RealSet.intersection,[RealSet(a) for a in i]))
        else:
            __aux.append(RealSet(i[_sage_const_0 ]))

    if len(solutions) > _sage_const_1 :
        openpar = "\\left"
        closepar = "\\right"
    else:
        openpar = ""
        closepar = ""

    __intervals__ = " \\cup ".join(map(str,__aux))
    return openpar + "("+ __intervals__ + closepar + ")"





allPols=[]

# Generar exámenes
rootsRank=[-_sage_const_3 ,_sage_const_4 ]            # Rango de valores que pueden tomar las raices
coefRank=[-_sage_const_4 ,_sage_const_4 ]             # Rango de valores que pueden tomar los coeficientes principales.
numToGen= _sage_const_6                  # Numero de polinomios a generar de cada tipo.
degree_max = _sage_const_5               # Grado maximo de los polinomios.
degree_min = _sage_const_3               # Grado minimo de los polinomios.
    

shared_root = random_between(_sage_const_1 ,_sage_const_3 ,true)
P1=genP(grado=_sage_const_2 ,
        fixedroots=[shared_root],
        rfrac=_sage_const_1 ,
        printsol = True, 
        strfun=str_just_pol, 
        counter = _sage_const_0 ,
        rootsRank = rootsRank,
        coefRank = coefRank,
        degree2 = _sage_const_0 )

P2=genP(grado=_sage_const_2 ,
        fixedroots=[shared_root],
        rfrac=_sage_const_1 ,
        printsol = True, 
        strfun=str_just_pol, 
        counter = _sage_const_0 ,
        rootsRank = rootsRank,
        coefRank = coefRank,
        degree2 = _sage_const_0 )

Enunciado="\\paragraph{[3 puntos] 1) Estudia las asíntotas de la siguiente función (sin olvidarte de decir algo sobre las asíntotas oblicuas)} \[f(x) = \\frac{"+latex(P1[_sage_const_0 ])+"}{"+latex(P2[_sage_const_0 ])+"}\]"

_AV = copy(P2[_sage_const_1 ])
_AV.remove(shared_root)
coef_num = getCoefPoly(P1[_sage_const_0 ])
coef_den = getCoefPoly(P2[_sage_const_0 ])
str_AV = "AV: $" + ";".join(["x="+latex(av) for av in _AV])+"$. No hay asíntota en x="+str(shared_root)
str_AH = "AH: " + "$y="+latex(coef_num/coef_den)+"$."
Solucion = Enunciado + "Solución:\\\\"+str_AV+"\\\\"+str_AH



shared_root = random_not_null(_sage_const_1 ,_sage_const_3 ,true)
P1=genP(grado=_sage_const_2 ,
        fixedroots=[shared_root],
        rfrac=_sage_const_1 ,
        printsol = True, 
        strfun=str_just_pol, 
        counter = _sage_const_0 ,
        rootsRank = rootsRank,
        coefRank = coefRank,
        degree2 = _sage_const_0 )

P2=genP(grado=_sage_const_2 ,
        fixedroots=[shared_root],
        rfrac=_sage_const_1 ,
        printsol = True, 
        strfun=str_just_pol, 
        counter = _sage_const_0 ,
        rootsRank = rootsRank,
        coefRank = coefRank,
        degree2 = _sage_const_0 )


ejer2 = "\\paragraph{[3 puntos] 2) Resuelve los siguientes límites:}"
ejer2 += "\\begin{itemize}"

all_lims=[]
for count in range(_sage_const_3 ):
    P1=genP(grado=count+_sage_const_1 ,
        fixedroots=[shared_root],
        rfrac=_sage_const_0 ,
        printsol = True, 
        strfun=str_just_pol, 
        counter = _sage_const_0 ,
        rootsRank = rootsRank,
        coefRank = coefRank,
        degree2 = _sage_const_0 )
    P2=genP(grado=_sage_const_2 ,
        fixedroots=[],
        rfrac=_sage_const_0 ,
        printsol = True, 
        strfun=str_just_pol, 
        counter = _sage_const_0 ,
        rootsRank = rootsRank,
        coefRank = coefRank,
        degree2 = _sage_const_0 )

    if random() > _sage_const_0p3 :
        signo="+"
    else:
        signo="-"

    all_lims.append("\\item $\\displaystyle\\lim_{x\\to"+ signo + "\\infty} \\frac{"+latex(P1[_sage_const_0 ])+"}{"+latex(P2[_sage_const_0 ])+"}$")

shuffle(all_lims)
ejer2 += " ".join(all_lims)
ejer2 += "\\end{itemize}"

Enunciado += ejer2
Solucion+=ejer2 + "Solución: de cabeza"


ejer3 = "\\paragraph{[2 puntos] 3) Halla, si es posible, el valor de k para que la siguiente función sean continuas}\\begin{itemize}"

frontera = random_not_null(-_sage_const_10 ,_sage_const_10 ,true)
P1=genP(grado=_sage_const_1 ,
    fixedroots=[_sage_const_2 ],
    rfrac=_sage_const_1 ,
    printsol = True, 
    strfun=str_just_pol, 
    counter = _sage_const_0 ,
    rootsRank = rootsRank,
    coefRank = coefRank,
    degree2 = _sage_const_0 )

P2 = "-kx + 1"

ejer3 += "\\item\[" + construir_a_trozos("f(x)",[P1[_sage_const_0 ],P2],[frontera])+"\]"

ejer3   +="\\end{itemize}"

Enunciado  +=ejer3  
Solucion += ejer3 +"\\text{Solucion:} k="+str(-(P1[_sage_const_0 ](frontera)-_sage_const_1 )/frontera)

P3=genP(grado=_sage_const_3 ,
    fixedroots=[shared_root],
    rfrac=_sage_const_1 ,
    printsol = True, 
    strfun=str_just_pol, 
    counter = _sage_const_0 ,
    rootsRank = rootsRank,
    coefRank = [-_sage_const_5 ,-_sage_const_1 ],
    degree2 = _sage_const_1 )

P4=genP(grado=_sage_const_2 ,
    fixedroots=[shared_root],
    rfrac=_sage_const_1 ,
    printsol = True, 
    strfun=str_just_pol, 
    counter = _sage_const_0 ,
    rootsRank = rootsRank,
    coefRank = coefRank,
    degree2 = _sage_const_0 )

ejer4 = "\\paragraph{[2 puntos] 4) Halla el dominio de las siguientes funciones:}\\begin{itemize}"
ejer4 += "\\item \[f_1(x) = \\log{"+latex(P3[_sage_const_0 ])+"}\]"
ejer4 += "\\item \[f_2(x) = \\sqrt[3]{"+latex(P4[_sage_const_0 ])+"}\]"
ejer4 += "\\end{itemize}"

Enunciado+=ejer4
Solucion +=ejer4 + "\[\\text{D}(f_1) = \\mathbb{R}\]\[\\text{D}(f_2) = "+__getIntervalsFromIneq(P3[_sage_const_0 ]>_sage_const_0 )+"\]"

f=open("polys.tex","w")
f.write(Enunciado)
f.close()
g=open("polysSol.tex","w")
g.write(Solucion)
g.close()

def GenerarListaCompletaSoluciones():
    rootsRank=[-_sage_const_3 ,_sage_const_4 ]            # Rango de valores que pueden tomar las raices
    coefRank=[-_sage_const_3 ,_sage_const_3 ]             # Rango de valores que pueden tomar los coeficientes principales.
    numToGen= _sage_const_6                  # Numero de polinomios a generar de cada tipo.
    printsol = false            # Imprimir las raices de cada polinomio.
    num_rfrac_max = _sage_const_5            # Numero maximo de raices fraccionarias.
    num_rfrac_min = _sage_const_2            # Numero minimo de raices fraccionarias.
    num=_sage_const_0                        # Contador auxiliar para llevar la numeracion de los polinomios generados.
    numDegree2Pols = _sage_const_1           # Numero maximo de polinomios irreducibles de grado 2.
    degree_max = _sage_const_5               # Grado maximo de los polinomios.
    degree_min = _sage_const_3               # Grado minimo de los polinomios.
    topMargin_solutions = _sage_const_1p2    # Margen vertical entre soluciones

    for _numDegree2Pols in range(numDegree2Pols+_sage_const_1 ):
        if _numDegree2Pols:
            print "\\section{Con " + str(_numDegree2Pols) + " polinomio/s irreducible/s de grado 2}"
        else:
            print "\\section{Sin polinomios irreducibles de grado 2}"

        for rfrac in range(num_rfrac_max-num_rfrac_min+_sage_const_1 ): # rfrac: numero de raices fraccionarias por polinomio.
            num_rfrac_real = rfrac + num_rfrac_min
            print "\\subsection{Hasta "+str(num_rfrac_real) + " raices fraccionarias}"
            for _deg in range(degree_max-degree_min+_sage_const_1 ): 
                deg=_deg+degree_min  # deg: grado del polinomio.
                if num_rfrac_real>deg:
                    num_rfrac_real=deg

                print(ppart(rfrac=num_rfrac_real,deg=deg,degree2=_numDegree2Pols))
                for i in xrange(numToGen): 
                    num = num + _sage_const_1 
                    print genP(grado=deg,
                            fixedroots=[],
                            rfrac=num_rfrac_real,
                            printsol = printsol, 
                            strfun=str_poly, 
                            counter = num,
                            rootsRank = rootsRank,
                            coefRank = coefRank,
                            degree2 = _numDegree2Pols)
                    print

    print "\\newpage\\section{Soluciones}"
    for i in xrange(len(allPols)):
        p=allPols[i]
        print "\\subitem \\begin{dmath*}P_{"+str(i+_sage_const_1 )+"}(x) = " + latex(p.factor())+"\\end{dmath*}\\vspace{-" + str(topMargin_solutions) + "cm}"
    print ""
    	

