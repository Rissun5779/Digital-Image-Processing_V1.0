#======================================================================
# PURPOSE : Understanding Conditional Statements in Python
#======================================================================

#---------------------------------------------------------------------
#                           If statement
#---------------------------------------------------------------------

print("\n--------------------------------------------------------- 1 ")
a=-9
if a<0:
    print("The number is less than 0")
    print("Its negative ... ")
    
#---------------------------------------------------------------------
#                         If-Else Ladder
#---------------------------------------------------------------------

print("\n--------------------------------------------------------- 2 ")
a=2
if a<0:
    print("The number is less than 0")
    print("Its negative ... ")
else:
    print("The number is greater than or equal to 0")
    print("It's positive or 0")
    
#---------------------------------------------------------------------
#                         If-elif-else Ladder
#---------------------------------------------------------------------

print("\n--------------------------------------------------------- 3 ")
a=0
if a<0:
    print("The number is less than 0")
    print("Its negative ... ")
elif a==0:
    print("The number is equal to 0")
    print("It's 0")
else:
    print("The number is greater than 0")
    print("It's positive ")

print("Completed Successfully ... ")


