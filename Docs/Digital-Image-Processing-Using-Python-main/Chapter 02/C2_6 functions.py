#======================================================================
# PURPOSE : Understanding Functions in Python
#======================================================================

#---------------------------------------------------------------------
#                          functions
#---------------------------------------------------------------------

print("\n--------------------------------------------------------- 1 ")
def my_func(a,b):
    c=a+b
    d=a-b
    return c,d

print("Function demonstration ... ")
m,n=my_func(2,3)
print("The returned values are ... ",m,"&",n)
m,n=my_func(2,sum(my_func(5,6)))
print("The returned values are... ",m,"&",n)

#---------------------------------------------------------------------
#                          Lambdas
#---------------------------------------------------------------------

print("\n--------------------------------------------------------- 2 ")
x=lambda a,b,c : a+b-c
print("Value returned by lambda ... ",x(2,3,4))
print("Value returned by lambda ... ",x(7,3,6))

print("Completed Successfully ... ")



