#======================================================================
# PURPOSE : Finite Frequency range in discrete domain
#======================================================================
import cv2,matplotlib.pyplot as plt, numpy as np
import scipy.ndimage as sci
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

# Designing the signal in discrete time domain
f1=1/10  # Frequency is usually specified as p/q
n=np.arange(0,40,1)  # Discrete time (independent variable) axis
comp_exp=np.exp(2j*np.pi*f1*n)  # Complex exponential with imaginary exponent

fig1,ax1=plt.subplots(3,1)
fig1.show()
ax1[0].stem(n,np.real(comp_exp))
ax1[0].set_title('Original Signal (frequency f1)')
ax1[0].grid()

f2=f1+9 # Frequency shifted by integer
comp_exp=np.exp(2j*np.pi*f2*n)
ax1[1].stem(n,np.real(comp_exp))
ax1[1].set_title('Signal whose frequency is shifted by addition of integer (f1 + integer)')
ax1[1].grid()

f3=f1+2.3 # Frequency shifted by non-integer
comp_exp=np.exp(2j*np.pi*f3*n)
ax1[2].stem(n,np.real(comp_exp))
ax1[2].set_title('Signal whose frequency is shifted by addition of non-integer (f1 + non_integer)')
ax1[2].grid()

fig1.suptitle('Illustration of periodicity of frequency',fontsize=15)

plt.show()
print("Completed Successfully ...")

