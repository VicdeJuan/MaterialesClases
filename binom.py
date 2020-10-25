#!/usr/bin/ython

import sys
from decimal import *


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
    p = Decimal(_arr_p[0])
elif len(_arr_p) == 2:
    p = Decimal(_arr_p[0])*1.0/Decimal(_arr_p[1])
k=int(sys.argv[3])

op=sys.argv[4]

def fact(n):
	m=Decimal(1)
	for i in range(1,n+1):
		m = m*i
	return m



def comb(m,n):
    return fact(n)/(fact(n-m)*fact(m))

def binom(n,p,k):
    return comb(k,n)*(p**k)*((1-p)**(n-k))

a=Decimal(0)

if op == "<":
    for i in range(k):
        a+=binom(n,p,i)
elif op == "<=":
    for i in range(k+1):
        a+=binom(n,p,i)
elif op == "=":
    a=binom(n,p,k)

elif op == ">":
	for i in range(k+1):
		a+=binom(n,p,i)
	a = 1-a
elif op == ">=":
	for i in range(k):
		a+=binom(n,p,i)
	a = 1-a
else:
	print "not yet"

print a
