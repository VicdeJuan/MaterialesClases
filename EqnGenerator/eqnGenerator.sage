import re
var('x')
def _latex(ss):
    s=str(ss)
    for gs in map(list,re.findall("([0-9]+)/([0-9]+)",s)):
        s=re.sub(gs[0]+"/"+gs[1],"\\\\frac{"+gs[0]+"}{"+gs[1]+"}",s)
    s=s.replace("*","")
    return s    
    
def str_eqn(s,funstr):
    return funstr(s)
        
def eqn_generator(sumandos,iteraciones,solucion,max,lat,numeq,print_sol,numop):
    eqns = []
    for i in xrange(sumandos):
        eqn = x==solucion
        for j in xrange(iteraciones):
            op = int(uniform(1,numop+1))
            if op==1:
                if uniform(1,3) > 2:
                    eqn += int(uniform(2,max))*x
                else:
                    eqn += int(uniform(1,max))
            if op==2:
                if uniform(1,3) > 2:
                    eqn -= int(uniform(2,max))*x
                else:
                    eqn -= int(uniform(1,max))
            if op==3:
                eqn *= int(uniform(2,6))
            if op==4:
                eqn /= int(uniform(2,max))

        eqns.append(eqn)
    if lat:
        left = "+".join([str_eqn(eqn.left(),_latex) for eqn in eqns])
        right= "+".join([str_eqn(eqn.right(),_latex) for eqn in eqns])
    else:
        left = "+".join([str_eqn(eqn.left(),str) for eqn in eqns])
        right= "+".join([str_eqn(eqn.right(),str) for eqn in eqns])
    retval = (left+"="*numeq+right).replace("+-","-")
    if lat:
        retval = "\\["+retval+"\\]"
        if print_sol:
            retval = "Sol: " + str(solucion) + ":" + retval
    return retval

 
for i in xrange(30):
    sol=i-10
    print(eqn_generator(sumandos = 3, iteraciones = 8,solucion = sol, max = 10 ,lat = True, numeq = 1,print_sol = True,numop=4))
    print 
    print
