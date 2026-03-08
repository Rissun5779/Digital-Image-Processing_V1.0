#======================================================================
# PURPOSE : Learning Morphological Thinning
#======================================================================
import cv2
import matplotlib.pyplot as plt
import numpy as np
import skimage as ski
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

# Import and Display the image
input_image=cv2.imread('img31.bmp',0)
fig1,ax1=plt.subplots(1,3)
mf.my_imshow(input_image,'(a) Input Binary Image',ax1[0])

# Calculate Thinned Image and Display
thin_image = 255*ski.morphology.thin(input_image)
# thin_image = 255*ski.morphology.thin(input_image,max_num_iter=np.Inf)
mf.my_imshow(np.uint8(thin_image),'(b) Thinned Image',ax1[1])

# Find Partially Thinned Image and Display
P_thin_image = 255*ski.morphology.thin(input_image,max_num_iter=15)
mf.my_imshow(np.uint8(P_thin_image),'(c) Partially Thinned Image',ax1[2])

plt.show()
print("Completed Successfully ...")







