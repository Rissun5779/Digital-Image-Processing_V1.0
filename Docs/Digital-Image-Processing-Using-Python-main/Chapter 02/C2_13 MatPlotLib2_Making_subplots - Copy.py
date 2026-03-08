#======================================================================
# PURPOSE : Learning simple plots (USING MATPLOTLIB)
#======================================================================
import matplotlib.pyplot as plt, numpy as np

#-----------------------------------------------------------------
#        Making Subplots
#-----------------------------------------------------------------

Fs=1000
T=1/Fs
L=1001   # Keep this odd for ease of Mathematics
t=np.linspace(0,L-1,L)*T

f1=5
sig1=np.sin(2*np.pi*f1*t)
f2=2
sig2=np.sin(2*np.pi*f2*t)
sig3=t;

fig1,ax1=plt.subplots(2,3)
fig1.show()
ax1[0,0].plot(t,sig1,label='sine curve',color='g',marker='.')
ax1[0,0].plot(t,sig2,label='cosine curve',color='k')
ax1[0,0].plot(t,sig3,label='Line',linestyle='dashed',linewidth=3)
ax1[0,0].grid()
ax1[0,0].set_title("Input Signal",fontsize=20)     
ax1[0,0].set_xlabel("The Time Axis",fontsize=15)   
ax1[0,0].set_ylabel("The Amplitude axis",fontsize=15)   
ax1[0,0].legend()

sig4=np.array([2,3,5,6,7,8,5,3,4,5])
sig5=np.array([9,8,7,8.8,4.5,2.09,3,1,2,3])
x=np.linspace(0,9,10)
ax1[1,1].stem(x,sig4,label='signal 4')
ax1[1,1].stem(x,sig5,'r-.','g>',label='signal 5')
ax1[1,1].grid()
ax1[1,1].set_title("Input Signal",fontsize=20)     
ax1[1,1].set_xlabel("The Time Axis",fontsize=15)   
ax1[1,1].set_ylabel("The Amplitude axis",fontsize=15)   
ax1[1,1].legend()
 
plt.show()
print("Completed Successfully")
