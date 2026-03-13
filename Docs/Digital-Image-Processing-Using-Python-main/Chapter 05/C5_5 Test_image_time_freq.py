#======================================================================
# PURPOSE : Understanding 2D frequency domain through test image
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
f=.05                          # Set Discrete Frequency here
n=np.linspace(0,c-1,c)
one_row=np.sin(2*np.pi*f*n)
for i in range(0,r,1):
    input_image[i,:]=one_row
rot_angle=0                  # Set Rotation angle in degrees here
input_image = ndimage.rotate(input_image,rot_angle,reshape=False)

fig1,ax1=plt.subplots(1,2)
fig1.show()
mf.my_imshow(mf.norm_uint8(input_image),'(a) Image in Spatial Domain',ax1[0])
ax1[0].axis('on')

#---------------------------------------------------------------------------
#                IMAGE IN FREQUENCY DOMAIN
#---------------------------------------------------------------------------
fft_input_image=sfft.fft2(input_image)
mag_image=np.abs(sfft.fftshift(fft_input_image))
mf.my_imshow(mf.norm_uint8(mag_image),"(b) Image in Frequency Domain",ax1[1])
ax1[1].axis('on')

# Setting the x-ticks as per frequency (f) in range [-.5 to .5]
x_positions=np.linspace(0,c-1,5);
x_labels=x_positions/np.max(x_positions)-0.5
ax1[1].set_xticks(x_positions, x_labels)

# Setting the y-ticks as per frequency (f) in range [-.5 to .5]
y_positions=np.linspace(0,r-1,5);
y_labels=y_positions/np.max(y_positions)-0.5
ax1[1].set_yticks(y_positions, y_labels)

plt.show()
print("Completed Successfully ...")











