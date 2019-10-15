#!/usr/bin/ython

import sys

if len(sys.argv) != 5:
    print "Usage: "+sys.argv[0]+" n p k op\n"
    print "     n: lanzamientos"
    print "     p: probabilidad"
    print "     k: valor a calcular"
    print "     op: =|<|>|>=|<="
    sys.exit(4)

n=int(sys.argv[1])
_arr_p = sys.argv[2].split("/")
if len (_arr_p) == 1:
    p = float(_arr_p)
elif len(_arr_p) == 2:
    p = float(_arr_p[0])*1.0/float(_arr_p[1])
k=int(sys.argv[3])

op=sys.argv[4]

def fact(n):
    if n<1:
        return 1
    else:
        return n*fact(n-1)

def comb(m,n):
    return fact(n)/(fact(n-m)*fact(m))

def binom(n,p,k):
    return comb(k,n)*(p**k)*((1-p)**(n-k))

n=30
p=1.0/3
a=0

if op == "<":
    for i in range(k):
        a+=binom(n,p,i)
elif op == "<=":
    for i in range(k+1):
        a+=binom(n,p,i)
elif op == "=":
    a=binom(n,p,k)

else:
    print "not yet"

print a
