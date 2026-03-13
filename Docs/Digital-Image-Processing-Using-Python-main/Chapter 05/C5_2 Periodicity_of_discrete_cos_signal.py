#======================================================================
# PURPOSE : Understanding periodicity of discrete cosine signals
#======================================================================
import cv2,matplotlib.pyplot as plt, numpy as np
import scipy.ndimage as sci
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

f1=1/10
n=np.arange(0,40,1)  
sig1=np.cos(2*np.pi*f1*n) 

fig1,ax1=plt.subplots(3,1)
fig1.show()
ax1[0].stem(n,np.real(sig1))
ax1[0].set_title('(a) COS Signal with frequency f1 = 1/10')
ax1[0].grid()

f2=2/10
sig2=np.exp(2j*np.pi*f2*n)
ax1[1].stem(n,np.real(sig2))
ax1[1].set_title('(b) COS Signal with frequency f2 = 2/10')
ax1[1].grid()

f3=3/10
sig3=np.exp(2j*np.pi*f3*n)
ax1[2].stem(n,np.real(sig3))
ax1[2].set_title('(c) COS Signal with frequency f3 = 3/10')
ax1[2].grid()

fig2,ax2=plt.subplots()
fig2.show()
f4=np.pi
sig4=np.cos(2*np.pi*f4*n)
ax2.stem(n,sig4)
ax2.set_title('COS Signal with frequency f4 = pi')
ax2.grid()

plt.show()
print("Completed Successfully ...")

