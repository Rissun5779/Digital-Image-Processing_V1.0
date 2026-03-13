#======================================================================
# PURPOSE : Learning Histogram Equalisation
#======================================================================

import cv2,matplotlib.pyplot as plt, numpy as np
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

a=cv2.imread('img4.bmp',0)
r,c=np.shape(a)
fig,ax=plt.subplots(2,2)
fig.show()
mf.my_imshow(a,'(a) Grayscale Image',ax[0,0])

no_of_bins=30             
X_axis=255*np.arange(0,no_of_bins,1)/(no_of_bins-1)
hist_values=cv2.calcHist([a],[0],None,[no_of_bins],[0,256])/(r*c) 

plt.subplot(2,2,3)
plt.stem(X_axis,hist_values)
plt.grid()
plt.title('(c) '+str(no_of_bins)+' bin histogram of (a)')

hist_equ_image = cv2.equalizeHist(a)
mf.my_imshow(hist_equ_image,'(b) Histogram Equalised Image',ax[0,1])
hist_values2=cv2.calcHist([hist_equ_image],[0],None,[no_of_bins],[0,256])/(r*c)

plt.subplot(2,2,4)
plt.stem(X_axis,hist_values2)
plt.grid()
plt.title('(d) '+str(no_of_bins)+' bin histogram of (b)')

plt.show()
print("Completed Successfully ...")


