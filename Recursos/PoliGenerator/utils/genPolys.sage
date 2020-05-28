#coding: utf-8

import re
var('x')

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
    P=x*x+random_not_null(0,5,true)
    return P


def _genP(grado,fixedroots,rfrac,rootsRank,coefRank,degree2):
    P = 1
    raices=[]

    denAcum=1
    
    for i in range(degree2):
        if degree2 and grado>2:
            grado-=2
            P = P * _genIrreductiblePoly()

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
            denAcum *= den
        else:
            raices.append(fixedroots.pop())

        P = P * (x-raices[i])
    if denAcum == 1:
        coef=int(random_between(coefRank[0],coefRank[1],true))
        if coef == 0:
            coef=1
    else:
        coef=denAcum
    return [coef*P,raices]
    

#Funcion para generar una cadena de texto a partir de un polinomio generado por la funcion auxiliar _genP,
#a partir de los argumentos recibidos.
def genP(grado,fixedroots,rfrac,printsol,strfun,counter,rootsRank,coefRank,degree2):
    _r=_genP(grado,fixedroots,rfrac,rootsRank,coefRank,degree2)    
    allPols.append(_r[0].expand())
    if printsol:
        return strfun([_r[0].expand(),_r[1]],counter,printsol)
    else:
        return strfun(_r[0].expand(),counter,printsol)

 
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




