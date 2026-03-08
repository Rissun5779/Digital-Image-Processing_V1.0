#======================================================================
# PURPOSE : Understanding TUPLE in Python
#======================================================================

print("\n--------------------------------------------------------- 1 ")
a=("Arjun",1,2.22,[1,2,3])
print("Our tule is ... \n",a)

# a[2]=200 -This command will give an error because tuples are immutable
a[3][1]=5   # But interestingly, this works!!!
print("New value of the tuple is ... \n",a)

print("Completed Successfully ... ")