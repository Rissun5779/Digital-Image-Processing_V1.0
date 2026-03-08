a=[1.5,.5,-3,2]
b=[x**2 for x in a]
print(min(a))
print(b)
print(min(a,key=lambda x:x**2))