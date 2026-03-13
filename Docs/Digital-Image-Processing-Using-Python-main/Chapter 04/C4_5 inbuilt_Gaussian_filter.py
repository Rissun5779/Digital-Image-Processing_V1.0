#======================================================================
# PURPOSE : Learning use of Inbuilt Gaussian filter
#======================================================================
import cv2,matplotlib.pyplot as plt, numpy as np
import scipy.ndimage as sci
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

input_image=cv2.imread('img1.bmp',0)
fig,ax=plt.subplots(1,2)
fig.show()
mf.my_imshow(input_image,'Input Grayscale Image',ax[0])
input_image=np.float32(input_image)

filtered_image=sci.gaussian_filter(input_image,5)
mf.my_imshow(mf.norm_uint8(filtered_image),"Filtered image (INBUILT GAUSSIAN FILTER)",ax[1])

plt.show()
print("Completed Successfully ...")


