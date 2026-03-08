#======================================================================
# PURPOSE : Understanding padding while taking FFT-IFFT
#======================================================================
import cv2,matplotlib.pyplot as plt
import numpy as np
import scipy.fft as sfft
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

#---------------------------------------------------------------------------
#     Importing and displaying image in space domain
#---------------------------------------------------------------------------
input_image=np.float32(cv2.imread('img1.bmp',0))
r,c=np.shape(input_image)
fig1,ax1=plt.subplots(2,2)
fig1.show()
mf.my_imshow(mf.norm_uint8(input_image),'(a) Spatial Domain',ax1[0,0])
ax1[0,0].axis('on')

ax1[0,0].set_xlabel('x (or c) axis->')
ax1[0,0].set_ylabel('<- y (or r) axis')

#---------------------------------------------------------------------------
#     IMAGE IN FREQUENCY DOMAIN 
#---------------------------------------------------------------------------
fft_input_image=sfft.fft2(input_image)
mag_image=np.abs(sfft.fftshift(fft_input_image))
mf.my_imshow(mf.norm_uint8(np.log(1+mag_image)),"(b) Frequency Domain",ax1[0,1])
ax1[0,1].axis('on')

# Setting the x-ticks as per frequency (f) in range [-.5 to .5]
x_positions=np.linspace(0,c,5);
x_labels=x_positions/np.max(x_positions)-0.5
ax1[0,1].set_xticks(x_positions, x_labels)

# Setting the y-ticks as per frequency (f) in range [-.5 to .5]
y_positions=np.linspace(0,r-1,5);
y_labels=y_positions/np.max(y_positions)-0.5
ax1[0,1].set_yticks(y_positions, y_labels)

ax1[0,1].set_xlabel('fx axis ->')
ax1[0,1].set_ylabel('fy axis ->')

#---------------------------------------------------------------------------
#   IMAGE IN FREQUENCY DOMAIN (With Equal samples for fx and fy)
#---------------------------------------------------------------------------
# No. of frequency samples on both axis in freq. domain
freq_points=np.max([r,c])
# NOTICE THE WAY THE FOLLOWING COMMAND IS USED
# [freq_points,freq_points] argument correspond to total samples
# on fx and fy axis respectively.
fft_input_image=sfft.fft2(input_image,[freq_points,freq_points])
mag_image=np.abs(sfft.fftshift(fft_input_image))
mf.my_imshow(mf.norm_uint8(np.log(1+mag_image)),"(c) NORMALISED Frequency Domain",ax1[1,0])
ax1[1,0].axis('on')

# Setting the x-ticks as per frequency (f) in range [-.5 to .5]
x_positions=np.linspace(0,freq_points-1,5);
x_labels=x_positions/np.max(x_positions)-0.5
ax1[1,0].set_xticks(x_positions, x_labels)

# Setting the y-ticks as per frequency (f) in range [-.5 to .5]
y_positions=np.linspace(0,freq_points-1,5);
y_labels=y_positions/np.max(y_positions)-0.5
ax1[1,0].set_yticks(y_positions, y_labels)

ax1[1,0].set_xlabel('fx axis ->')
ax1[1,0].set_ylabel('fy axis ->')

#---------------------------------------------------------------------------
#   Image Transformed back in time domain
#---------------------------------------------------------------------------
image_back_in_time=sfft.ifft2(fft_input_image)
mf.my_imshow(mf.norm_uint8(image_back_in_time),'(d) PADDED Spatial Domain',ax1[1,1])
ax1[1,1].axis('on')

ax1[1,1].set_xlabel('x (or c) axis->')
ax1[1,1].set_ylabel('<- y (or r) axis')

plt.show()
print("Completed Successfully ...")
















