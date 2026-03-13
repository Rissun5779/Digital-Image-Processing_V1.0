#======================================================================
# PURPOSE : Learning Histogram Interpretation
#======================================================================

import cv2,matplotlib.pyplot as plt, numpy as np
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

#--------------------------------------------------------------------------
#                 Image Histogram
#--------------------------------------------------------------------------
a=cv2.imread('img3.bmp',1)
r,c,h=np.shape(a)
mf.my_imshow(a,'Input BGR Image')

no_of_bins=16
X_axis=255*np.arange(0,no_of_bins,1)/(no_of_bins-1)
histB = cv2.calcHist([a],[0],None,[no_of_bins],[0,256])/(r*c) 
histG = cv2.calcHist([a],[1],None,[no_of_bins],[0,256])/(r*c) 
histR = cv2.calcHist([a],[2],None,[no_of_bins],[0,256])/(r*c) 

fig4,ax4=plt.subplots(2,3)
fig4.show()

mf.my_imshow(a[:,:,0],'(a) Blue Frame',ax4[0,0])
mf.my_imshow(a[:,:,1],'(b) Green Frame',ax4[0,1])
mf.my_imshow(a[:,:,2],'(c) Red Frame',ax4[0,2])

plt.subplot(2,3,4)
plt.stem(X_axis,histB)
plt.grid()
plt.title('(d) Blue Frame '+str(no_of_bins)+' bin histogram')

plt.subplot(2,3,5)
plt.stem(X_axis,histG)
plt.grid()
plt.title('(e) Green Frame '+str(no_of_bins)+' bin histogram')

plt.subplot(2,3,6)
plt.stem(X_axis,histR)
plt.grid()
plt.title('(f) Red Frame '+str(no_of_bins)+' bin histogram')

plt.show()
print("Completed Successfully ...")
