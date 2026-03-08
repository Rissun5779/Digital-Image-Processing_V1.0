#======================================================================
# PURPOSE : Learning Histogram
#======================================================================

import cv2,matplotlib.pyplot as plt, numpy as np
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

#--------------------------------------------------------------------------
#                 Image Histogram
#--------------------------------------------------------------------------
a=cv2.imread('img3.bmp',0)
r,c=np.shape(a)
fig,ax=plt.subplots(3,1)
fig.show()
mf.my_imshow(a,'(a) Grayscale Image',ax[0])

no_of_bins=16              #This defines the total no. of points on X axis
X_axis=255*np.arange(0,no_of_bins,1)/(no_of_bins-1)
hist_values=cv2.calcHist([a],[0],None,[no_of_bins],[0,256]) # Corresponding values on Y axis

plt.subplot(3,1,2)
plt.stem(X_axis,hist_values)
plt.grid()
plt.title('(b) '+str(no_of_bins)+' bin UN-NORMALIZED histogram')

plt.subplot(3,1,3)
plt.stem(X_axis,hist_values/(r*c))
plt.grid()
plt.title('(c) '+str(no_of_bins)+' bin NORMALIZED histogram')

plt.show()
print("Completed Successfully ...")

