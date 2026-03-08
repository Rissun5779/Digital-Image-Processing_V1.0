#======================================================================
# PURPOSE : Displaying an image in spatial and frequency domains
#======================================================================
import cv2,matplotlib.pyplot as plt
import numpy as np
import scipy.fft as sfft
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

#---------------------------------------------------------------------------
#                IMAGE IN SPATIAL DOMAIN
#---------------------------------------------------------------------------
input_image=np.float32(cv2.imread('img1.bmp',0))
fig1,ax1=plt.subplots(1,2)
fig1.show()
mf.my_imshow(mf.norm_uint8(input_image),'(a) Image in Spatial Domain',ax1[0])

#---------------------------------------------------------------------------
#                IMAGE IN FREQUENCY DOMAIN
#---------------------------------------------------------------------------
fft_input_image=sfft.fft2(input_image)
mag_image=np.abs(sfft.fftshift(fft_input_image))
mf.my_imshow(mf.norm_uint8(np.log(1+mag_image)),"(b) Image in Frequency Domain",ax1[1])

plt.show()
print("Completed Successfully ...")










