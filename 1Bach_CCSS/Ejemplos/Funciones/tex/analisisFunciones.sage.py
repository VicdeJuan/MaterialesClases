
# Definición de las funciones
Verbose=1

## Función para devolver un número sencillo entre 2 valores, que pueden ser infinitos.
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

#Resuelve los puntos de discontinuidad de la función.
def ptsDiscontinuidad(f,tieneLog):
    _den0=solve(f.denominator(normalize=False) == 0,x,solution_dict=True)
    den0 = [a[x] for a in _den0 if imag(a[x])==0]
    return den0

## Función para calcular las asíntotas verticales de la función.
#Input:
# f: función
# den: denominador de la función en caso de haberlo.
# boolean log: tieneLog 
def asintotesV(f,den,log):
    
    _den0=solve(f.denominator(normalize=False) == 0,x,solution_dict=True)
    den0 = [a[x] for a in _den0 if imag(a[x])==0]

    r=""
    k=0

    if (Verbose == 1):
        r+= "Soluciones: "
        for i in den0:
            r+="$x_"+str(k)+"="+latex(i)+" $;\\quad"
            k+=1
        if (den0 == []):
            r+= "No tiene soluciones reales"

    if (TieneLog == 1):
        _log0 = solve(exp(f)==0,x,solution_dict=True)
        log0 = [a[x] for a in _log0 if imag(a[x])==0]  

        if (Verbose == 1):
            r+= "\\paragraph{Atención: } Como la función es un logaritmo, podríamos tener una asíntota vertical (ya que $\\displaystyle\\lim_{x\\mapsto 0^+} \\log(x) = -\infty$). Vamos a comprobarlo.\\\\"

            r+= "Para ello, calculamos los puntos en los que se haga 0 el interior del logaritmo .\\\\"

        
            r+= "En este caso:"
        r+= "\\[ "+latex(exp(f))+"= 0 \\]"

        r+= "Soluciones: "
        for i in log0:
            r+="$x_"+str(k)+"="+latex(i)+" $;\\quad"
            k+=1
            den0.append(i)
        if (log0 == []):
            r+= "No tiene soluciones reales"

    if (den0 == []):
        r+= "\\paragraph{La función no tiene A.V.}"

    for x0 in den0:
        r+= "\\paragraph{Asintota en $x ="
        r+= latex(x0)+"$}"
        ld=limit(f,x=x0,dir="plus")
        li=limit(f,x=x0,dir="minus")
        if (Verbose==1): 
            r+="Calculamos"
        r+= "\[\\lim_{x\\mapsto " + latex(x0) + "} " + latex(f(x)) + " = \\left\\{\\begin{array}{cc}\\text{Por la derecha: } &" + latex(ld) + " \\\\ \\text{Por la izquierda: } & " + latex(li) + "\\end{array}\\right.\] "
        if (abs(li) == Infinity and abs(ld) == Infinity and sign(li) == sign(ld)):
            r+= "\n La recta x =" + latex(x0) + " es una \\textbf{asíntota vertical} de f(x)"
        elif (abs(li) == Infinity and abs(ld) == Infinity and sign(li) != sign(ld)):
            if (Verbose == 1):
                r+= "\n Aunque el límite no exista (porque los límites laterales son diferentes), su magnitud sigue siendo infinita por ambos lados, por lo que la recta x = $" + latex(x0) + "$ es una \\textbf{asíntota vertical} de f(x)"
            else:
                r+= "\n $x = " + latex(x0) + "$ es \\textbf{A.V.} de f(x)"
        else:
            r+= "\n \\textbf{No hay asíntota vertical} en $x="+latex(x0)+"$."
    return r


## Función para calcular las asíntotas horizontales u oblicuas.
#Input:
# f: función

def asintotesHO(f):
    r=""
    for infty in [Infinity, -Infinity]:
        if (Verbose == 1):
            r+= "\\paragraph{Límite de la función en $"+latex(infty)+"$:}"
        else:
            r+= "\\paragraph{$"+latex(infty)+"$:}"
        ld=limit(f, x=infty)  

        r+= "\[\\lim_{x\\mapsto "+latex(infty)+"}" + latex(f(x)) + "= ... = "+latex(ld)+"\]"    

        if (not (abs(ld) == Infinity)): # HORIZONTAL
            if (Verbose == 1):
                r+= "En $"+latex(infty)
                r+= "$ f(x) tiene una \\textbf{asíntota horizontal} en $y = "+latex(ld)+"$."
            else:
                r+= "$y = "+latex(ld) +" $ es una \textbf{A.H.} de f(x)"

        else: # OBLICUA
            if (Verbose == 1):
                r+= "Como el límite obtenido es de magnitud infinita la función no tiene asíntota horizontal, pero puede tener una asíntota oblícua. Para saber si tiene una asíntota oblícua calculamos: "
            else:
                r+= "No tiene horizontal. ¿Oblícua?"

            m=limit(f/x,x=infty)
            r+= "\[m=\\lim_{x\\mapsto "+latex(infty)+"} \\frac{f(x)}{x} = \\lim_{x\\mapsto "+latex(infty)+"} \\frac{"+latex(f(x))+"}{x}=\\lim_{x\\mapsto "+latex(infty)+"} "+latex(f(x)/x)+" = ... = "+latex(m)+"\]"
            if (abs(m) != Infinity):
                if (Verbose == 1):
                    r+= "        En este caso tenemos m=$"+latex(m)+"$ por lo que sí hay asíntota oblícua. Calculamos n:"
                r+= "    \[n= \\lim_{x\\mapsto "+latex(infty)+"} f(x) - m·x = \\lim_{x\\mapsto "+latex(infty)+"}\\left("+latex(f(x))+"-"+latex(m)+"x \\right) = \\lim_{x\\mapsto "+latex(infty)+"}"+latex(f(x)-m*x)+" = "+ limit(f-m*x,x=infty)+"\]"
                _n = limit(f-m*x,x=infty)
                n=_n
                y=m*x+n
                r+= "En $"+latex(infty)+"$, f(x) tiene una \\textbf{asíntota oblícua} en $y="+latex(y)+"$."
            else:
                if (Verbose == 1):
                    r+= "En este caso, ese límite tenemos $m="+latex(m)+"$ por lo que \\textbf{no hay asíntota} oblícua (ni horizontal)."
                else:
                    r+= "\\textbf{No hay A.O. ni A.H.}"
    return r

# Estudio de la simetría de la función.
def simetria(f):
    if (f(x) == f(-x)):
        if (Verbose == 1):
            return "Sí, a f(x), entonces la función es par."
        else:
            return "Sí, $\\Rightarrow$ par"
    elif (f(x) == - f(-x)):
        if (Verbose == 1):
            return "Sí, a -f(x) entonces la función es impar."
        else:
            return "Sí, $\\Rightarrow$ impar"
    else:
        if (Verbose == 1):
            return "No, entonces la función no tiene simetría respecto del eje Y."
        else:
            return "No, $\\Rightarrow$ ninguna simetría"

###### Estudio de los puntos de corte
def puntosEjeX(f):
    r=""
    __roots = solve(f(x)==0,x,solution_dict=True)
    _roots = [a[x] for a in __roots if imag(a[x])==0]
    for i in xrange(len(_roots)):
        r+="$x_"+str(i)+" = "+latex(_roots[i])+"\\to \\left("+latex(_roots[i])+",0\\right)$;\\quad"
    if (_roots == []):
        r += "No tiene solución."
    return r

def puntosEjeY(f):
    r=""
    if (f.denominator() in ZZ):
        r += "$" + latex(f(0)) +"$"
    else:
        if (f.denominator()(0) != 0):
            r += "$f(0) = " + latex(f(0)) + "$, con lo que la gráfica corta en $\\left(0,"+latex(f(0)) + "\\right)$ al eje Y."   
        else:
            r +=  "No existe f(0)."    
    return r


############### Monotonía


# Función para calcular los puntos que anulan la derivada.
# Recibe:
# f: función
# boolean onlyReal: para calcular sólo soluciones reales.
def solveDerivadaNula(f,onlyReal):
    _sols = solve(diff(f(x))==0,x,solution_dict=True)
    if onlyReal:
        sols = [a[x] for a in _sols if imag(a[x])==0]
    else: 
        sols=_sols

    i=0
    retval=""
    for r in sols:
        retval += "$x_"+str(i)+" = "+latex(r.full_simplify())+"$;\\quad"
        i+=1
    if (sols == []):
        retval += "No tiene soluciones reales."
    return [ptscrit,retval]


def ptsFrontera(f,ptscrit,den0):
    puntosFrontera = flatten([den0,ptscrit])
    recta=[-Infinity]

    i=0
    r=""
    for p in puntosFrontera:
        r+= "$x_"+str(i)+"="+latex(p)+"$;\\quad"
        i+=1

    for p in puntosFrontera:
        recta.append(p)
    recta.append(+Infinity)
    recta=sorted(recta)
    return [recta,r]

# Construye una cadena de texto los intervalos formados por una lista de puntos frontera.
def intervalos(recta):
    r = ""
    for i in xrange(len(recta)-1):
        r += "$\\left("+latex(recta[i])+","+latex(recta[i+1])+"\\right)$;\\quad"  
    return r

# Estudia el signo de la función dada la función y los puntos frontera.
def diffsign(f,recta):
    max=[]
    min=[]
    g=diff(f,x,1)
    prev=0
    actual=0
    retval = "\\begin{itemize}"
    for i in xrange(len(recta)-1):
        rval=random_between(recta[i],recta[i+1])
        retval += "\\item $\\left("+latex(recta[i])+","+latex(recta[i+1])+"\\right)$:"
        if (Verbose == 1):
            retval += " Tomamos, por ejemplo, f'($"+latex(rval)+") = "+latex(round(g(rval),3))+"...$  y miramos su signo:" 
        else:
            retval += "f'($"+latex(rval)+") = "+latex(round(g(rval),3)) +"$"
        prev=actual
        actual=sign(g(rval))
        if actual==1: 
            if (Verbose == 1):
                retval += "Positivo, por lo que la función \\textbf{crece} en este intervalo"  
            else:
                retval += "Positivo $\\Rightarrow$ crece"
        else:
            if (Verbose == 1):
                retval += "Negativo, por lo que la función \\textbf{decrece} en este intervalo"
            else:
                retval += "Negativo $\\Rightarrow$ decrece"

        if (prev == -1 and actual == 1):
            min.append(recta[i])
        if (prev == 1 and actual == -1):
            max.append(recta[i])
    retval += "\\end{itemize}"
    return [max,min,retval]

# Enumera una lista de valores entre llaves.
def printlist(m):
    retval = "\\{"
    for _m in m:
    	retval += "x = " + latex(_m) + ";\\quad"
    return retval+"\\}"

