#======================================================================
# PURPOSE : Understanding DWT and IDWT
#======================================================================
import pywt
import numpy as np
import matplotlib.pyplot as plt

#-----------------------------------------------------------------------
#                Creating Data and performing DWT
#-----------------------------------------------------------------------
fm=20
Fs=10*fm
L=1000
T=1/Fs
t=np.arange(0,L,1)*T
y0 = np.sin(2*np.pi*(fm/30)*t) # Low frequency component
noise = np.random.normal(0,.1,L) # Mostly high frequency component
y=y0+noise # Original signal
(cA, cD) = pywt.dwt(y,'sym2',mode='per') # mode='per' for half length output

#-----------------------------------------------------------------------
#                    Plotting DWT
#-----------------------------------------------------------------------
fig,ax=plt.subplots(4,1)
fig.show()

ax[0].plot(t,y,'k')
ax[0].grid()
ax[0].set_title("(a) Original Signal (with noise)")

ax[1].plot(t[0:np.int32(len(t)/2)],cA,'k')
ax[1].grid()
ax[1].set_title("(b) Approximation Coef. (Through DWT)")

ax[2].plot(t[0:np.int32(len(t)/2)],cD,'k')
ax[2].grid()
ax[2].set_title("(c) Detail Coef. (Through DWT)")

#-----------------------------------------------------------------------
#                    Performing IDWT
#-----------------------------------------------------------------------
# A = pywt.idwt(cA, None, 'sym2',mode='per')
# D = pywt.idwt(None, cD, 'sym2',mode='per')
# recovered_signal=A + D

recovered_signal = pywt.idwt(cA, cD, 'sym2',mode='per')

#-----------------------------------------------------------------------
#                    Plotting IDWT
#-----------------------------------------------------------------------
ax[3].plot(t,recovered_signal,'k')
ax[3].grid()
ax[3].set_title("(d) Recovered Signal (Through IDWT)")

plt.show()
print("Completed Successfully ... ")






