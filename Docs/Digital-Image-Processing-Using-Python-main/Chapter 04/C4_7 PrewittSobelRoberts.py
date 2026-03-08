#==============================================================================
# PURPOSE : Illustration of Prewitt, Sobel & Roberts kernel on Images
#==============================================================================
import cv2
import matplotlib.pyplot as plt
import numpy as np
import scipy.signal as sci
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

input_image=np.float32(cv2.imread('img13.bmp',0))
#------------------------------------------------------------------------------
#              CREATING PREWITT, SOBEL or ROBERTS KERNELS
#------------------------------------------------------------------------------
my_filter1_x_Prewitt=np.float32([[1,0,-1],[1,0,-1],[1,0,-1]]) # Prewitt x-direction
my_filter1_y_Prewitt=np.float32([[1,1,1],[0,0,0],[-1,-1,-1]]) # Prewitt y-direction

my_filter1_x_Sobel=np.float32([[1,0,-1],[2,0,-2],[1,0,-1]]) # Sobel x-direction
my_filter1_y_Sobel=np.float32([[1,2,1],[0,0,0],[-1,-2,-1]]) # Sobel y-direction

my_filter1_x_Roberts=np.float32([[0,-1],[1,0]]) # Roberts x-direction
my_filter1_y_Roberts=np.float32([[-1,0],[0,1]]) # Roberts y-direction

#------------------------------------------------------------------------------
#           SELECTING PREWITT or SOBEL or ROBERTS KERNELS HERE
#------------------------------------------------------------------------------
filter1_x=my_filter1_x_Roberts
filter1_y=my_filter1_y_Roberts

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

# Way of adding super title to figure having subplots
fig1.suptitle("Roberts Kernel Results", fontsize=15)
# Change the string in above line according to selected kernel

plt.show()
print("Completed Successfully ...")












