#===========================================================================
# PURPOSE : Learning Connected Component Analysis using inbuilt functions
#===========================================================================
import cv2
import matplotlib.pyplot as plt
import numpy as np
import skimage as ski
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

# Import and Display the image
input_image=cv2.imread('img30.bmp',0)
fig1,ax1=plt.subplots(1,2)
mf.my_imshow(input_image,'(a) Input Binary Image',ax1[0])

# Find all labels, print unique labels and display as image
label_img = ski.measure.label(input_image, background=0)
print("Unique labels generated are ... ",np.unique(label_img))
mf.my_imshow(mf.norm_uint8(label_img),'(b) Labelled Image',ax1[1])

# Finding properties of objects in image
comp_props=ski.measure.regionprops(label_img)

# Printing some of all the available properties of connected components
for i in np.arange(0,np.max(label_img),1):
    print("Area, Centroid and Eccentricity of object with label ",str(i+1),"are ...")
    print(comp_props[i].area,comp_props[i].centroid,comp_props[i].eccentricity)

plt.show()
print("Completed Successfully ...")