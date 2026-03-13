#============================================================================
# PURPOSE : Denoising using wavelet based MRA
#============================================================================
import pywt
import numpy as np
import scipy.ndimage as sci
import matplotlib.pyplot as plt

#----------------------------------------------------------------------
#  Creating Data and performing DWT (At multiple resloutions - MRA)
#----------------------------------------------------------------------
fm=200
Fs=100*fm
L=2**12 # Keep this in powers of 2 for ease of plotting later
T=1/Fs
t=np.arange(0,L,1)*T

y0 = np.zeros(L)
y0[np.int32(len(t)/7):np.int32(len(t)/5)+500]=1
y0=np.sin(2*np.pi*(fm/4)*t)*y0
y0[np.int32(len(t)/2):np.int32(len(t)/2)+1000]=1

noise = np.random.normal(0,.1,L)
y=y0+noise # Input signal with noise

#----------------------------------------------------------------------
#     Decomposition by using DWT - MRA
#----------------------------------------------------------------------
levels_of_decomposition=5
fig1,ax1=plt.subplots(levels_of_decomposition,2)
fig1.show()

cA_list=[]
cD_list=[]
y2=y.copy()
for i in np.arange(0,levels_of_decomposition,1):
    (cA, cD) = pywt.dwt(y2,'sym2',mode='per')
    cA_list.append(cA)
    cD_list.append(cD)
    ax1[i,0].plot(t[0:np.int32(len(y2)/2)],cA,'k')
    ax1[i,0].grid()
    str1="cA at level "+str(i+1)
    ax1[i,0].set_title(str1)

    ax1[i,1].plot(t[0:np.int32(len(y2)/2)],cD,'k')
    ax1[i,1].grid()
    str2="cD at level "+str(i+1)
    ax1[i,1].set_title(str2)

    y2=cA
#----------------------------------------------------------------------------
#         IDWT MRA Based Reconstruction by Hard Thresholding 
#----------------------------------------------------------------------------
recovered_signal=cA
for i in np.arange(levels_of_decomposition-1,-1,-1):
    A = pywt.idwt(recovered_signal, None, 'sym2',mode='per')
    thresh_array=cD_list[i].copy()
    thresh_array[np.abs(thresh_array)>.9*np.max(np.abs(thresh_array))]=1
    D = pywt.idwt(None, cD_list[i]*thresh_array, 'sym2',mode='per')
    recovered_signal=A + D
    
#----------------------------------------------------------------------
#         Traditional Noise removal (for comparison)
#----------------------------------------------------------------------
y3=y.copy()
filter1=np.ones(15*levels_of_decomposition)
filter1=filter1/np.sum(filter1)
recovered_signal2=sci.correlate(y3,filter1)

#----------------------------------------------------------------------
#             Plotting Logic
#----------------------------------------------------------------------
fig2,ax2=plt.subplots(4,1)
fig2.show()

ax2[0].plot(t,y0,'k')
ax2[0].grid()
ax2[0].set_title("(a) Original Signal")

ax2[1].plot(t,y,'k')
ax2[1].grid()
ax2[1].set_title("(b) Original Signal + Noise")

ax2[2].plot(t,recovered_signal,color='k')
ax2[2].grid()
ax2[2].set_title("(c) Recovered Signal (Wavelet MRA Denoising)")

ax2[3].plot(t,recovered_signal2,'k')
ax2[3].grid()
ax2[3].set_title("(d) Recovered Signal (Traditional Filtering)")

plt.show()
print("Completed Successfully ... ")