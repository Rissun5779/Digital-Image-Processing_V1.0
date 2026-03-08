#===========================================================================
# PURPOSE : Learning how to plot phase spectrum of images
#===========================================================================
import cv2,matplotlib.pyplot as plt
import numpy as np
import scipy.fft as sfft
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

#---------------------------------------------------------------------------
#   Importing and displaying image in space domain
#---------------------------------------------------------------------------
input_image=np.float32(cv2.imread('img1.bmp',0))
r,c=np.shape(input_image)
fig1,ax1=plt.subplots(2,2)
fig1.show()
mf.my_imshow(mf.norm_uint8(input_image),'(a) Input image',ax1[0,0])

#---------------------------------------------------------------------------
#   Image in normalised frequency domain
#---------------------------------------------------------------------------
# Magnitude Plot
freq_points=np.max([r,c])
fft_input_image=sfft.fft2(input_image,[freq_points,freq_points])
mag_image=np.abs(sfft.fftshift(fft_input_image))
mf.my_imshow(mf.norm_uint8(np.log(1+mag_image)),"(b) Magnitude Plot",ax1[0,1])

# Phase plot
phase_image=np.angle(sfft.fftshift(fft_input_image))
mf.my_imshow(mf.norm_uint8(phase_image),"(c) Phase Plot",ax1[1,0])

#---------------------------------------------------------------------------
#   Image Transformed back in time domain
#---------------------------------------------------------------------------
image_back_in_time=sfft.ifft2(sfft.ifftshift(mag_image*np.exp(np.sqrt(-1+0j)*phase_image)))
mf.my_imshow(mf.norm_uint8(image_back_in_time[0:r,0:c]),'(d) Recovered Image',ax1[1,1])

plt.show()
print("Completed Successfully ...")

















