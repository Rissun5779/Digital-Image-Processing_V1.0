#======================================================================
# PURPOSE : Calculating and plotting STFT of a signal
#======================================================================
import cv2, matplotlib.pyplot as plt, numpy as np
import scipy.fft
import scipy.signal
from mpl_toolkits.mplot3d import Axes3D 
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

#-----------------------------------------------------------------
#     Setting parameters for signal construction
#-----------------------------------------------------------------
Fs=100  # Sampling Frequency
T=1/Fs  # Sampling interval
L=1001  # Total no. of samples in signal
n=np.linspace(0,L-1,L)   # Index of time
t=n*T                    # Time axis

#-----------------------------------------------------------------
#     Constructing a non stationary signal in discrete time
#-----------------------------------------------------------------
cut1=np.int16(np.floor(L/4))
sig1=4*np.sin(2*np.pi*(40)*t[0:cut1])
sig2=3*np.sin(2*np.pi*(30)*t[cut1:2*cut1])
sig3=2*np.sin(2*np.pi*(20)*t[2*cut1:3*cut1])
sig4=1*np.sin(2*np.pi*(10)*t[3*cut1::])
sig=np.hstack((sig1,sig2,sig3,sig4)) # Non stationary signal

#-----------------------------------------------------------------
#   Plotting the non-stationary signal in time domain
#-----------------------------------------------------------------
fig,ax=plt.subplots(2,1)
fig.show()
ax[0].plot(t,sig,color='k')
ax[0].grid()
ax[0].set_title("(a) Input Signal",fontsize=12)       
ax[0].set_xlabel("t",fontsize=12)     
ax[0].set_ylabel("Amplitude",fontsize=12)

#-----------------------------------------------------------------
#  Plotting the magnitude spectrum of non-stationary signal (FFT)
#-----------------------------------------------------------------
freq_axis2=np.linspace(-(L-1)/2,(L-1)/2,L)/L
fft_sig=scipy.fft.fftshift(scipy.fft.fft(sig/L))
ax[1].plot(freq_axis2*Fs,np.abs(fft_sig),color='k')
ax[1].grid()
ax[1].set_title("(b) 2 Sided Magnitude Plot (FFT)",fontsize=12,color='k')       
ax[1].set_xlabel("F",fontsize=12)     
ax[1].set_ylabel("Magnitude",fontsize=12)

#-----------------------------------------------------------------
# Plotting the magnitude spectrum of non-stationary signal (STFT)
#-----------------------------------------------------------------
fig2,ax2=plt.subplots()
f, t, Zxx = scipy.signal.stft(sig,Fs,window=np.ones(30),nperseg=30)
amp=np.max(np.abs(Zxx))
ax2.pcolormesh(t, f, np.abs(Zxx),cmap='gray_r')
ax2.set_title('STFT (Single Sided Spectrum)')
ax2.set_ylabel('Frequency [Hz]')
ax2.set_xlabel('Time [sec]')
ax2.grid()

#-----------------------------------------------------------------
#  Magnitude spectrum of non-stationary signal (STFT in 3D)
#-----------------------------------------------------------------
fig3d = plt.figure()
ax3d = fig3d.add_subplot(111, projection='3d')
T, F = np.meshgrid(t, f)
ax3d.plot_surface(T, F, 2*np.abs(Zxx), cmap='gray_r', edgecolors='k')
# In above, multiplication by 2 is due to single sided spectrum
ax3d.set_title('3D STFT Magnitude (SINGLE SIDED)')
ax3d.set_xlabel('Time [sec]')
ax3d.set_ylabel('Frequency [Hz]')
ax3d.set_zlabel('Magnitude')

plt.show()
print("Completed Successfully ...")







