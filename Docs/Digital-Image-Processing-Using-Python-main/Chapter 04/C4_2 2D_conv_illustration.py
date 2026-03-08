#==============================================================================
# PURPOSE : Illustration of 2D convolution
#==============================================================================
import cv2
import matplotlib.pyplot as plt
import numpy as np
import scipy.signal as sci
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

input_image=np.float32(cv2.imread('img9.bmp',0))
#------------------------------------------------------------------------------
#                     2D FILTER DESIGN
#------------------------------------------------------------------------------
n=5;
my_filter=np.ones([n,n])/(n**2) # Averaging filter (shape 5x5)

#------------------------------------------------------------------------------
#             2D CONVOLUTION in 3 DIFFERENT WAYS
#------------------------------------------------------------------------------
conv_result_same=sci.convolve(input_image,my_filter,'same')
conv_result_valid=sci.convolve(input_image,my_filter,'valid')
conv_result_full=sci.convolve(input_image,my_filter,'full')

#------------------------------------------------------------------------------
#                       PLOTTING
#------------------------------------------------------------------------------
fig1,ax1=plt.subplots(2,2)
fig1.show()
mf.my_imshow(mf.norm_uint8(input_image),"(a) Input Image",ax1[0,0])
mf.my_imshow(mf.norm_uint8(conv_result_same),"(b) Convolution (SAME)",ax1[0,1])
mf.my_imshow(mf.norm_uint8(conv_result_valid),"(c) Convolution (VALID)",ax1[1,0])
mf.my_imshow(mf.norm_uint8(conv_result_full),"(d) Convolution (FULL)",ax1[1,1])

#------------------------------------------------------------------------------
#    PRINTING SHAPE OF INPUT IMAGE, FILTER & VARIOUS OUTPUTS
#------------------------------------------------------------------------------
print("Shape of input image ... ",np.shape(input_image))
print("Shape of convolution filter ... ",np.shape(my_filter))
print("Shape of SAME CONVOLUTION ... ",np.shape(conv_result_same))
print("Shape of VALID CONVOLUTION ... ",np.shape(conv_result_valid))
print("Shape of FULL CONVOLUTION ... ",np.shape(conv_result_full))

plt.show()
print("Completed Successfully ...")










