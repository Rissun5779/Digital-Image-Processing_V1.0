#======================================================================
# PURPOSE : Array Operations
#======================================================================
import numpy as np

#---------------------------------------------------------------------
#                  Creating some 2D arrays for use
#---------------------------------------------------------------------
print("---------------------------- 1")
a=np.array([(2,5,9,8),(-8,-6,3,0),(7,6,2,7)]); 
b=np.random.randint(2,15,(3,4)); # (low,high,size).
#creates random integers in low to high range for specified size
print('array a is ...',a,"\n")
print('array b is ...',b,"\n")

#---------------------------------------------------------------------
#               Element by element operations
#---------------------------------------------------------------------
print("---------------------------- 2")
c=a+b;
print('addition of a and b is ... \n',c,"\n")
c=a-b;
print('subtraction of a and b is ... \n',c,"\n")
c=a*b;
print('element by element multiplication of a and b is ... \n',c,"\n")
c=a/b;
print('element by element division of a and b is ... \n',c,"\n")
c=a%b;
print('element by element remainder of a and b is ... \n',c,"\n")
c=a**b;
print('element by element power of a and b is ... \n',c,"\n")

#---------------------------------------------------------------------
#                Mathematical operations
#---------------------------------------------------------------------
print("---------------------------- 3")
a=np.array([(1,2),(9,3)])
b=np.array([[2],[3]])
c=np.matmul(a,b)   # Mathematical multiplication
print('Mathematical multiplication of a and b is ... \n',c,"\n")

#---------------------------------------------------------------------
#        Identifying Elements based on special conditions
#---------------------------------------------------------------------
print("---------------------------- 4")
a=np.array([[1,4,6],[2,1,4],[0,4,5]])
print("The required array is ...\n",a>3,"\n")
print("The corresponding elements in array are ... \n",a*(a>3),"\n")

#---------------------------------------------------------------------
#      WHERE command (Gives the indices of the required condition)
#---------------------------------------------------------------------
print("---------------------------- 5")
a=np.random.randint(3,20,(3,5)) # random array of size 3x5 with elements lying between 3,20 is created
print(a,"\n")
b=np.where((a<10)|(a>14))   # this is returned as tuple. 
# Brackets around individual conditions above are absolutely necessary
b1=np.asarray(b,"\n")       # tuple to numpy array conversion (abbrevation : As array)
print(b,"\n")               # output as tuple
print(b1,"\n")              # output as numpy array
print('And those values are ...',a[b],"\n") # here b1 wont work

print("Completed Successfully ... ")














