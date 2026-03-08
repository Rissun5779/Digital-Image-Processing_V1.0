#======================================================================
# PURPOSE : Understanding Convolution & Correlation
# (Impulse response perspective)
#======================================================================
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX
import cv2,matplotlib.pyplot as plt, numpy as np
import scipy.ndimage as sci

a=np.zeros([11,11])
a[5,5]=1   
a=np.float32(a) # Signal Created
my_filter=np.array([[1,2,3],[4,5,6],[7,8,9]]) # System Created

filtered_image_corr=sci.correlate(a,my_filter) #  Performing Correlation
filtered_image_conv=sci.convolve(a,my_filter) # Performing Convolution

#--------------------------------------------------------------------------
#              Plotting
#--------------------------------------------------------------------------
fig1,ax1=plt.subplots(2,2)
fig1.show()
mf.my_imshow(a,'Input Image',ax1[0,0])
mf.my_imshow(mf.norm_uint8(my_filter),'Filter Applied',ax1[0,1])
mf.my_imshow(mf.norm_uint8(filtered_image_corr),'Response of CORR',ax1[1,0])
mf.my_imshow(mf.norm_uint8(filtered_image_conv),'Response of CONV',ax1[1,1])

plt.show()
print("Completed Successfully ...")
