#coding: utf-8
from datetime import datetime
import logging

logging.basicConfig(filename='logs/'+str(datetime.now())+'.log',level=logging.DEBUG)
logging.debug('This message should go to the log file')
logging.info('So should this')
logging.warning('And this, too')

#Variables auxiliares necesarias
AV=[]
AH=[]
AO=[]
realSetDomainVar = RealSet(0,0)
ptsCrit=[]
recta=[]
min=[]
max=[]

epsilon = 0.0000001



# Definicion de las funciones

## Funcion para devolver un numero sencillo entre 2 valores, que pueden ser infinitos.
# Input: j,k los 2 valores.
def random_between(j,k):
 if ((j==-Infinity) and (k == Infinity)):
  return 0

 if (j==-Infinity):
  return int(k-2)

 if (k==Infinity):
  return int(j+2)

 if (j < 0 and k>0):
  return 0

 if (j < 1 and k>1):
  return 1


 if (k-j>=2):
  return int(random()*(k-j-1))+j+1
 else:
  return round((k+j)/2.0,2)

#Resuelve los puntos de discontinuidad de la funcion.
def ptsDiscontinuidad(f,intervalos_dominio):
    logging.info("log : funcion ptsDiscontinuidad: dominio: "+str(intervalos_dominio))
    retval = []
    for ip in list(intervalos_dominio.complement()):
        if ip.is_point():
            retval.append(ip.lower())
    logging.info("log : funcion ptsDiscontinuidad: valor de retorno: " + str(retval))
    return retval

def _emptylist(aux):
    [aux.pop() for a in xrange(len(aux))]
    
#### Sage dice que limit(log(x),x=0,dir="minus") = Infinity. Esta funcion corrige esto:
# funcion: la funcion
# v: valor
# lado: "+" o "-"

def limit_lateral(funcion,v,lado):


    if lado == "+":
        _dir="plus"
        _test_val = v+epsilon
    elif lado == "-":
        _dir="minus"
        _test_val = v-epsilon
    else:
        logging.info("Error grave")
        _dir="whaaaat"
    

    if imag(funcion(_test_val)) != 0:
        return None
    else:
        return limit(funcion(x),x=v,dir=_dir)


def getMinFromDomain(interval):
    if len(list(interval)) > 0:
        return interval[0].lower()
    else: 
        logging.info("Error:  funcion getMinFromDomain intentando conseguir el minimo de "+str(interval))
        return None

def getMaxFromDomain(interval):
    if len(list(interval)) > 0:
        return list(interval)[-1].upper()
    else: 
        logging.info("Error:  funcion getMinFromDomain intentando conseguir el minimo de "+str(interval))
        return None

def getExtremosDomain(interval):
    return flatten([[e.lower(),e.upper()] for e in list(interval)])


def solveDen0(f):
    if f.denominator(normalize=False) == 1:
        return "\\text{No tiene denominador, por lo que no hay puntos canditatos aqui.}"
    else:
        return "\\text{Por ello calculamos:  }" + latex(f.denominator(normalize=False)) +"= 0"


## Funcion para calcular las asintotas verticales de la funcion.
#Input:
# f: funcion
# den: denominador de la funcion en caso de haberlo.
# boolean log: tieneLog 
# AV: array vacio para rellenar
def asintotesV(f,den,AV,intervalos_dominio):
    logging.info("funcion asintotesV: asintotas recibidas: "+str(AV))
    _emptylist(AV)
    logging.info("funcion asintotesV: asintotas vaciadas: "+str(AV))
    den0 = ptsDiscontinuidad(f=f,intervalos_dominio=intervalos_dominio)

    r=""
    k=0

    if (Verbose == 1):
        r+= "Soluciones: "
        for i in den0:
            r+="$x_"+str(k)+"="+latex(i)+" $;\\quad"
            k+=1
        if (den0 == []):
            r+= "No tiene soluciones reales"


    argsLog = getArgsLog(f)
    hasLog = len(argsLog)


    if (hasLog > 0):
        _log0 = []
        
        for arg in argsLog:
            [_log0.append(a) for a in solve(arg == 0 , x , solution_dict=True)]
            if not arg.denominator().is_constant():
                [_log0.append(a) for a in solve(arg.denominator() == 0 , x , solution_dict=True)]                

        logging.info(_log0)
        log0 = [a[x] for a in _log0 if imag(a[x])==0]  

        if (Verbose == 1):
            r+= "\\paragraph{Atencion: } Como la funcion es un logaritmo, podriamos tener una asintota vertical (ya que $\\displaystyle\\lim_{x\\mapsto 0^+} \\log(x) = -\\infty$ y $\\displaystyle\\lim_{x\\mapsto\\infty}\\log(x) = \\infty$). Vamos a comprobarlo.\\\\"

            r+= "Para ello, calculamos los puntos en los que se haga 0 o $+\\infty$ el interior del logaritmo .\\\\"

        
            r+= "En este caso:"

        for arg in argsLog:
            r+= "\\[ "+latex(arg)+"= 0 \\]"

        r+= "Soluciones: "
        logging.info("funcion asintotesV: dominio: " + str(intervalos_dominio))
        NoCandidates=[]
        for i in log0:
            if (i+epsilon in intervalos_dominio) or (i-epsilon in intervalos_dominio):
                r+="$x_"+str(k)+"="+latex(i)+" $;\\quad"
                k+=1
            
                if not i in den0:
                    den0.append(i)
            else:   
                NoCandidates.append([k,i])
                r+="$x_"+str(k)+"="+latex(i)+" $;\\quad"                
            
        if (log0 == []):
            r+= "No tiene soluciones reales"
        elif len(NoCandidates) > 0:
            r+= "\\\\De estas soluciones, "
            for a in NoCandidates:
                r+="$x_"+str(a[0])+"="+latex(i)+" $;\\quad"                
            r+= "no son candidatos a asintota, puesto que ninguno de los 2 limites laterales existe."
            


    if (den0 == []):
        r+= "\\paragraph{La funcion no tiene A.V.}"

    for x0 in den0:
        r+= "\\paragraph{Asintota en $x ="
        r+= latex(x0)+"$}"

        ld = limit_lateral(f(x),x0,"+")
        li = limit_lateral(f(x),x0,"-")
        

        if (Verbose==1): 
            r+="Calculamos"
        r+= "\[\\lim_{x\\mapsto " + latex(x0) + "} " + latex(f(x)) + " = \\left\\{\\begin{array}{l} \\displaystyle\\lim_{x\\mapsto " + latex(x0) + "^{+}} " + latex(f(x)) + " = " + ___my_latex(ld) + " \\\\\\\\\\displaystyle\\lim_{x\\mapsto " + latex(x0) + "^{-}} " + latex(f(x)) + " = " + ___my_latex(li) + " \\\\\\end{array}\\right.\] "
        if ld != None and li != None:
            if (abs(li) == Infinity and abs(ld) == Infinity and sign(li) == sign(ld)):
                r+= "\n La recta x =" + latex(x0) + " es una \\textbf{asintota vertical} de f(x)"
                AV.append(x0)
            elif (abs(li) == Infinity and abs(ld) == Infinity and sign(li) != sign(ld)):
                AV.append(x0)
                if (Verbose == 1):
                    r+= "\n Aunque el limite no exista (porque los limites laterales son diferentes), su magnitud sigue siendo infinita por ambos lados, por lo que la recta x = $" + latex(x0) + "$ es una \\textbf{asintota vertical} de f(x)"
                else:
                    r+= "\n $x = " + latex(x0) + "$ es \\textbf{A.V.} de f(x)"
        elif ld == None and li == None:
            r+= "\n \\textbf{No hay asintota vertical} en $x="+latex(x0)+"$."
        elif ld == None:
            if (abs(li) == Infinity):
                r += "\n $x = " + latex(x0) + "$ es \\textbf{A.V.} de f(x) por la izquierda."
                AV.append(x0)
        elif li == None :
            if (abs(ld) == Infinity):
                r += "\n $x = " + latex(x0) + "$ es \\textbf{A.V.} de f(x) por la derecha."
                AV.append(x0)
        else:
            r+= "\n \\textbf{No hay asintota vertical} en $x="+latex(x0)+"$."
    AV=uniq(AV)
    logging.info("asintotesV: AV to ret: "+str(AV))
    return r

###Funcion para escribir latex de None como \nexists, para asegurar compatibilidad con la funcion limit_lateral.
def ___my_latex(value):
    if value==None:
        return "\\nexists"
    else:
        return latex(value)

## Funcion para calcular las asintotas horizontales u oblicuas.
#Input:
# f: funcion

def asintotesHO(f,AH,AO,intervalos_dominio):
    _emptylist(AH)
    _emptylist(AO)
    r=""
    ###Gnapa, que deberiamos arreglar:

    infsToCalcAsintotes = []

    if 9999999999 in intervalos_dominio:
        infsToCalcAsintotes.append(Infinity)
    else:
        r+= "\\paragraph{No existe el limite de la funcion en $\\infty$:}"

    if -9999999999 in intervalos_dominio:
        infsToCalcAsintotes.append(-Infinity)
    else:
        r+= "\\paragraph{No existe el limite de la funcion en $-\\infty$:}"

        
    if len(infsToCalcAsintotes) == 0:
        r+= "La funcion no puede tener asintotas horizontal por no estar definida en $\\pm\\infty$"
    
    for infty in infsToCalcAsintotes:
        if (Verbose == 1):
            r+= "\\paragraph{Limite de la funcion en $"+latex(infty)+"$:}"
        else:
            r+= "\\paragraph{$"+latex(infty)+"$:}"
        ld=limit(f, x=infty)  

        r+= "\[\\lim_{x\\mapsto "+latex(infty)+"}" + latex(f(x)) + "= ... = "+latex(ld)+"\]"    

        if (not (abs(ld) == Infinity)): # HORIZONTAL
            AH.append(ld)
            if (Verbose == 1):
                r+= "En $"+latex(infty)
                r+= "$ f(x) tiene una \\textbf{asintota horizontal} en $y = "+latex(ld)+"$."
            else:
                r+= "$y = "+latex(ld) +" $ es una \\textbf{A.H.} de f(x)"

        else: # OBLICUA
            if (Verbose == 1):
                r+= "Como el limite obtenido es de magnitud infinita la funcion no tiene asintota horizontal, pero puede tener una asintota oblicua. Para saber si tiene una asintota oblicua calculamos: "
            else:
                r+= "No tiene horizontal. Oblicua?"

            m=limit(f/x,x=infty)
            r+= "\[m=\\lim_{x\\mapsto "+latex(infty)+"} \\frac{f(x)}{x} = \\lim_{x\\mapsto "+latex(infty)+"} \\frac{"+latex(f(x))+"}{x}=\\lim_{x\\mapsto "+latex(infty)+"} "+latex(f(x)/x)+" = ... = "+latex(m)+"\]"
            if (abs(m) != Infinity and m != 0):
                if (Verbose == 1):
                    r+= "        En este caso tenemos m=$"+latex(m)+"$ por lo que si hay asintota oblicua. Calculamos n:"
                r+= "    \[n= \\lim_{x\\mapsto "+latex(infty)+"} f(x) - m·x = \\lim_{x\\mapsto "+latex(infty)+"}\\left("+latex(f(x))+"-"+latex(m)+"x \\right) = \\lim_{x\\mapsto "+latex(infty)+"}"+latex(f(x)-m*x)+" = "+ limit(f-m*x,x=infty)+"\]"
                _n = limit(f-m*x,x=infty)
                n=_n
                y=m*x+n
                r+= "En $"+latex(infty)+"$, f(x) tiene una \\textbf{asintota oblicua} en $y="+latex(y)+"$."
                AO.append(m*x+n)
            else:
                if (Verbose == 1):
                    r+= "En este caso, tenemos $m="+latex(m)+"$ por lo que \\textbf{no hay asintota} oblicua (ni horizontal)."
                else:
                    r+= "\\textbf{No hay A.O. ni A.H.}"
    AH=uniq(AH)
    AO=uniq(AO)
    return r

# Estudio de la simetria de la funcion.
def simetria(f):
    if (f(x) == f(-x)):
        if (Verbose == 1):
            return "Si, a f(x), entonces la funcion es par."
        else:
            return "Si, $\\Rightarrow$ par"
    elif (f(x) == - f(-x)):
        if (Verbose == 1):
            return "Si, a -f(x) entonces la funcion es impar."
        else:
            return "Si, $\\Rightarrow$ impar"
    else:
        if (Verbose == 1):
            return "No, entonces la funcion no tiene simetria respecto del eje Y."
        else:
            return "No, $\\Rightarrow$ ninguna simetria"

###### Estudio de los puntos de corte
def puntosEjeX(func,intervalos_dominio):
    r=""
    __roots = solve(func(x)==0,x,solution_dict=True,explicit_solutions=True)
    _roots = [a[x] for a in __roots if imag(a[x])==0]
    for i in xrange(len(_roots)):
        r+="$x_"+str(i)+" = "+latex(_roots[i])+"\\to \\left("+latex(_roots[i])+",0\\right)$;\\quad"
    if (_roots == []):
        r += "No tiene solucion."
    if Verbose:
        r+= "\\\\\\textit{Obs: Solo puede haber puntos de corte en puntos del dominio.}"
    return r

def puntosEjeY(func,intervalos_dominio):
    if 0 in intervalos_dominio:
        return "$f(0) = " + latex(func(0)) + "$, con lo que la grafica corta en $\\left(0,"+latex(func(0)) + "\\right)$ al eje Y."   
    else:
        return  "No existe f(0)."    
    


############### Monotonia

# Funcion para calcular los puntos que anulan la derivada.
# Devuelve: cadena de texto con el codigo LaTeX.
# Recibe:
#   f: funcion
#   list sols: lista en la que escribir las soluciones (sobreescribe lo que tenga. Se recomienda pasar una lista vacia) 
#   boolean onlyReal: para calcular solo soluciones reales.

def solveDerivadaNula(f,sols,onlyReal,intervalos_dominio):
    logging.info("solveDerivadaNula" +  str(f))
    _sols = solve(diff(f(x))==0,x,solution_dict=True,explicit_solutions=True)
    if onlyReal:
        sols = [a[x] for a in _sols if imag(a[x])==0]
    else: 
        sols=_sols



    logging.info("\t solveDerivadaNula de " + str(f))
    logging.info("\t solveDerivadaNula dominio " + str(intervalos_dominio))
        
    i=0
    retval=""
    NoCandidates = []
    for r in sols:
        logging.info("\t solveDerivadaNula r in sols: r= " + str(r))
        retval += "$x_"+str(i)+" = "+latex(r.full_simplify())+"$;\\quad"
        if not r in intervalos_dominio:
            logging.info("\t solveDerivadaNula: "+str(r)+" no del dominio")
            NoCandidates.append([i,r])
        i+=1
    
    if len(NoCandidates) > 0:
        retval += "\\\\De estas soluciones, "
        for a in NoCandidates:
            retval +="$x_"+str(a[0])+"="+latex(a[1].full_simplify())+" $;\\quad"
        
        retval += "no son validas porque no pertenecen al dominio."
    

    if (sols == []):
        retval += "No tiene soluciones reales."


    return retval


def ptsFrontera(f,ptscrit,recta,derivada_too,intervalos_dominio):
    logging.info("funcion ptsFrontera")
    puntosFrontera = flatten([flatten(ptsDiscontinuidad(f=f,intervalos_dominio=intervalos_dominio)),flatten(ptscrit)])
    if derivada_too:
        ___pts = ptsDiscontinuidad(f=diff(f(x),x,1),intervalos_dominio=intervalos_dominio)
        if ___pts != []:
            puntosFrontera.append(___pts)

    puntosFrontera = uniq(flatten(puntosFrontera))
    
    # En lugar de -infinity, hay que poner el extremo minimo del dominio.
    #recta=[-Infinity]
    
    recta = [getMinFromDomain(intervalos_dominio)]

    i=0
    r=""
    for p in puntosFrontera:
        r+= "$x_"+str(i)+"="+latex(p)+"$;\\quad"
        i+=1

    if len(puntosFrontera) == 0:
        r += " no hay."

    for p in puntosFrontera:
        recta.append(p)
    recta.append(getMaxFromDomain(intervalos_dominio))
    recta=sorted(uniq(recta))
    return r

# Construye una cadena de texto los intervalos formados por una lista de puntos frontera.
def intervalos(recta,domain = None):
    logging.info("funcion intervalos: intervalos de recta: "+str(recta))
    r = ""
    for i in xrange(len(recta)-1):
        if random_between(recta[i],recta[i+1]) in domain:
            r += "$\\left("+latex(recta[i])+","+latex(recta[i+1])+"\\right)$;\\quad"  
        else:
            logging.info("funcion intervalos: el intervalo (" + str(recta[i]) + "," + str(recta[i+1]) + ") no esta en el dominio.")
    return r


# Estudia el signo de la funcion dada la funcion y los puntos frontera.
def estudiarSigno(f,intervalos_dominio):
    logging.info("estudiarSigno")
    _min = getMinFromDomain(intervalos_dominio)
    _max = getMaxFromDomain(intervalos_dominio)
    recta = getExtremosDomain(intervalos_dominio)
    for a in _getRealroots(f):
        recta.append(a)
    for a in ptsDiscontinuidad(f=f,intervalos_dominio=intervalos_dominio):
        recta.append(a)
    recta=sorted(recta) 

    retval = "\\begin{itemize}"
    for i in xrange(len(recta)-1):
        rval = random_between(recta[i],recta[i+1])
        retval += "\\item $\\left("+latex(recta[i])+","+latex(recta[i+1])+"\\right)$:"
        if (Verbose == 1):
            retval += " Tomamos, por ejemplo, $f("+latex(rval)+") = "+latex(round(f(rval),3))+"...$  y miramos su signo:" 
        else:
            retval += "$f("+latex(rval)+") = "+latex(round(f(rval),3)) +"$"
        actual=sign(f(rval))
        if actual==1: 
            if (Verbose == 1):
                retval += "Positivo"  
            else:
                retval += "+"
        else:
            if (Verbose == 1):
                retval += "Negativo"
            else:
                retval += "-"

    retval += "\\end{itemize}"
    return retval

# Enumera una lista de valores entre llaves.
def printlist(m):
    retval = "\\{"
    for i in range(m):
    	retval += "x_" + str(i) +  " = " + latex(m[i]) + ";\\quad"
    return retval+"\\}"



def _getRealroots(f):
 logging.info("_getRealroots de " + str(f))
 __roots = solve(f==0,x,solution_dict=True)
 logging.info("\t soluciones: "+str(__roots))
 _roots = []
 for a in __roots:
    #logging.info("t estudiando "+str(a[x]))
    if (a[x]).has(x):
        logging.info("\t es expresion, calculamos solucion numerica..."+str(a) + " [x]-> "+str(a[x]))        
        sol = find_root(f,-Infinity,Infinity)
        logging.info("\t encontrada solucion: "+str(sol))
        _roots.append(sol)
    else:
        logging.info("\t no es expresion ")
        if imag(a[x]) == 0:
            _roots.append(a[x].full_simplify())
 logging.info("\t soluciones to return: " + str(_roots))
 return _roots



### Estudia el signo de la funcion derivada, tanto para la curvatura, como para la monotonia.
# Devuelve codigo LaTeX
# Recibe:
# f: funcion
# min: lista
# max: lista
# boolean curvatura: false si buscamos estudiar la monotnia. True para estudiar curvatura.
def _f_sign_monot(recta,f,min,max,curvatura,intervalos_dominio):
 _emptylist(min)
 _emptylist(max)
 df=diff(f,x,1)
 ddf = diff(df,x,1)

 recta=[-Infinity,Infinity]
 

 if curvatura:
    # Los puntos que marcan extremos de intervalos son:
    #       los valores que anulan la segunda derivada, 
    #       los puntos de discontinuidad de la derivada 
    #       los puntos de discontinuidad de la funcion.
    # MEJORAR: toda esta operacion puede ser una operacion de conjuntos. Interseccion dominio f con dominio df - puntos de f''(x) == 0.
    for a in _getRealroots(ddf):
        recta.append(a)
    for a in ptsDiscontinuidad(f=df,intervalos_dominio=intervalos_dominio):
        recta.append(a)
    for a in ptsDiscontinuidad(f=f,intervalos_dominio=intervalos_dominio):
        recta.append(a)
    recta=sorted(recta) 
 else:
    for a in _getRealroots(df):
        recta.append(a)
    for a in ptsDiscontinuidad(f=f,intervalos_dominio=intervalos_dominio):
        recta.append(a)
    recta=sorted(recta) 
 
 retval = "Los intervalos a estudiar son: "+latex(intervalos(recta))
 
 prev=0
 actual=0
 if curvatura:
    fun = "f''"
    g = ddf # La funcion a utilizar es la segunda derivada.
 else:
    fun = "f"
    g = df # La funcion a estudiar es la derivada.
 retval += "\\begin{itemize}"
 for i in xrange(len(recta)-1):
  rval=random_between(recta[i],recta[i+1])

  if not rval in intervalos_dominio:
    continue
  
  retval += "\\item $\\left("+latex(recta[i])+","+latex(recta[i+1])+"\\right)$:"
  if (Verbose == 1):
   retval += " Tomamos, por ejemplo, "+fun+"($"+latex(rval)+") = "+latex(round(g(rval),3))+"...$  y miramos su signo:" 
  else:
   retval += fun + "($"+latex(rval)+") = "+latex(round(g(rval),3)) +"$"
  prev=actual
  actual=sign(g(rval))
  if actual==1: 
   if (Verbose == 1):
    if curvatura:
        retval += "Positivo, por lo que la funcion es \\textbf{convexa} en este intervalo."
    else:
        retval += "Positivo, por lo que la funcion \\textbf{crece} en este intervalo."  
   else:
    if curvatura:
        retval += "Positivo, $\\Rightarrow$ \\textbf{convexa}."
    else:  
        retval += "Positivo $\\Rightarrow$ crece."
  else:
   if (Verbose == 1):
    if curvatura:
        retval += "Negativo, por lo que la funcion es \\textbf{concava} en este intervalo."
    else:
        retval += "Negativo, por lo que la funcion \\textbf{decrece} en este intervalo."
   else:

    if curvatura:
        retval += "Negativo, \\textbf{concava}."
    else:
        retval += "Negativo $\\Rightarrow$ decrece."


 
 return retval+"\\end{itemize}"
 



### Estudia el signo de la funcion derivada, tanto para la curvatura, como para la monotonia.
# Devuelve codigo LaTeX en modo tabla
# Recibe:
# f: funcion
# min: lista
# max: lista
# boolean curvatura: false si buscamos estudiar la monotnia. True para estudiar curvatura.
def _f_sign_monot_tabla(recta,f,min,max,curvatura,intervalos_dominio):

## IDEAS PARA MEJORAR. Poner los "&" al final, para poder poner \\hline entre las filas de las tablas.
## VER f_sign_monot sin tabla.
 _emptylist(min)
 _emptylist(max)
 df=diff(f,x,1)
 ddf = diff(df,x,1)


 recta = getExtremosDomain(intervalos_dominio)
  
 
 
 logging.info("_f_sign_monot_tabla: \n log:\t f:"+str(f) + "\n log:\t curvatura: "+str(curvatura) + "\n log: \t recta: "+str(recta)+"\n log: \t"+str(intervalos_dominio))
 
 if curvatura:
    # Los puntos que marcan extremos de intervalos son:
    #       los valores que anulan la segunda derivada, 
    #       los puntos de discontinuidad de la derivada 
    #       los puntos de discontinuidad de la funcion.
    for a in _getRealroots(ddf):
        if a in intervalos_dominio:
            recta.append(a)
    for a in ptsDiscontinuidad(f=df,intervalos_dominio=intervalos_dominio):
        recta.append(a)
    for a in ptsDiscontinuidad(f=f,intervalos_dominio=intervalos_dominio):
        recta.append(a)
 else:
    logging.info("\t solo monotonia" )
    __roots = _getRealroots(df) 
    logging.info("raices df: \t "+str(__roots))
    for a in __roots:
        if a in intervalos_dominio:
            recta.append(a)
    for a in ptsDiscontinuidad(f=f,intervalos_dominio=intervalos_dominio):
        recta.append(a)

 recta=sorted(uniq(recta))


 logging.info("_f_sign_monot_tabla: recta: "+str(recta))
 lista_intervalos = intervalos(recta,intervalos_dominio)

 if curvatura:
    fun = "f''"
    g = ddf # La funcion a utilizar es la segunda derivada.
 else:
    fun = "f'"
    g = df # La funcion a estudiar es la derivada.

 retval = "Los intervalos a estudiar son: "+latex(lista_intervalos)
 

 __label = "estudio" + str(random_between(1,1000000)) + str(random_between(1,1000000)) + str(random_between(1,1000000))
 retval += "Ver tabla \\ref{"+__label+"}, con el estudio de "+fun+"(x)"


 prev=0
 actual=1
 
 logging.info("_f_sign_monot_tabla: comenzamos a construir la tabla")
 # Construimos la tabla, con tantas columnas como intervalos+1, para poner la funcion

 
 intervalos_a_excluir = 0
 for i in xrange(len(recta)-1):
    if not random_between(recta[i],recta[i+1]) in intervalos_dominio:
        intervalos_a_excluir+=1

 retval +="\\newline\\begin{table}[h!]\\centering\\begin{tabular}{"+"c|"*(len(recta)-intervalos_a_excluir)+"}"
 # Construimos la primera fila de la tabla
 
 
 for i in xrange(len(recta)-1):
  if not random_between(recta[i],recta[i+1]) in intervalos_dominio:
        continue   
  retval += "& $\\left("+latex(recta[i])+","+latex(recta[i+1])+"\\right)$"

 retval += "\\\\ "
 
 conclusiones=[]
 # Construimos la segunda fila de la tabla:
 for i in xrange(len(recta)-1):
  logging.info("\t\t _f_sign_monot_tabla: estudiando intervalo: " + str([recta[i],recta[i+1]])) 
  rval=random_between(recta[i],recta[i+1])
  if not rval in intervalos_dominio:
    continue
  retval += "&"+fun + "($"+latex(rval)+") = "+latex(round(g(rval),3)) +"$"
  if sign(g(rval)) == 1:
    if curvatura:
        conclusiones.append("Convexa")
    else: 
        conclusiones.append("Creciente")
    retval += "$>0$"
  else:
    if curvatura:
        conclusiones.append("Concava")
    else:
        conclusiones.append("Decreciente")
    retval += "$<0$"
  

  # Guardar en la lista los minimos.
  toadd = recta[i]
  prev = actual
  actual = sign(g(rval))
  logging.info("\t\t _f_sign_monot_tabla - valor: "+str(rval))
  logging.info("\t\t _f_sign_monot_tabla - signo actual: "+str(actual))
  logging.info("\t\t _f_sign_monot_tabla - signo prev: "+str(prev))
  if not i == 0:
      if prev!=actual and actual == -1 and toadd in intervalos_dominio:
        max.append(toadd)
      if prev!=actual and actual == 1 and toadd in intervalos_dominio:
        min.append(toadd)

 retval += "\\\\"

 # Incluimos ultima fila de la tabla:
 for c in conclusiones:
    retval += "&" + c

 #Fin del bucle
 logging.info("\t\t _f_sign_monot_tabla: minlist: "+str(min))
 logging.info("\t\t _f_sign_monot_tabla: maxlist: "+str(max))

 retval += "\\end{tabular}\\caption{Estudio del signo de $" + fun + "(x)=" + latex(g.full_simplify()) + "$}\\label{"+__label+"}\\end{table}"
 
 if not curvatura:
    retval += "\\paragraph{Lista de maximos y minimos:} obtenidos estudiando la monotonia a ambos lados de cada puntos, siempre que el punto este en el dominio."
    if Verbose == 1:
        retval+="\\subparagraph{Criterio:} \\begin{itemize}\\item \\textit{Si por un lado crece, y por el otro decrece, entonces sera un minimo.}\\item \\textit{Si por un lado decrece, y por el otro crece, sera un maximo.}\\item \\textit{Si a ambos lados tiene el mismo comportamiento, no sera un maximo ni un minimo}\\end{itemize}"

    retval +="\\begin{itemize}"
    retval += "\\item"
    if max == []:
        retval += "La funcion no tiene ningun maximo."
    elif len(max) == 1:
        retval += "El punto $x=" + latex(max[0]) + "$ es un maximo de la funcion.\\\\" 
    else:
        retval += "Los puntos $" + printlist(max) + "$ son maximos de la funcion.\\\\" 
    retval += "\\item"
    if min == []:
        retval += "La funcion no tiene ningun minimo."
    elif len(min) == 1:
        retval += "El punto $x=" + latex(min[0]) + "$ es un minimo de la funcion.\\\\"
    else:
        retval += "Los puntos $" + printlist(min) + "$ son minimos de la funcion.\\\\"
    retval += "\\end{itemize}"  
 return retval 

def estudiarSignoDiff(f,intervalos_dominio):
 if Verbose == 1: #BUG
    _retval = _f_sign_monot_tabla(recta,f,min,max,false,intervalos_dominio)
 else:   
    _retval = _f_sign_monot_tabla(recta,f,min,max,false,intervalos_dominio)
 
 return _retval

def estudiarSignoSegundaDerivada(f,intervalos_dominio):
 if Verbose == 1:#BUG
    _retval = _f_sign_monot_tabla(recta,f,min,max,true,intervalos_dominio)
 else:   
    _retval = _f_sign_monot_tabla(recta,f,min,max,true,intervalos_dominio)
 
 return _retval


## Function str ismin(f,x0).
## f: second derivate of the function to study.
## x0: value to check if it is maximum.
## return 	string with the answer.
def ismin(f,x0):
 val = f(x0)
 retval = "f("+str(x0)+") = "+str(f(x0))
 if val<0:
  retval += "<0 por lo que hay un maximo relativo en "+str(x0)
 elif val>0:
  retval += ">0 por lo que hay un minimo relativo en "+str(x0)
 else:
  retval += "No podemos determinar si se trata de un maximo o un minimo de esta manera" 
 return retval
 

###### Devuelve los intervalos solucion de una inecuacion.
# Funcion auxiliar:

def __simpleInecToInterval(s):
    logging.info("__simpleInecToInterval de s: " + str(s))
    ineqOperators = {
        (x<3).operator():"<",
        (x>3).operator():">",
        (x<=3).operator():"<=",
        (x>=3).operator():">="
    }    
    left = s.lhs()
    right = s.rhs()
    operator = ineqOperators[s.operator()]

    logging.info("\t left,right,operator"+str(left)+","+str(right)+","+str(operator))
    if left.is_numeric() or left.is_infinity():
        logging.info("\t left: "+str(left))
        num = left
    elif right.is_numeric() or right.is_infinity():
        logging.info("\t right: "+str(right))
        num = right
    else:
        num = "Error grave"
        

    if operator == "<":
        return "(-\\infty,"+str(num)+")"
    elif operator == "<=":
        return "(-\\infty,"+str(num)+"]"
    elif operator == ">":
        return "("+str(num)+",\\infty)"
    elif operator == ">=":
        return "["+str(num)+",\\infty)"
    else:
        return "Error grave"        

# tosolve: inecuacion a pasarle a solve direcamente. 
#   Ejemplo: x^2-9 >= 0
def __getIntervalsFromIneq(tosolve,intervals):
    logging.info("__getIntervalsFromIneq")
    logging.info("\t tosolve: "+str(tosolve))
    logging.info("\t intervals: "+str(intervals))
    solutions = tosolve.solve(x)
    logging.info("\t solucions: "+str(solutions))

    __aux = []
    for i in solutions:
        if type(i) == type(x+1):
            logging.info("\t is expression")
            __aux.append(RealSet(i))
        elif type(i) == type([]):
            logging.info("\t"+str(i)+" is list")
            __aux.append(reduce(RealSet.intersection,[RealSet(a) for a in i]))
        else:
            logging.info("\t"+str(i)+" is not expression")
            __aux.append(RealSet(i[0]))

    logging.info("\t __aux - intervals: "+str(__aux))
    
    intervals.append(reduce(RealSet.union,__aux))
    logging.info("\t intervals: "+str(intervals))
    if len(solutions) > 1:
        openpar = "\\left"
        closepar = "\\right"
    else:
        openpar = ""
        closepar = ""



    logging.info("\t __aux - sols: "+str(__aux)) 
    __intervals__ = " \\cup ".join(map(str,__aux))
    return openpar + "("+ __intervals__ + closepar + ")"



## Funcion auxiliar recursiva para obtener todos los radicandos que tiene una funcion:
# f: funcion
# num: contador
def __hasRt_aux(f,num):
    retval = []
    if len(f.operands()) == 2 and (sage.symbolic.expression.is_Expression(f.operands()) == false ):
        if not f.operands()[1].is_integer() and f.operands()[1].is_numeric():
            retval.append(f.operands()[0])
            
    for _op in f.operands():
        l = __hasRt_aux(_op,num+1)
        if not l == []:
            retval.append(l)
    return retval

def getRadicandos(f):
    return flatten(__hasRt_aux(f,0))


## Funcion auxiliar recursiva para obtener todos los argumentos de los logaritmos que tenga la funcion
# f: funcion
# num: contador
def __hasLog_aux(f,num):
    retval = []
    if len(f.operands()) == 1 and f.operator() == (log(x).operator()):
        retval.append(f.operands()[0])
            
    for _op in f.operands():
        l = __hasLog_aux(_op,num+1)
        if not l == []:
            retval.append(l)
    return retval

def getArgsLog(f):
    return flatten(__hasLog_aux(f,0))



## Devuelve en texto el dominio de la funcion. 
# f: funcion
# realSetDomainArg: conjunto vacio en la que rellenar los valores del dominio.
def dominion(f,maketext,realSetDomainArg):
    # Limpiamos la variable para poder encadenar funciones.
     
    realSetDomainArg = realSetDomainArg.intersection(RealSet(0,0))
    intervalos_dominio = RealSet(0,0)
    logging.info("log (funcion dominion): funcion - "+str(f))


    
    argsLog = getArgsLog(f)
    hasLog = len(argsLog)
    isLog = hasLog
    ## Rutina para conocer si la funcion tiene alguna raiz:
    radicandos = getRadicandos(f)
    hasRt = len(radicandos)

    
    hasDen = f.denominator(normalize=False) == 1

    doms = ""
    denominator=f.denominator(normalize=False)
    intervals=[]
    intersect = 0
    if not denominator.is_constant():
        s0=latex(denominator)
        __solutions = [a[x] for a in solve(f.denominator(normalize=False) == 0,x,solution_dict=True,domain='real') if imag(a[x])==0]   
        s1=",".join([str(a) for a in __solutions ])
        doms += "\\{x\\in\\real \\tq "+s0+" \\neq 0 \\} = \\real - \{"+ s1 + "\}\n"
        
        for _s in __solutions:
            intervals.append(RealSet(-Infinity,_s)+RealSet(_s,Infinity))
        intersect+=1
        
    else:
        logging.info("log (funcion dominion): denominador de " + str(f) + " es constante")    

    
    if hasLog:
        if hasLog==1:
            base=e
        else:
            base=hasLog
        #Gnapa para arreglar

        f
        for argument in argsLog: 
            s0=latex(argument)
            
            if intersect > 0:
                doms += "\\cap"
            intersect+=1

            doms += "\\{x\\in\\real \\tq "+s0+" > 0 \\} "
            doms+=""  
        # Resolvemos inecuaciones
        doms+="} = {"

        _to_domain = [__getIntervalsFromIneq(argument>0,intervals) for argument in argsLog]
        doms += "\\cap".join(_to_domain)


        
    if hasRt:
        #Gnapa para arreglar
        for argument in radicandos: 
            s0=latex(argument)
            logging.info(argument)
            #s1=",".join(str(a[x]) for a in solve(argument>=0,x,solution_dict=True))
            
            if intersect > 0:
                doms += "\\cap"
            intersect+=1

            doms += "\\{x\\in\\real \\tq "+s0+" > 0 \\} "
            doms+=""  
        # Resolvemos inecuaciones
        doms+="} = {"
        _to_domain = [__getIntervalsFromIneq(argument>=0,intervals) for argument in radicandos]

        doms += "\\cap".join(_to_domain)
        
              
    if doms == "":
        doms = "\\real"
        
    logging.info("log (funcion dominion): FN: dominion\n\t Asignacion intervals=intervalos_dominio")
    logging.info("log (funcion dominion): intervals" + str(intervals))
    logging.info("log (funcion dominion): intervalos_dominio " + str(intervalos_dominio))
    if len(intervals) == 0:
        __dominio = RealSet(-oo,oo)
    else:
        __dominio = reduce(RealSet.intersection,intervals) 

    intervalos_dominio = intervalos_dominio.union(__dominio)
    logging.info("log (funcion dominion): dominio preseignacion" + str(__dominio ))
    realSetDomainArg = realSetDomainArg.union(intervalos_dominio)
    global realSetDomainVar
    realSetDomainVar = realSetDomainArg
    logging.info("log (funcion dominion) variable global"+str(realSetDomainArg))

    if maketext:
        return ("D(f) = {"+doms + "} = {" + str(__dominio).replace("+","\\cup").replace("oo","\\infty").replace("\\cup\\infty","+\\infty") + "}")
    else:
        return intervalos_dominio

### Funcion para pintar las graficas.
# f: funcion
# int list AV: lista de puntos en los que hay una asintota vertical.
# int list AH: lista de puntos en los que hay una asintota horizontal.
# EXPR AO: ecuacion de la asintota oblicua y=mx+n
def _myplot(f,AV,AH,AO,intervalos_dominio):
 logging.info("_myplot: f: " + str(f))
 logging.info("_myplot: AV: " + str(AV))
 logging.info("_myplot: AH: " + str(AH))
 discont=list(set(ptsDiscontinuidad(f=f,intervalos_dominio=intervalos_dominio)).difference(AV))
 
 xmin=-16
 xmax=16
 ymin=-20
 ymax=20
 
 c1=['blue','red','green','black','purple',colors]

 
 P=plot(f(x),xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax,figsize=6,plot_points=2500,legend_label="f(x)", axes_labels=['$x$','$y$'],exclude=discont,color='green')
 
 j=0
 for i in xrange(len(AV)):
  lab="x="+str(AV[i])
  v=AV[i]
  P+=line([(v,ymin),(v,ymax)],legend_label=lab,color='blue',linestyle='-',thickness=2)
  j=i
 for i in xrange(len(AH)):
  lab="y="+str(AH[i])
  h=AH[i]
  P+=line([(xmin,h),(xmax,h)],legend_label=lab,color='red',linestyle='-',thickness=2)
 for i in xrange(len(discont)):
  x0=discont[i]
  ld=limit(f(x),x=x0,dir="plus")
  
  P+=circle((x0,ld),0.2,facecolor='white',fill=True)
 AO=uniq(AO)
 if AO != []:
  for i in xrange(len(AO)):
   lab=str(AO[i])
   P+=plot(AO[i],color='purple',legend_label="y="+lab,xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax,thickness=2)
 return P
