#======================================================================
# PURPOSE : Learning Affine Transformation on images
#======================================================================
import cv2,matplotlib.pyplot as plt, numpy as np
from skimage.transform import warp # For warping the image by transform matrix
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

#--------------------------------------------------------------------------
#            Importing the image and displaying
#--------------------------------------------------------------------------
input_image=cv2.imread('img1.bmp',0)
rows, cols = input_image.shape

fig,ax=plt.subplots(1,3)
fig.show()
mf.my_imshow(input_image,"(a) Input Grayscale Image",ax[0])

#--------------------------------------------------------------------------
#            Creating Affine Transform Matrix (ATM)
#--------------------------------------------------------------------------
ATM=np.float32([[1.5,0,40],[0,1/1.5,50],[0,0,1]])

#--------------------------------------------------------------------------
#   Warping the image according to the matrix selected and displaying
#--------------------------------------------------------------------------

affine_transformed_image=mf.norm_uint8(warp(input_image,np.linalg.inv(ATM)))
mf.my_imshow(affine_transformed_image ,"(b) Affine image (cropped)",ax[1])
affine_transformed_image=mf.norm_uint8(warp(input_image,np.linalg.inv(ATM),output_shape=(np.int16(rows/1.5+50),np.int16(cols*1.5))))
mf.my_imshow(affine_transformed_image ,"(c) Affine image (un-cropped)",ax[2])

plt.show()
print("Completed Successfully ...")





