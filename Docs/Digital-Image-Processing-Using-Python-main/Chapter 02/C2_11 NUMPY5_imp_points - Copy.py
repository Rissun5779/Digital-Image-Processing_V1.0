#======================================================================
# PURPOSE : Array Operations (Important Points)
#======================================================================
import numpy as np

#----------------------------------------------------------------------
#                         VIEW (np.array & list)
#----------------------------------------------------------------------
print("\n---------------------------- 1 ")
a=np.array([1,2,5,7,2,3])
print("a is \n",a)
b=a
b[3]=3000    # This will reflect the change in both a & b (Hence it's a view)
print("a is \n",a)
print('b is \n',b)

#---------------------------------------------------------------------
#                      COPY (np.array & List)
#---------------------------------------------------------------------
print("\n---------------------------- 2 ")
a=np.array([1,2,5,7,2,3])
print("\n\n a is \n",a)
b=a.copy()
b[3]=3000    # This will NOT reflect the change in both a (Hence it's a copy)
print("a is \n",a)
print('b is \n',b)

#---------------------------------------------------------------------
#                          np.array to list
#---------------------------------------------------------------------
print("\n---------------------------- 3 ")
a=np.array([1,2,5,7,2,3])
print("a is \n",a)
b=a.tolist()
b[3]=3000    # This will NOT reflect the change in both a (Hence it's a copy)
print("a is \n",a,"\n data type of a is ",type(a))
print('b is \n',b,"\n data type of b is ",type(b))

#---------------------------------------------------------------------
#                          list to np.array
#---------------------------------------------------------------------
print("\n---------------------------- 4 ")
a=[1,2,5,7,2,3]
print("a is \n",a)
b=np.array(a)
b[3]=3000    # This will NOT reflect the change in both a (Hence it's a copy)
print("a is \n",a,"\n data type of a is ",type(a))
print('b is \n',b,"\n data type of b is ",type(b))

#---------------------------------------------------------------------
#                   SLICED VIEW (np.array vs List)
#---------------------------------------------------------------------
print("\n---------------------------- 5 ")
a=[1,2,5,7,2,3]
print("a is \n",a)
b=a
b[3]=3000    # This will reflect the change in both a & b (Hence it's a view)
print("a is \n",a)
print('b is \n',b)

c=b[0:3]
c[2]=2000     # Sliced array is copy for a list but for np.array, its view (IMP)

print("b is \n",b)
print('c is \n',c)


         #----- but for np.array, story is different ------------

print("\n---------------------------- 6 ")
a=np.array([1,2,5,7,2,3])
print("a is \n",a)
b=a
b[3]=3000    # This will reflect the change in both a & b (Hence it's a view)
print("a is \n",a)
print('b is \n',b)

c=b[0:3]
c[2]=2000     # Sliced array is copy for a list but for np.array, its view (IMP)

print("b is \n",b)
print('c is \n',c)

print("Completed Successfully ... ")















