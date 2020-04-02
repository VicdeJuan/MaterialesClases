# coding: utf-8

class FuncionAnalizable:
    f = None
    AV = None
    AH = None
    AO = None
    intervalos_dominio = None
    list_min = None
    list_max = None
    list_infexion = None
    argsLog = None
    argsRoot = None


    
    def setFun(self,fun=f):
    	self.f = f
    	pass
    

    ## Función auxiliar recursiva para obtener todos los radicandos que tiene una función:
    # f: función
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

    def setRadicandos(f):
        self.argsRoot = flatten(__hasRt_aux(self.f,0))


    ## Función auxiliar recursiva para obtener todos los argumentos de los logaritmos que tenga la función
    # f: función
    # num: contador
    @staticmethod
    def __hasLog_aux(f,num):
        retval = []
        if len(f.operands()) == 1 and f.operator() == (log(x).operator()):
            retval.append(f.operands()[0])
                
        for _op in f.operands():
            l = __hasLog_aux(_op,num+1)
            if not l == []:
                retval.append(l)
        return retval

    def setArgsLog(self):
        self.argsLog = flatten(FuncionAnalizable.__hasLog_aux(self.f,0))

    ## Devuelve en texto el dominio de la función. 
    # f: función
    # intervalos_dominio: conjunto vacío en la que rellenar los valores del dominio.    
    def dominio(self):

        self.intervalos_dominio = RealSet(0,0)
        print("log (funcion dominion): funcion - "+str(f))


        
        self.setArgsLog()
        hasLog = len(self.argsLog)
        isLog = hasLog
        ## Rutina para conocer si la función tiene alguna raíz:
        radicandos = self.setRadicandos()
        hasRt = len(self.argsRoot)

        
        hasDen = f.denominator() == 1

        doms = ""
        denominator=f.denominator()
        intervals=[]
        intersect = 0
        if not denominator.is_constant():
            s0=latex(denominator)
            __solutions = [a[x] for a in solve(f.denominator() == 0,x,solution_dict=True,domain='real') if imag(a[x])==0]   
            s1=",".join([str(a) for a in __solutions ])
            doms += "\\{x\\in\\real \\tq "+s0+" \\neq 0 \\} = \\real - \{"+ s1 + "\}\n"
            
            for _s in __solutions:
                intervals.append(RealSet(-Infinity,_s)+RealSet(_s,Infinity))
            intersect+=1
            
        else:
            print("log (funcion dominion): denominador de " + str(f) + " es constante")    

        
        if hasLog:
            if hasLog==1:
                base=e
            else:
                base=hasLog
            #Gnapa para arreglar

            f
            for argument in self.argsLog: 
                s0=latex(argument)
                
                if intersect > 0:
                    doms += "\\cap"
                intersect+=1

                doms += "\\{x\\in\\real \\tq "+s0+" > 0 \\} "
                doms+=""  
            # Resolvemos inecuaciones
            doms+="} = {"

            _to_domain = [__getIntervalsFromIneq(argument>0,intervals) for argument in self.argsLog]
            doms += "\\cap".join(_to_domain)


            
        if hasRt:
            #Gnapa para arreglar
            for argument in radicandos: 
                s0=latex(argument)
                print(argument)
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
            
        print("log (funcion dominion): FN: dominion\n\t Asignacion intervals=intervalos_dominio")
        print("log (funcion dominion): intervals" + str(intervals))
        print("log (funcion dominion): intervalos_dominio " + str(self.intervalos_dominio))
        if len(intervals) == 0:
            __dominio = RealSet(-oo,oo)
        else:
            __dominio = reduce(RealSet.intersection,intervals) 

        self.intervalos_dominio = self.intervalos_dominio.union(__dominio)
        print("log (funcion dominion): dominio preseignacion" + str(__dominio ))
        print("log (funcion dominion): dominio posteignacion" + str(self.intervalos_dominio))
        
        print("log (funcion dominion) variable global"+str(self.intervalos_dominio))
        
        
        return "D(f) = {"+doms + "} = {" + str(__dominio).replace("oo","\\infty").replace("+","\\cup") + "}"
    # Fin dominion

    pass


var('x')
f = FuncionAnalizable()
f.setFun(fun = log(x))
f.dominio()
