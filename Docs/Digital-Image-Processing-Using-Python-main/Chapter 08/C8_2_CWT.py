#======================================================================
# PURPOSE : Understanding Continuious Wavelet Transform (CWT)
#======================================================================
import pywt  # Install using – pip install pywavelets
import numpy as np
import matplotlib.pyplot as plt

# Creating Signal and performing CWT
Fs=100
T=1/Fs
L=1001   # Keep this odd for ease of Mathematics
n=np.linspace(0,L-1,L)
t=n*T

cut1=np.int32(np.floor(L/4))
sig1=np.sin(2*np.pi*(40)*t[0:cut1])
sig2=np.sin(2*np.pi*(20)*t[cut1:2*cut1])
sig3=np.sin(2*np.pi*(10)*t[2*cut1:3*cut1])
sig4=np.sin(2*np.pi*(5)*t[3*cut1::])
y=np.hstack((sig1,sig2,sig3,sig4))
scale1=np.arange(1,20,.1)
coef, freqs=pywt.cwt(y,scale1,'morl',sampling_period=T)

# Plotting Logic
fig,ax=plt.subplots(2,1)
fig.show()
ax[0].plot(t,y,'k')
ax[0].grid()
ax[0].set_title("Original Signal",fontsize=15)
ax[0].set_xlabel("Time")
ax[0].set_ylabel("Amplitude")
ax[0].set_xlim((0,np.max(t)))

ax[1].grid()
ax[1].matshow(np.log(1+abs(coef)),cmap='gray')
ax[1].set_xlabel("TRANSLATION")
ax[1].set_ylabel("SCALE")
ax[1].set_title("CWT (Top View)")
ax[1].set_aspect('auto')
ax[1].set_yticks(np.arange(0, len(scale1), step=20), labels=np.int32(scale1[0:len(scale1):20]))
ax[1].set_xticks(np.arange(0, L, step=100), labels=np.int32(t[0:len(t):100]))

plt.show()
print("Completed Successfully ... ")






