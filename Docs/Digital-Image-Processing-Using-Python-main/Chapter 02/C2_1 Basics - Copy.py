#======================================================================
# PURPOSE : Getting Started with Python
#======================================================================
import math
#---------------------------------------------------------------------
#                    Defining Variables
#---------------------------------------------------------------------
a='Manish'                # Character or string
print("a is ...",a)
a=2                       # Integer
print("a is ...",a)
b=3.2                     # Float
print("b is ...",b)
#---------------------------------------------------------------------
#                    Basic Mathematics
#---------------------------------------------------------------------
print('....................................................... 1')
c=a+b                     # Addition
print("c is ...",c)
d=a-b                     # Subtraction
print("d is ...",d)
e=a*b                     # Multiplication
print("e is ...",e)
f=a/b                     # Division
print("f is ...",f)
g=a**b                    # Power
print("g is ...",g)
#---------------------------------------------------------------------
#                    Advanced Math
#---------------------------------------------------------------------
print('....................................................... 2')
a=90
print("Sine of a is ... ",math.sin(a))
a=(math.pi)/2
print("Sine of a is ... ",math.sin(a))
a=8
print("Log of a is ... ",math.log(a,8))
print("Log of a is ... ",math.log(a,2))
#---------------------------------------------------------------------
#                    Typecasting
#---------------------------------------------------------------------
print('....................................................... 3')
a=2.9
print("a is ...",a)
a=int(a)
print("a is ...",a)
a=float(a)
print("a is ...",a)
#---------------------------------------------------------------------
#                    Taking Input From User
#---------------------------------------------------------------------
print('....................................................... 4')
a=input("Enter a string ... ")          # 'a' is by default a string
print("a is ...",a)

print('....................................................... 5')
a=int(input("Enter an integer ... "))       # Notice typecasting in this
print("a is ...",a)

print('....................................................... 6')
a=float(input("Enter an float ... "))       # Notice typecasting in this
print("a is ...",a)

print("Completed Successfully ... ")

















