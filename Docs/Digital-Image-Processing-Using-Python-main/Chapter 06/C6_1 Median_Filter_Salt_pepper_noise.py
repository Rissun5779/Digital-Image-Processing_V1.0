#======================================================================
# PURPOSE : Learning Denoising by MEDIAN Filter vs Gaussian Filter
# (Salt and Pepper Noise)
#======================================================================
import cv2
import matplotlib.pyplot as plt
import numpy as np
import scipy.ndimage as sci
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

#--------------------------------------------------------------------------
# Importing and displaying the image
#--------------------------------------------------------------------------
a=cv2.imread('img21.bmp',0)
fig,ax=plt.subplots(1,3)
fig.show()
mf.my_imshow(a,'(a) Input Grayscale Image',ax[0])
a=np.float32(a)

#--------------------------------------------------------------------------
# Gaussian filtering (Linear) the image in space domain and displaying
#--------------------------------------------------------------------------
filtered_image=sci.gaussian_filter(a,1) # Second argument is sigma of Gaussian
mf.my_imshow(mf.norm_uint8(filtered_image),"(b) Gaussian Filtered Image",ax[1])

#--------------------------------------------------------------------------
# Median filtering (Non-Linear) the image in space domain and displaying
#--------------------------------------------------------------------------
filtered_image2=sci.median_filter(a,3) # Second argument is neighborhood size
mf.my_imshow(mf.norm_uint8(filtered_image2),"(c) Median Filtered Image",ax[2])

plt.show()
print("Completed Successfully ...")
