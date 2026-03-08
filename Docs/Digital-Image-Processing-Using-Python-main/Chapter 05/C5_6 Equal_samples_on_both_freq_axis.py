#======================================================================
# PURPOSE : Having equal no. of samples on both axis in freq. domain
#======================================================================
import cv2,matplotlib.pyplot as plt
import numpy as np
import scipy.fft as sfft
from scipy import ndimage
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

#---------------------------------------------------------------------------
#     Creating a test image in spatial domain and displaying
#---------------------------------------------------------------------------
r=70
c=100
input_image=np.float32(np.zeros((r,c)))
input_image2=np.float32(np.zeros((r,c)))

f=.3                          # Set Discrete Frequency here
n=np.linspace(0,c-1,c)
one_row=np.sin(2*np.pi*f*n)
for i in range(0,r,1):
    input_image[i,:]=one_row
rot_angle=30                  # Set Rotation angle in degrees here

for rot_angle in np.arange(0,180,1):
    input_image2 = input_image2+ndimage.rotate(input_image,rot_angle,reshape=False)

input_image =input_image2

fig1,ax1=plt.subplots(1,2)
fig1.show()
mf.my_imshow(mf.norm_uint8(input_image),'(a) Spatial Domain f=0.3',ax1[0])
ax1[0].axis('on')

#---------------------------------------------------------------------------
#                IMAGE IN FREQUENCY DOMAIN
#---------------------------------------------------------------------------
# No. of frequency samples on both axis in freq. domain
freq_points=np.max([r,c])
# NOTICE THE WAY THE FOLLOWING COMMAND IS USED
# [freq_points,freq_points] argument correspond to total samples
# on fx and fy axis respectively.
fft_input_image=sfft.fft2(input_image,[freq_points,freq_points])
mag_image=np.abs(sfft.fftshift(fft_input_image))
mf.my_imshow(mf.norm_uint8(mag_image),"(b) Image in Frequency Domain",ax1[1])
ax1[1].axis('on')

# Setting the x-ticks as per frequency (f) in range [-.5 to .5]
x_positions=np.linspace(0,freq_points-1,5);
x_labels=x_positions/np.max(x_positions)-0.5
ax1[1].set_xticks(x_positions, x_labels)

# Setting the y-ticks as per frequency (f) in range [-.5 to .5]
y_positions=np.linspace(0,freq_points-1,5);
y_labels=y_positions/np.max(y_positions)-0.5
ax1[1].set_yticks(y_positions, y_labels)

plt.show()
print("Completed Successfully ...")















