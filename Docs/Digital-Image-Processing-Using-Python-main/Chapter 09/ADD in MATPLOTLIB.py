#======================================================================
# Author - Dr. Manish Kashyap
#======================================================================

# PURPOSE : 1D time frequency analysis using fft (MAGNITUDE PLOT & PHASE PLOT)


import my_package.my_functions as mf # This is a user defined package
import cv2,matplotlib.pyplot as plt
import numpy as np
import scipy.ndimage as sci
import scipy.fft as sfft

fig = plt.figure()

ax1= fig.add_subplot(3,3,1)
ax2= fig.add_subplot(3,3,2)
ax3= fig.add_subplot(3,3,4)
ax4= fig.add_subplot(3,3,5)
ax5= fig.add_subplot(3,3,7)
ax6= fig.add_subplot(3,3,8)
ax7= fig.add_subplot(2,3,3)
ax8= fig.add_subplot(2,3,6)
ax9= fig.add_subplot(2,3,6)


plt.show()
print("Completed Successfully ...")






