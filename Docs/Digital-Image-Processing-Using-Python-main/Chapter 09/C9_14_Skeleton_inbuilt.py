#======================================================================
# PURPOSE : Finding Skeletonized Image
#======================================================================
import cv2
import matplotlib.pyplot as plt
import numpy as np
from skimage.morphology import skeletonize
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

# Import and display the image
input_image=cv2.imread('img31.bmp',0)
fig1,ax1=plt.subplots(1,2)
mf.my_imshow(input_image,'(a) Input Binary Image',ax1[0])

# Find Skeletonized Image and Display
skeletonized_image = 255*skeletonize(input_image>0)
# 'input_image>0' is used to binarize the input image if not already.
mf.my_imshow(np.uint8(skeletonized_image),'(b) Skeletonized Image',ax1[1])

plt.show()
print("Completed Successfully ...")






