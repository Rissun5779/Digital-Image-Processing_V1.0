#======================================================================
# PURPOSE : Illustration of Unsharp Masking & High boost filtering
#======================================================================
import cv2,matplotlib.pyplot as plt, numpy as np
import scipy.ndimage as sci
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

# ---------------------------------------------------------------------
#           IMPORTING IMAGE & DISPLAYING
# ---------------------------------------------------------------------
input_image=cv2.imread('img3.bmp',0)
fig,ax=plt.subplots(2,2)
fig.show()
mf.my_imshow(input_image,'(a) Grayscale Image',ax[0,0])
input_image=np.float32(input_image)

# ---------------------------------------------------------------------
#           GAUSSIAN FILTERING
# ---------------------------------------------------------------------
filtered_image=sci.gaussian_filter(input_image,5)
mf.my_imshow(mf.norm_uint8(filtered_image),"(b) Gaussian Smoothened Image (sigma = 5)",ax[0,1])
difference_image=input_image-filtered_image

# ---------------------------------------------------------------------
#           DIFFERENCE IMAGE
# ---------------------------------------------------------------------
mf.my_imshow(mf.norm_uint8(difference_image),"(c) Difference Image",ax[1,0])
th_difference=255*(difference_image>.1*np.max(difference_image))
mf.my_imshow(np.uint8(th_difference),"(d) Thresholded difference (For better visualization)",ax[1,1])

# ---------------------------------------------------------------------
#           UNSHARP MASKING & HIGH BOOST FILTERING
# ---------------------------------------------------------------------
fig2,ax2=plt.subplots(2,2)
mf.my_imshow(np.uint8(input_image),"(a) Original",ax2[0,0])
mf.my_imshow(np.uint8(input_image+difference_image),"(b) Unsharp Masking (k=1)",ax2[0,1])
mf.my_imshow(np.uint8(input_image+3*difference_image),"(c) High boost filtering (k=3)",ax2[1,0])
mf.my_imshow(np.uint8(input_image+5*difference_image),"(d) High boost filtering (k=5)",ax2[1,1])
fig.show()

plt.show()
print("Completed Successfully ...")


