#======================================================================
# # PURPOSE : Understanding LIST in Python
#======================================================================

print("\n--------------------------------------------------------- 1 ")
a=[1,2.0,"Rajesh",[1,2,'Manish'],'8123']
print("The list is ... \n",a)

n=-1
print("Element ",n,"of the list is ....\n",a[n])    # access any element

b=a[1:4]            # slicing from element 1 to 3 (4 excluded)
print("Sliced array is ... ",b)

a[2]=300            # changing the element of list
print("List after change of element is ... \n",a)

a[2:4]=[100,200]    # changing the slice
print("List after change of slice is ... \n",a)

e=a[4][0]           # Accessing element of element
print("The required element is ... \n",e)

#---------------------------------------------------------------------
#           Operations on Lists (frequently used ones only)
#---------------------------------------------------------------------

print("\n--------------------------------------------------------- 2 ")

a=[1,2.0,"Rajesh",[1,2,'Manish'],'hi']
print("The list is ... \n",a)

a.append(2) # Append something at the end (can append only one item)
print("The list after appending is ... \n",a)

index=2
element=500
a.insert(index,element)  # insert an element at a location (index)
print("The list after inserting an element is ... \n",a)

b=[1,2,5]
c=[4,5,3]
c.extend(b)   # appending another list at the end called extending
print("List c after extending is ... \n",c)

print("\n--------------------------------------------------------- 3 ")
r=c.index(5)  # returns the index of element (only first occurence)
# (If the value is not there, it will throw an error)
print("The index of element in c is ... \n",r)

c.remove(5)   # removes the first occourence of the element
# (If the value is not there, it will throw an error)
print("List after removal of the element is ... \n",c)

c.sort(reverse=0) # 0 for ascending order, 1 for descending order
print("The list after Sorting is ... \n",c)

a=['Hello',1,2,[1,2,3]]
a.reverse()
print("The list after reversing is ... \n",a)

print("The List has total no. of elements = ... \n",len(a))

a=[1,2,3]
b=[4,5,6,7]
print("List Concatenation ... \n",a+b)
print("List Concatenation (with repetition) ... \n",a+2*b)

print("Completed Successfully ... ")
