#============================================================================
# PURPOSE : Dealing with two dimensional arrays
#============================================================================
import numpy as np
#----------------------------------------------------------------------------
#                         Creating a 2D array
#----------------------------------------------------------------------------

print("---------------------------- 1")
a=np.array([(2,5,9,8),(-8,-6,3,0),(7,6,2,7)]) # Array of tuples
b=np.array([[2,5,9,8],[-8,-6,3,0],[7,6,2,7]]) # Array of Lists
c=np.array([[2,5,9,8],[-8,-6,3,0],(7,6,2,7)]) # Array of mixture
print(a,"\n")
print(b,"\n")
print(c,"\n")

#----------------------------------------------------------------------------
#            Accessing element at index (2,1)
#----------------------------------------------------------------------------
print("---------------------------- 2")
b=a[2,1] 
print("element at index (2,1) is ... ",b,"\n")

#----------------------------------------------------------------------------
#               Changing the element at position (2,1)
#----------------------------------------------------------------------------
print("---------------------------- 3")
a[2,1]=800 
print("Changed array is ...",a)

#----------------------------------------------------------------------------
#  Calculating total number of elements (size) and dimensions (Shape) of 'a'
#----------------------------------------------------------------------------
print("---------------------------- 4")
c=np.size(a)
print("The size of array is ... ",c,"\nCalculated by another formula ...",a.size)
d=np.shape(a) 
print("The shape of array a is ",d,"\nCalculated by another formula ...",a.shape)

#----------------------------------------------------------------------------
#    Creating array of all zeros/Ones of predefined size (say 3x4)
#----------------------------------------------------------------------------
print("---------------------------- 5")
d=np.zeros((3,4)) # OR d=np.zeros([3,4])
print(d,"\n")
d=np.ones((3,4)) 
print(d,"\n")

#----------------------------------------------------------------------------
#       Accessing elements of array in arbitrary order/Replacement
#----------------------------------------------------------------------------
print("---------------------------- 6")
a=np.linspace(1,12,12).reshape(3,4)
print('array a is : ',a,"\n")
# Access elements with index (0,0) & (0,2) & (1,2) & (2,1)
b=a[[0,0,1,2],[0,2,2,1]]
print(b,"\n")
a[np.array([0,0,1,2]),np.array([0,2,2,1])]=100 # For replacing elements by single number 
print(a,"\n")
a[np.array([0,0,1,2]),np.array([0,2,2,1])]=np.array([300,400,500,600])
# for replacing by different numbers
print(a,"\n")

#----------------------------------------------------------------------------
#                Concatenating two arrays
#----------------------------------------------------------------------------
print("---------------------------- 7")
a=np.array([(1,2),(5,6)])
print(a,"\n")
b=np.array([(2.3),(-9.4)])
print(b,"\n")
c=np.vstack((a,b)); # Vertical concatenation
# horizontal is not possible here because of dimension mismatch
# (otherwise use np.hstack)
print(c,"\n")

#----------------------------------------------------------------------------
#             Deleting specific row/column from array
#----------------------------------------------------------------------------
print("---------------------------- 8")
a=np.array([(2,5,9,8),(-8,-6,3,0),(7,6,22,7)]);
print(a,"\n")
a=np.delete(a,2,1) # Last argument is for direction.
# Direction 0=rows, direction 1=columns.
# middle argument is the index of element along that direction
# here 2nd (starting from 0) column will be deleted
print(a,"\n")

#-----------------------------------------------------------------------
#             Obtaining the dimensionality of array
#-----------------------------------------------------------------------
print("---------------------------- 9")
a=np.array([(2,5,9,8),(-8,-6,3,0),(7,6,22,7)]);
print(a)
print(a.ndim)

#-----------------------------------------------------------------------
#                  Obtaining type
#-----------------------------------------------------------------------
print("---------------------------- 10")
a=np.array([(2,5,9,8),(-8,-6,3,0),(7,6,22,7)]);
print(a)
print(a.dtype)
print(type(a))

#-----------------------------------------------------------------------
#            Acessing elements of 2D array in sequence
#-----------------------------------------------------------------------
print("---------------------------- 11")
a=np.array([(2,5,9,8,3,4,5),(-8,-6,3,0,4,5,6),(7,6,22,7,5,6,7),(6,7,8,100,200,300,400)]);
print(a)
# Elements from alternate rows and columns
print(a[0::2,0::2])
# Elements from alternate rows and columns with gap of 3
#but index range (0 to 4, 5 excluded)
print(a[0::2,0:5:3])

print("Completed Successfully")







