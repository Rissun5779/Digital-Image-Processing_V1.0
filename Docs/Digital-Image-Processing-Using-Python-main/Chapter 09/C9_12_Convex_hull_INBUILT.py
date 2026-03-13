#======================================================================
# PURPOSE : Finding Convex Hull using Python's Inbuilt Method.
#======================================================================
import cv2
import matplotlib.pyplot as plt
import numpy as np
import skimage as ski
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

# Import and Display the image
input_image=cv2.imread('img28.bmp',0)
fig1,ax1=plt.subplots(1,3)
mf.my_imshow(input_image,'(a) Input Binary Image',ax1[0])

# Find Convex Hull and Display
convex_hull_image = 255*ski.morphology.convex_hull_image(input_image)
mf.my_imshow(np.uint8(convex_hull_image),'(b) Convex Hull',ax1[1])

# Embed the original set in convex hull and display
convex_hull_image[np.where(input_image>0)]=128
mf.my_imshow(np.uint8(convex_hull_image),'(c) Convex Hull (with Foreground)',ax1[2])

plt.show()
print("Completed Successfully ...")






