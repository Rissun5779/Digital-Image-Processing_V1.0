#======================================================================
# PURPOSE : Playing with pixel and some good practices to remember
#======================================================================
import cv2
import matplotlib.pyplot as plt
import numpy as np
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

# Loading the input image as colored image
input_image=cv2.imread('img1.bmp')
mf.my_imshow(input_image,"Input Image (Colored)")

# Converting the colored image to grayscale
grayscale_image=cv2.cvtColor(input_image, cv2.COLOR_BGR2GRAY)
fig1,ax1=plt.subplots(3,2)
fig1.show()
mf.my_imshow(grayscale_image,'(a). Grayscale Image',ax1[0,0])

# Calculating the shape, size, dtype parameters for both images
print("Shape parameters for colored image are ...",input_image.shape)
print("Size parameter for colored image is ...",input_image.size)
print("Data Type for colored image is ...",input_image.dtype)

print("Shape parameters of grayscale image are ...",grayscale_image.shape)
print("Size parameter of grayscale image is ...",grayscale_image.size)
print("Data Type of grayscale image is ...",grayscale_image.dtype)

# Accessing a patch of grayscale image
b=grayscale_image[50:150,50:150];    # Remember this is a view NOT a copy
mf.my_imshow(b,'(b). Grayscale Image\'s patch',ax1[0,1])

# Demo - Changing values in view changes original data
b[:,:]=0
mf.my_imshow(grayscale_image,'(c). After changing values in view',ax1[1,0])

# Demo - Creating a copy
grayscale_image=cv2.cvtColor(input_image, cv2.COLOR_BGR2GRAY)
mf.my_imshow(grayscale_image,'(d). Grayscale Image (Converted again)',ax1[1,1])
b=grayscale_image[50:150,50:150].copy(); # Way to copy a patch into another array
b[:,:]=0
mf.my_imshow(grayscale_image,'(e). After changing values in copied array',ax1[2,0])

# Zero Padding
grayscale_image2=cv2.copyMakeBorder(grayscale_image,0,100,200,300,cv2.BORDER_CONSTANT,value=0)
mf.my_imshow(grayscale_image2,"(f). Border Padded Image with zeros",ax1[2,1])

# Conversion to float32 or float64 for manipulation
img=grayscale_image.astype(np.float64)
print("\nData type of the image is now ...",img.dtype)
img=grayscale_image.astype(np.uint8)

# dtype conversion issues
print("\nData type conversion issues - ")
print("This is 5 in uint8 format",np.uint8(5))
print("This is 5.8 in uint8 format",np.uint8(5.8))
print("This is [-3, -2, -1, 0, 1, 2, 254, 255, 256, 257, 258] in uint8 format\n",np.uint8([-3, -2, -1, 0, 1, 2, 254, 255, 256, 257, 258]))

x=np.uint8([250])
y=np.uint8([7])
print("\nSum in NUMPY way is ...",x+y) # Modulo 256 addition
print("Sum in OPEN CV way is ...",cv2.add(x,y)) # Saturation

plt.show()
print("Completed Successfully ...")

