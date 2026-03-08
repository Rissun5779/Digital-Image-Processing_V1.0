#======================================================================
# PURPOSE : Learning Binary Boundary Extraction Algorithm
#======================================================================
import cv2
import matplotlib.pyplot as plt
import numpy as np
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

# Reading the image from disk
input_image=np.float32(cv2.imread('img25.bmp',0))

# Creating a symmetric structuring element
SE=np.uint8(np.ones((3,3)))

# Eroding the input image with the structuring element
eroded_image=cv2.erode(input_image,SE,iterations = 1)

# Finding subscripted indices of foreground in input image
ip_f=np.where(input_image>0)

# Finding subscripted indices of foreground in eroded image
e_f=np.where(eroded_image>0)

# Converting subscripted indices to linear (for foreground of input image)
# Also the data type is changed to SET as we need to perform set difference later
ip_f_lin=set(np.ravel_multi_index(ip_f,np.shape(input_image),order='F'))

# Converting subscripted indices to linear (for foreground of eroded image)
# Also the data type is changed to SET as we need to perform set difference later
e_f_linear=set(np.ravel_multi_index(e_f,np.shape(input_image),order='F'))

# Applying the set difference (making the result LIST first and then INT array)
bounday_pixel_lin=np.int32(list(ip_f_lin.difference(e_f_linear)))

# Getting back the subscripted indices
bounday_pixel_cord=np.unravel_index(bounday_pixel_lin,np.shape(input_image),order='F')

# Creating empty result image of same shape as input
result_image=np.zeros(np.shape(input_image))

# Putting the boundary pixels as WHITE 
result_image[bounday_pixel_cord]=255

# Display logic
fig1,ax1=plt.subplots(1,2)
mf.my_imshow(mf.norm_uint8(input_image),'(a) Input Binary Image',ax1[0])
mf.my_imshow(mf.norm_uint8(result_image),'(b) Boundary Image',ax1[1])

plt.show()
print("Completed Successfully ...")





