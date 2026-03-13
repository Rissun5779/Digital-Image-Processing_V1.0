#======================================================================
# PURPOSE : Dealing with one dimensional array
#======================================================================

import numpy as np; # importing the python array object 'numpy' by name 'np'.

#-----------------------------------------------------------------------
#            Creating 1D array
#-----------------------------------------------------------------------
print("---------------------------- 1")
a=np.array([2,8,63,-9,3.2])
print(a)
print("The shape of array",a,"is",a.shape)

#-----------------------------------------------------------------------
# Accessing 2nd element (Remember that in Python, indexing starts from 0)
#-----------------------------------------------------------------------
print("---------------------------- 2")
b=a[1] 
print(b)

#-----------------------------------------------------------------------
#          Changing the 2nd element i.e (element at index 1)
#-----------------------------------------------------------------------
print("---------------------------- 3")
a[1]=800
print(a)

#-----------------------------------------------------------------------
#                 Calculating the length of 'a'
#-----------------------------------------------------------------------
print("---------------------------- 4")
c=len(a)
print("Length of a is ... ",c)

#-----------------------------------------------------------------------
#               Accessing the last element of array
#-----------------------------------------------------------------------
print("---------------------------- 5")
# (Notice that indexing starts from -1 in reverse direction.
print("The last element is ... ", a[-1])
print('The second last element is ...',a[-2])

#-----------------------------------------------------------------------
#  Creating array from one number to another with a GAP using arange
#-----------------------------------------------------------------------
print("---------------------------- 6")
# (Remember the syntax is (START,END+GAP,GAP)
d=np.arange(2,10,1) # numbers from 2 to 9 (NOT 10) with a gap of 1.
print(d)
d=np.arange(2,10,3) # numbers from 2 to 9 (NOT 10) with a gap of 3.
print(d)
d=np.arange(-2.3,1.3,.5) 
print(d)

#-----------------------------------------------------------------------
#          Creating numbers from START to END using linspace
#-----------------------------------------------------------------------
print("---------------------------- 7")
d=np.linspace(1,5,10) # end limit i.e. 5 is included.
print(d)
d=np.linspace(-2.3,2.2,5)
print(d)

#-----------------------------------------------------------------------
#        Accessing elements of array in arbitrary order
#-----------------------------------------------------------------------
print("---------------------------- 8")
a=np.array([2,8,63,-9,3.2,0 ,2 ,4 ,8 ,6 ,4 ,7 ,9,6]);
print(a)
b=a[[0,-1,2,2,-7]]
print(b)
print(a[np.arange(2,10,2)]) 

#-----------------------------------------------------------------------
#               Concatenating two arrays
#-----------------------------------------------------------------------
print("---------------------------- 9")
a=np.array([1,2,3,4,5])
print(a)
b=np.array([2.3,-9.4])
print(b)
c=np.hstack((a,b)); # Horizontal concatenation (double brackets are necessary)
# vertical is not possible here because of dimension mismatch
# (otherwise use np.vstack)
print(c)

#-----------------------------------------------------------------------
#            Deleting specific elements from array
#-----------------------------------------------------------------------
print("---------------------------- 10")
a=np.array([1,2,3,4,5,6,7,8,9,10,11])
print(a)
a=np.delete(a,[8,2,4])  # supply indices of elements to be deleted
print(a)

#-----------------------------------------------------------------------
#            Obtaining the dimensionality of array
#-----------------------------------------------------------------------
print("---------------------------- 11")
a=np.array([1,2,3,4,5,6,7,8,9,10,11])
print(a)
print(a.ndim)

#-----------------------------------------------------------------------
#            Obtaining type
#-----------------------------------------------------------------------
print("---------------------------- 12")
a=np.array([1,2,3,4,5,6,7,8,9,10,11.9])
print(a)
print(a.dtype)
print(type(a))

#-----------------------------------------------------------------------
#            Acessing elements of 1D array in sequence
#-----------------------------------------------------------------------
print("---------------------------- 13")
a=np.array([0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17])
print(a)
# Elements from index 0 to index 6 (excluded) with a gap of 3
print(a[0:6:3])

print("Completed Successfully")




