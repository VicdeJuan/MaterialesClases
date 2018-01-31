

facts = ["(x-2)","(x-3)","(x+5)"]

def val(x): return -float(x[2:][0:-1]) 

roots = map(val,facts)
list.sort(roots)

texto = "\\begin{array}{"+"c"*(len(facts)+2)+"}\n"
texto += "&(-\\infty,"+str(roots[0])+")&"
for i in xrange(0,len(facts)-1):
	texto += "("+str(roots[i])+","+str(roots[i+1])+")&"
texto += "("+str(roots[-1])+",\\infty)\\\n"
for x in facts:
	texto += x +"&"*(len(facts)+2) +"\\\\\n"


texto += "\\end{array}"
print texto 
	
