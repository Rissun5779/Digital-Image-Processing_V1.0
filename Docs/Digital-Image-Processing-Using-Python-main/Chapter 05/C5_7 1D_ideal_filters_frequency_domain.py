#======================================================================
# PURPOSE : Frequency domain IDEAL LOW PASS filtering in one-dimension
#======================================================================
import cv2, matplotlib.pyplot as plt, numpy as np
import scipy.fft as sfft
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

#-----------------------------------------------------------------
# Constructing cosine signal (discrete time) with two frequency components
#-----------------------------------------------------------------
f1=1/3      # Discrete frequency (In cycles/sample for component 1)
f2=1/20     # Discrete frequency (In cycles/sample for component 2)
L=81           # Total no. of samples in the signal
n=np.arange(0,L,1)              # Index of time
sig1=3*np.sin(2*np.pi*f1*n)
sig2=2*np.sin(2*np.pi*f2*n)
sig=sig1+sig2      # Discrete time signal with two frequencies

#-----------------------------------------------------------------
#    Plotting 1st component of the signal in time domain
#-----------------------------------------------------------------
fig1,ax1=plt.subplots(3,2)
fig1.show()
ax1[0,0].stem(n,np.real(sig1)) # Component 1 of the signal
ax1[0,0].grid()
ax1[0,0].set_title("(a) Component 1")       
ax1[0,0].set_xlabel("n",fontsize=12)     
ax1[0,0].set_ylabel("Amplitude",fontsize=12)

#-----------------------------------------------------------------
#    Plotting 2nd component of the signal in time domain
#-----------------------------------------------------------------
ax1[0,1].stem(n,np.real(sig2)) # Component 2 of the signal
ax1[0,1].grid()
ax1[0,1].set_title("(b) Component 2")      
ax1[0,1].set_xlabel("n",fontsize=12)     
ax1[0,1].set_ylabel("Amplitude",fontsize=12)

#-----------------------------------------------------------------
# Plotting the signal in time domain (signal=component1+component2)
#-----------------------------------------------------------------
ax1[1,0].stem(n,np.real(sig))
ax1[1,0].grid()
ax1[1,0].set_title("(c) Input Signal = Component 1 + Component 2")       
ax1[1,0].set_xlabel("n",fontsize=12)     
ax1[1,0].set_ylabel("Amplitude",fontsize=12)

#-----------------------------------------------------------------
#        Transforming signal to frequency domain
#-----------------------------------------------------------------
freq_axis=np.linspace(-(L-1)/2,(L-1)/2,L)/L
fft_sig=sfft.fftshift(sfft.fft(sig/L))
ax1[1,1].stem(freq_axis,np.abs(fft_sig))
ax1[1,1].grid()
ax1[1,1].set_title("(d) Magnitude Plot (Signal)",color='k')       
ax1[1,1].set_xlabel("f",fontsize=12)     
ax1[1,1].set_ylabel("Magnitude",fontsize=12)

#-----------------------------------------------------------------
#        Lowpass filter design in frequency domain
#-----------------------------------------------------------------
# Initialisation with all zeros
freq_filter=np.zeros(np.size(freq_axis))
# SET CUTOFF FREQUENCY HERE
fc=.2
# LPF Design
freq_filter[np.asarray(np.where((freq_axis>-fc) & (freq_axis<fc)))]=1
ax1[2,0].stem(freq_axis,freq_filter)
ax1[2,0].grid()
ax1[2,0].set_title("(e) IDEAL LPF in frequency domain",color='k')       
ax1[2,0].set_xlabel("f",fontsize=12)     
ax1[2,0].set_ylabel("Magnitude",fontsize=12)

#-----------------------------------------------------------------
#   Transforming the filtered signal back to time domain
#-----------------------------------------------------------------
filtered_signal_time=L*fft_sig*freq_filter # L is normalisation factor
ifft_sig=sfft.ifft(sfft.ifftshift(filtered_signal_time))
ax1[2,1].stem(n,np.real(ifft_sig))
ax1[2,1].grid()
ax1[2,1].set_title("(f) Filtered Signal (Time domain)")       
ax1[2,1].set_xlabel("n",fontsize=12)     
ax1[2,1].set_ylabel("Amplitude",fontsize=12)

plt.show()
print("Completed Successfully ...")






