#======================================================================
# PURPOSE : Learning Projective Transformation on images (INTERACTIVE)
#======================================================================
import numpy as np
import cv2
import matplotlib.pyplot as plt
from skimage import transform as tf
from skimage.transform import warp # For warping the image by transform matrix
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

#--------------------------------------------------------------------------
#                    Importing the image
#--------------------------------------------------------------------------
input_image=cv2.imread('img8.bmp',0)
rows, cols = input_image.shape
fig,ax=plt.subplots(1,2)
fig.show()
mf.my_imshow(input_image,"(a) Input Grayscale Image",ax[0])
ax[0].axis("on")

#--------------------------------------------------------------------------
#        Taking the input of source points from user
#--------------------------------------------------------------------------
src=np.asarray(plt.ginput(1))                     # Src Pt 1 (I/p from user)
ax[0].plot(src[0,0],src[0,1],'r.',markersize=10)
src=np.vstack((src,np.asarray(plt.ginput(1))))    # Src Pt 2 (I/p from user)
ax[0].plot(src[1,0],src[1,1],'r.',markersize=10)
src=np.vstack((src,np.asarray(plt.ginput(1))))    # Src Pt 3 (I/p from user)
ax[0].plot(src[2,0],src[2,1],'r.',markersize=10)
src=np.vstack((src,np.asarray(plt.ginput(1))))    # Src Pt 4 (I/p from user)
ax[0].plot(src[3,0],src[3,1],'r.',markersize=10)

#--------------------------------------------------------------------------
#        Fixed destination points
#--------------------------------------------------------------------------
dst=np.float32([ [0,0],          # Corresponding Target Point 1
                 [0,rows],       # Corresponding Target Point 2
                 [cols,rows],    # Corresponding Target Point 3
                 [cols,0] ])     # Corresponding Target Point 4

#--------------------------------------------------------------------------
#      Deducing the transformation matrix from corresponding points
#--------------------------------------------------------------------------
trans_matrix = tf.estimate_transform('projective', src, dst)

#--------------------------------------------------------------------------
#               Applying projective transformation
#--------------------------------------------------------------------------
projective_transformed_image=mf.norm_uint8(warp(input_image,np.linalg.inv(trans_matrix),output_shape=(np.int16(rows*1),np.int16(cols*1))))
mf.my_imshow(projective_transformed_image ,"(b) Projective Transformed Image",ax[1])

#--------------------------------------------------------------------------
#               Plotting Logic
#--------------------------------------------------------------------------
ax[1].axis("on")
ax[1].plot(dst[:,0],dst[:,1],'r.',markersize=20)

plt.show()
print("Completed Successfully ... ")

