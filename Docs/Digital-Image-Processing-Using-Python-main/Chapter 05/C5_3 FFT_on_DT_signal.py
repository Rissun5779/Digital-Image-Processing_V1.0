#======================================================================
# PURPOSE : 1D time-frequency representation of signal using FFT
#======================================================================
import cv2, matplotlib.pyplot as plt, numpy as np
import scipy.fft as sfft
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

#-----------------------------------------------------------------
#      Constructing a cosine signal in discrete time
#-----------------------------------------------------------------
f1=1/10        # Discrete frequency (In cycles/sample)
L=41           # Total no. of samples in the signal (keep this odd)
n=np.arange(0,L,1)              # Index of time
sig1=np.sin(2*np.pi*f1*n)       # Discrete time signal

#-----------------------------------------------------------------
#        Creating figure with empty axis
#-----------------------------------------------------------------
fig=plt.figure()
ax1=fig.add_subplot(3,1,1)
# fig.add_subplot(m,n,i) assumes that the figure has a
# grid structure of mxn and we are creating ith axis in that
ax2=fig.add_subplot(3,2,3)
ax3=fig.add_subplot(3,2,4)
ax4=fig.add_subplot(3,2,5)
ax5=fig.add_subplot(3,2,6)
fig.show()

#-----------------------------------------------------------------
#        Plotting the signal
#-----------------------------------------------------------------
ax1.stem(n,sig1)
ax1.grid()
ax1.set_title("(a) Input Signal",fontsize=12)       
ax1.set_xlabel("n",fontsize=12)     
ax1.set_ylabel("Amplitude",fontsize=12)

#-----------------------------------------------------------------
# Transforming Signal to Frequency Domain and plotting Magnitude plot
#-----------------------------------------------------------------
freq_axis=np.linspace(0,L-1,L)/L
fft_sig1=sfft.fft(sig1/L)
ax2.stem(freq_axis,np.abs(fft_sig1))
ax2.grid()
ax2.set_title("(b) Magnitude Plot (Without FFTSHIFT)",fontsize=12,color='k')       
ax2.set_xlabel("f",fontsize=12)     
ax2.set_ylabel("Magnitude",fontsize=12) 

#-----------------------------------------------------------------
#   Using FFT-SHIFT to correctly display the magnitude plot
#-----------------------------------------------------------------
freq_axis2=np.linspace(-(L-1)/2,(L-1)/2,L)/L
fft_sig1=sfft.fftshift(sfft.fft(sig1/L))
ax3.stem(freq_axis2,np.abs(fft_sig1))
ax3.grid()
ax3.set_title("(c) Magnitude Plot (With FFTSHIFT)",fontsize=12,color='k')       
ax3.set_xlabel("f",fontsize=12)     
ax3.set_ylabel("Magnitude",fontsize=12) 

#-----------------------------------------------------------------
#               Plotting Phase plot
#-----------------------------------------------------------------
ax4.stem(freq_axis2,np.angle(fft_sig1)/np.pi)
ax4.grid()
ax4.set_title("(d) Phase plot (Truncation neglected)",fontsize=12,color='k')       
ax4.set_xlabel("f",fontsize=12)     
ax4.set_ylabel("Phase (x Pi)",fontsize=12) 

#-----------------------------------------------------------------
#          Plotting Corrected Phase plot
#-----------------------------------------------------------------
max_mag=np.max(np.abs(fft_sig1))
fft_sig1[np.abs(fft_sig1)<0.90*max_mag]=0
ax5.stem(freq_axis2,np.angle(fft_sig1)/np.pi)
ax5.grid()
ax5.set_title("(e) Corrected Phase Plot (Truncation considered)",fontsize=12)       
ax5.set_xlabel("f",fontsize=12)     
ax5.set_ylabel("Phase (x Pi)",fontsize=12)

fig.suptitle("Time-Frequency representation of discrete time signal",fontsize=15)
plt.show()
print("Completed Successfully ...")





