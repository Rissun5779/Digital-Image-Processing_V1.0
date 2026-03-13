#======================================================================
# PURPOSE : Defining custom package and use it in future
#======================================================================

import cv2, matplotlib.pyplot as plt,numpy as np
import my_package.my_functions as mf # This is a user defined package

# Read the image 
input_image1=cv2.imread('img1.bmp',1)
input_image2=cv2.imread('img2.bmp',0)
# Second argument in above command is 1 for reading image as colored
# and 0 for reading it as grayscale

# Displaying images with Matplotlib
fig1,ax1=plt.subplots(1,2)
fig1.show()

mf.my_imshow(input_image1,"The Gwalior Fort",ax1[0])
mf.my_imshow(input_image2,"The Ganges",ax1[1])
cv2.imwrite("result1.bmp",input_image1)
cv2.imwrite("result2.bmp",input_image2)

plt.show()
print("Completed Successfully ...")




                          
                          
                          
                          
                          
                          
                          

