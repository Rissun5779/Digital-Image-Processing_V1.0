#======================================================================
# PURPOSE : Learning Image Negative (GLOBAL TRANSFORMATION)
#======================================================================
import cv2,matplotlib.pyplot as plt, numpy as np
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

#--------------------------------------------------------------------------
#                   Image Negatives (Global Transform)
#--------------------------------------------------------------------------
input_image=cv2.imread('img1.bmp',0)
fig,ax=plt.subplots(1,2)
fig.show()
mf.my_imshow(input_image,'(a) Input Image',ax[0])

negative_image=255-input_image;
mf.my_imshow(negative_image,"(b) Negative of the image",ax[1])

plt.show()
print("Completed Successfully ...")




