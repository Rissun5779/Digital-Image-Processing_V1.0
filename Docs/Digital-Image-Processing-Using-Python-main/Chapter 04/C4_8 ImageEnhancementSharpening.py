#==============================================================================
# PURPOSE : Illustration of Image Enhancement (Sharpening) using Sobel Kernel
#==============================================================================
import cv2
import matplotlib.pyplot as plt
import numpy as np
import scipy.signal as sci
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

input_image=np.float32(cv2.imread('img12.bmp',0))
#------------------------------------------------------------------------------
#                 CREATING SOBEL KERNEL
#------------------------------------------------------------------------------
filter1_x=np.float32([[1,0,-1],[2,0,-2],[1,0,-1]]) # Sobel x-direction
filter1_y=np.float32([[1,2,1],[0,0,0],[-1,-2,-1]]) # Sobel y-direction

#------------------------------------------------------------------------------
#                    2D CONVOLUTION
#------------------------------------------------------------------------------
G_mag_x=sci.convolve(input_image,filter1_x,'same') # x-derivative
G_mag_y=sci.convolve(input_image,filter1_y,'same') # y-derivative
G_mag=(G_mag_x**2+G_mag_y**2)**(1/2) # Gradient Magnitude

#------------------------------------------------------------------------------
#                       PLOTTING
#------------------------------------------------------------------------------
fig1,ax1=plt.subplots(2,2)
fig1.show()
mf.my_imshow(mf.norm_uint8(input_image),"(a) Input Image",ax1[0,0])
mf.my_imshow(mf.norm_uint8(G_mag_x),"(b) x-derivative",ax1[0,1])
mf.my_imshow(mf.norm_uint8(G_mag_y),"(c) y-derivative",ax1[1,0])
mf.my_imshow(mf.norm_uint8(G_mag),"(d) Gradient Magnitude",ax1[1,1])
fig1.suptitle("Sobel Kernel Results", fontsize=15)
fig2,ax2=plt.subplots(1,3)
fig2.show()
mf.my_imshow(mf.norm_uint8(input_image),"(a) Input Image",ax2[0])
sharpened_image=input_image+np.float32(mf.norm_uint8(G_mag))
mf.my_imshow(mf.norm_uint8(sharpened_image),"(b) Sharpened Output (histogram shifted)",ax2[1])

#------------------------------------------------------------------------------
#                       SHARPENING & PLOTTING
#------------------------------------------------------------------------------
G_mag=np.float32(mf.norm_uint8(G_mag)) # Bring Grad Mag in 0-255 range
# and bringing back to float 32 format

# Finding locations where gradient magnitude is significant
# The threshold used is median of gradient magnitude itself
indx=np.where(np.float32(mf.norm_uint8(G_mag)>np.median(G_mag)))
input_image[indx]=input_image[indx]+G_mag[indx]

# Saturating the values above 255 after addition to 255
input_image[input_image>255]=255

sharpened_image=input_image
mf.my_imshow(mf.norm_uint8(sharpened_image),"(c) Sharpened Output",ax2[2])

plt.show()
print("Completed Successfully ...")











