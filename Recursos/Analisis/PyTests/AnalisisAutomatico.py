
#Variables auxiliares necesarias
AV=[]
AH=[]
AO=[]
ptsCrit=[]
recta=[]
min=[]
max=[]

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
def ptsDiscontinuidad(f):
    hasLog=f(x).operator() == (log(x).operator())
    _den0=solve(f.denominator(normalize=False) == 0,x,solution_dict=True)
    den0 = [a[x] for a in _den0 if imag(a[x])==0]
    return den0

def _emptylist(aux):
    [aux.pop() for a in xrange(len(aux))]
    
## Funcion para calcular las asintotas verticales de la funcion.
#Input:
# f: funcion
# den: denominador de la funcion en caso de haberlo.
# boolean log: tieneLog 
# AV: array vacio para rellenar
def asintotesV(f,den,isLog,AV):
    _emptylist(AV)
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

    if (isLog == 1):
        _log0 = solve(exp(f)==0,x,solution_dict=True)
        log0 = [a[x] for a in _log0 if imag(a[x])==0]  

        if (Verbose == 1):
            r+= "\\paragraph{Atencion: } Como la funcion es un logaritmo, podriamos tener una asintota vertical (ya que $\\displaystyle\\lim_{x\\mapsto 0^+} \\log(x) = -\infty$). Vamos a comprobarlo.\\\\"

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
        r+= "\\paragraph{La funcion no tiene A.V.}"

    for x0 in den0:
        r+= "\\paragraph{Asintota en $x ="
        r+= latex(x0)+"$}"
        ld=limit(f(x),x=x0,dir="plus")
        li=limit(f(x),x=x0,dir="minus")
        if (Verbose==1): 
            r+="Calculamos"
        r+= "\[\\lim_{x\\mapsto " + latex(x0) + "} " + latex(f(x)) + " = \\left\\{\\begin{array}{l} \\displaystyle\\lim_{x\\mapsto " + latex(x0) + "^{+}} " + latex(f(x)) + " = " + latex(ld) + " \\\\\\\\\\displaystyle\\lim_{x\\mapsto " + latex(x0) + "^{-}} " + latex(f(x)) + " = " + latex(li) + " \\\\\\end{array}\\right.\] "
        if (abs(li) == Infinity and abs(ld) == Infinity and sign(li) == sign(ld)):
            r+= "\n La recta x =" + latex(x0) + " es una \\textbf{asintota vertical} de f(x)"
            AV.append(x0)
        elif (abs(li) == Infinity and abs(ld) == Infinity and sign(li) != sign(ld)):
            AV.append(x0)
            if (Verbose == 1):
                r+= "\n Aunque el limite no exista (porque los limites laterales son diferentes), su magnitud sigue siendo infinita por ambos lados, por lo que la recta x = $" + latex(x0) + "$ es una \\textbf{asintota vertical} de f(x)"
            else:
                r+= "\n $x = " + latex(x0) + "$ es \\textbf{A.V.} de f(x)"
        else:
            r+= "\n \\textbf{No hay asintota vertical} en $x="+latex(x0)+"$."
    AV=uniq(AV)
    return r


## Funcion para calcular las asintotas horizontales u oblicuas.
#Input:
# f: funcion

def asintotesHO(f,AH,AO):
    _emptylist(AH)
    _emptylist(AO)
    r=""
    for infty in [Infinity, -Infinity]:
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
def puntosEjeX(func):
    r=""
    __roots = solve(func(x)==0,x,solution_dict=True)
    _roots = [a[x] for a in __roots if imag(a[x])==0]
    for i in xrange(len(_roots)):
        r+="$x_"+str(i)+" = "+latex(_roots[i])+"\\to \\left("+latex(_roots[i])+",0\\right)$;\\quad"
    if (_roots == []):
        r += "No tiene solucion."
    if Verbose:
        r+= "\\\\\\textit{Obs: Solo puede haber puntos de corte en puntos del dominio.}"
    return r

def puntosEjeY(func):
    r=""
    if (func.denominator() in ZZ):
        r += "$" + latex(func(0)) +"$"
    else:
        if (func.denominator()(0) != 0):
            r += "$f(0) = " + latex(func(0)) + "$, con lo que la grafica corta en $\\left(0,"+latex(func(0)) + "\\right)$ al eje Y."   
        else:
            r +=  "No existe f(0)."    
    return r


############### Monotonia

# Funcion para calcular los puntos que anulan la derivada.
# Devuelve: cadena de texto con el codigo LaTeX.
# Recibe:
#   f: funcion
#   list sols: lista en la que escribir las soluciones (sobreescribe lo que tenga. Se recomienda pasar una lista vacia) 
#   boolean onlyReal: para calcular solo soluciones reales.

def solveDerivadaNula(f,sols,onlyReal):
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
    return retval


def ptsFrontera(f,ptscrit,recta):
    puntosFrontera = flatten([ptsDiscontinuidad(f=f),ptscrit])
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
    return r

# Construye una cadena de texto los intervalos formados por una lista de puntos frontera.
def intervalos(recta):
    r = ""
    for i in xrange(len(recta)-1):
        r += "$\\left("+latex(recta[i])+","+latex(recta[i+1])+"\\right)$;\\quad"  
    return r


# Estudia el signo de la funcion dada la funcion y los puntos frontera.
def estudiarSigno(f):
    recta=[-Infinity,Infinity]
    for a in _getRealroots(f):
        recta.append(a)
    for a in ptsDiscontinuidad(f=f):
        recta.append(a)
    recta=sorted(recta) 

    retval = "\\begin{itemize}"
    for i in xrange(len(recta)-1):
        rval=random_between(recta[i],recta[i+1])
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
    for _m in m:
    	retval += "x = " + latex(_m) + ";\\quad"
    return retval+"\\}"



def _getRealroots(f):
 __roots = solve(f==0,x,solution_dict=True)
 _roots = [a[x].full_simplify() for a in __roots if imag(a[x])==0]
 return _roots



### Estudia el signo de la funcion derivada, tanto para la curvatura, como para la monotonia.
# Devuelve codigo LaTeX
# Recibe:
# f: funcion
# min: lista
# max: lista
# boolean curvatura: false si buscamos estudiar la monotnia. True para estudiar curvatura.
def _f_sign_monot(recta,f,min,max,curvatura):
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
    for a in _getRealroots(ddf):
        recta.append(a)
    for a in ptsDiscontinuidad(f=df):
        recta.append(a)
    for a in ptsDiscontinuidad(f=f):
        recta.append(a)
    recta=sorted(recta) 
 else:
    for a in _getRealroots(df):
        recta.append(a)
    for a in ptsDiscontinuidad(f=f):
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
def _f_sign_monot_tabla(recta,f,min,max,curvatura):
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
    for a in _getRealroots(ddf):
        recta.append(a)
    for a in ptsDiscontinuidad(f=df):
        recta.append(a)
    for a in ptsDiscontinuidad(f=f):
        recta.append(a)
    recta=sorted(recta) 
 else:
    
    for a in _getRealroots(df):
        recta.append(a)
    
    for a in ptsDiscontinuidad(f=f):
        print("\t"+str(a))
        recta.append(a)
    
    
    recta=sorted(recta) 
    
 lista_intervalos = intervalos(recta)

 retval = "Los intervalos a estudiar son: "+latex(lista_intervalos)
 

 if curvatura:
    fun = "f''"
    g = ddf # La funcion a utilizar es la segunda derivada.
 else:
    fun = "f"
    g = df # La funcion a estudiar es la derivada.

 prev=0
 actual=0
 
 # Construimos la tabla, con tantas columnas como intervalos+1, para poner la funcion
 retval +="\\begin{table}\\centering\\begin{tabular}{"+"c"*(len(recta))+"}"
 # Construimos la primera fila de la tabla
 retval += latex(g)
 for interval in lista_intervalos:
    retval += "\& "+latex(interval)
 retval += "\\\\"
 
 # Construimos la segunda fila de la tabla:
 for i in xrange(len(recta)-1):
  rval=random_between(recta[i],recta[i+1])
  retval += "\&"+fun + "($"+latex(rval)+") = "+latex(round(g(rval),3)) +"$"
  if sign(g(rval)) == 1:
    retval += ">0\\rightarrow \\text{Convexa}"
  else:
    retval += "<0\\rightarrow \\text{Concava}"
  

  # Guardar en la lista los minimos.
  prev=actual
  actual=sign(g(rval))
  if prev!=actual and actual == 1:
    max.append(rval)
  if prev!=actual and actual == 0:
    min.append(rval)
 retval += "\\end{tabular}\\caption{Hola}\\end{table}"
 
 if not curvatura:

    retval += "Los puntos " 
    # Hay una funcion que lo hace
    retval += latex(max)
    retval += "son maximos de la funcion\\\\"
    retval += "Los puntos " 
    # Hay una funcion que lo hace
    retval += latex(min)
    retval += "son minimos de la funcion"
  
 return retval 

def estudiarSignoDiff(f):
 _retval = _f_sign_monot_tabla(recta,f,min,max,false)
 return _retval

def estudiarSignoSegundaDerivada(f):
 _retval = _f_sign_monot(recta,f,min,max,true)
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
 

## Devuelve los intervalos solucion de una inecuacion.
# tosolve: inecuacion a pasarle a solve direcamente. 
#   Ejemplo: x^2-9 >= 0
def __getIntervalsFromIneq(tosolve):
    return str(tosolve)

## Devuelve en texto el dominio de la funcion. 
# f: funcion
    
def dominion(f):
    hasLog=f(x).operator() == (log(x).operator())
    hasRt = f(x).operator() == (sqrt(x).operator())
    hasDen = f.denominator(normalize=False) == 1

    doms = ""
    denominator=f.denominator(normalize=False)
    intersect = 0
    if denominator != 1:
        s0=latex(denominator)
        s1=",".join(str(a[x]) for a in solve(f.denominator(normalize=False) == 0,x,solution_dict=True))
        doms += "\\{x\\in\\real \\tq "+s0+" \\neq 0 \\} = \\real \\setminus \{"+ s1 + "\}\n"
        intersect+=1
        
    if hasLog:
        if hasLog==1:
            base=e
        else:
            base=hasLog
        #Gnapa para arreglar
        argument=base^f(x)
        s0=latex(argument)
        print(argument)
        #s1=",".join(str(a[x]) for a in solve(argument>0,x,solution_dict=True))
        s1=__getIntervalsFromIneq(argument>0)
        if intersect > 0:
            doms += "\\cap"
        intersect+=1
        doms += "\\{x\\in\\real \\tq "+s0+" > 0 \\} = "+ s1 + "\n"


        
    if hasRt:
        #Gnapa para arreglar
        argument = f(x)^2
        s0=latex(argument)
        print(argument)
        #s1=",".join(str(a[x]) for a in solve(argument>=0,x,solution_dict=True))
        s1=__getIntervalsFromIneq(argument>=0)
        if intersect > 0:
            doms += "\\cap"
        intersect+=1

        doms += "\\{x\\in\\real \\tq "+s0+" > 0 \\} = "+ s1 + "\n"
        doms+=""  
              
    if doms == "":
        doms = "\\real"
        
    return "D(f) = " + doms

### Funcion para pintar las graficas.
# f: funcion
# int list AV: lista de puntos en los que hay una asintota vertical.
# int list AH: lista de puntos en los que hay una asintota horizontal.
# EXPR AO: ecuacion de la asintota oblicua y=mx+n
def _myplot(f,AV,AH,AO):
 
 discont=list(set(ptsDiscontinuidad(f=f)).difference(AV))
 xmin=-8
 xmax=8
 ymin=-10
 ymax=10
 c1=['blue','red','green','black','purple',colors]

 
 #Si no tiene denominador, gripa con el argumento de excluir denominadores
 pts_toexclude=[]
 if f.denominator(normalize=False) != 1:
    pts_toexclude = f.denominator()==0
 
 P=plot(f(x),xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax,figsize=6,plot_points=2500,legend_label="f(x)", axes_labels=['$x$','$y$'],exclude=pts_toexclude,color='green')
 
 j=0
 for i in xrange(len(AV)):
  lab="x="+str(AV[i])
  v=AV[i]
  P+=line([(v,ymin),(v,ymax)],legend_label=lab,color='blue',linestyle='-')
  j=i
 for i in xrange(len(AH)):
  lab="y="+str(AH[i])
  h=AH[i]
  P+=line([(xmin,h),(xmax,h)],legend_label=lab,color='red',linestyle='-')
 for i in xrange(len(discont)):
  x0=discont[i]
  ld=limit(f(x),x=x0,dir="plus")
  
  P+=circle((x0,ld),0.2,facecolor='white',fill=True)
 if AO != []:
  P+=plot(AO,color='purple',xmin=xmin,xmax=xmax,ymin=ymin,ymax=ymax)
 return P
