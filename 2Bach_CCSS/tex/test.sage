var('x','y','z')
A = Matrix([[x - 1 ,1,0],[y - 1 ,1,1],[z - 1 ,1,2]])
print(A)
print(A.det())

B = Matrix([[2,-1,5],[1,-2,-4],[4,-5,-3]])
print(B.det())