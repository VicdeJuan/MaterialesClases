
shared_root = random_between(1,3,true)
P1=genP(grado=2,
        fixedroots=[shared_root],
        rfrac=1,
        printsol = True, 
        strfun=str_just_pol, 
        counter = 0,
        rootsRank = rootsRank,
        coefRank = coefRank,
        degree2 = 0)

P2=genP(grado=2,
        fixedroots=[shared_root],
        rfrac=1,
        printsol = True, 
        strfun=str_just_pol, 
        counter = 0,
        rootsRank = rootsRank,
        coefRank = coefRank,
        degree2 = 0)

Enunciado="\\paragraph{[3 puntos] 1) Estudia las asíntotas de la siguiente función (sin olvidarte de decir algo sobre las asíntotas oblicuas)} \[f(x) = \\frac{"+latex(P1[0])+"}{"+latex(P2[0])+"}\]"

_AV = copy(P2[1])
_AV.remove(shared_root)
coef_num = getCoefPoly(P1[0])
coef_den = getCoefPoly(P2[0])
str_AV = "AV: $" + ";".join(["x="+latex(av) for av in _AV])+"$. No hay asíntota en x="+str(shared_root)
str_AH = "AH: " + "$y="+latex(coef_num/coef_den)+"$."
Solucion = Enunciado + "Solución:\\\\"+str_AV+"\\\\"+str_AH



shared_root = random_not_null(1,3,true)
P1=genP(grado=2,
        fixedroots=[shared_root],
        rfrac=1,
        printsol = True, 
        strfun=str_just_pol, 
        counter = 0,
        rootsRank = rootsRank,
        coefRank = coefRank,
        degree2 = 0)

P2=genP(grado=2,
        fixedroots=[shared_root],
        rfrac=1,
        printsol = True, 
        strfun=str_just_pol, 
        counter = 0,
        rootsRank = rootsRank,
        coefRank = coefRank,
        degree2 = 0)


ejer2 = "\\paragraph{[3 puntos] 2) Resuelve los siguientes límites:}"
ejer2 += "\\begin{itemize}"

all_lims=[]
for count in range(3):
    P1=genP(grado=count+1,
        fixedroots=[shared_root],
        rfrac=0,
        printsol = True, 
        strfun=str_just_pol, 
        counter = 0,
        rootsRank = rootsRank,
        coefRank = coefRank,
        degree2 = 0)
    P2=genP(grado=2,
        fixedroots=[],
        rfrac=0,
        printsol = True, 
        strfun=str_just_pol, 
        counter = 0,
        rootsRank = rootsRank,
        coefRank = coefRank,
        degree2 = 0)

    if random() > 0.3:
        signo="+"
    else:
        signo="-"

    all_lims.append("\\item $\\displaystyle\\lim_{x\\to"+ signo + "\\infty} \\frac{"+latex(P1[0])+"}{"+latex(P2[0])+"}$")

shuffle(all_lims)
ejer2 += " ".join(all_lims)
ejer2 += "\\end{itemize}"

Enunciado += ejer2
Solucion+=ejer2 + "Solución: de cabeza"


ejer3 = "\\paragraph{[2 puntos] 3) Halla, si es posible, el valor de k para que la siguiente función sean continuas}\\begin{itemize}"

frontera = random_not_null(-10,10,true)
P1=genP(grado=1,
    fixedroots=[2],
    rfrac=1,
    printsol = True, 
    strfun=str_just_pol, 
    counter = 0,
    rootsRank = rootsRank,
    coefRank = coefRank,
    degree2 = 0)

P2 = "-kx + 1"

ejer3 += "\\item\[" + construir_a_trozos("f(x)",[P1[0],P2],[frontera])+"\]"

ejer3   +="\\end{itemize}"

Enunciado  +=ejer3  
Solucion += ejer3 +"\\text{Solucion:} k="+str(-(P1[0](frontera)-1)/frontera)

P3=genP(grado=3,
    fixedroots=[shared_root],
    rfrac=1,
    printsol = True, 
    strfun=str_just_pol, 
    counter = 0,
    rootsRank = rootsRank,
    coefRank = [-5,-1],
    degree2 = 1)

P4=genP(grado=2,
    fixedroots=[shared_root],
    rfrac=1,
    printsol = True, 
    strfun=str_just_pol, 
    counter = 0,
    rootsRank = rootsRank,
    coefRank = coefRank,
    degree2 = 0)

ejer4 = "\\paragraph{[2 puntos] 4) Halla el dominio de las siguientes funciones:}\\begin{itemize}"
ejer4 += "\\item \[f_1(x) = \\log{"+latex(P3[0])+"}\]"
ejer4 += "\\item \[f_2(x) = \\sqrt[3]{"+latex(P4[0])+"}\]"
ejer4 += "\\end{itemize}"

Enunciado+=ejer4
Solucion +=ejer4 + "\[\\text{D}(f_1) = \\mathbb{R}\]\[\\text{D}(f_2) = "+__getIntervalsFromIneq(P3[0]>0)+"\]"
