#======================================================================
# PURPOSE : Display images the matplotlib way
#======================================================================
import cv2, matplotlib.pyplot as plt,numpy as np

# Read the image in OpenCV way
input_image1=cv2.imread('img1.bmp',1)
input_image2=cv2.imread('img2.bmp',0)
# Second argument in above command is 1 for reading image as colored
# and 0 for reading it as grayscale

# Displaying images with Matplotlib
fig1,ax=plt.subplots(1,2)
fig1.show()

plt.subplot(1,2,1)
plt.imshow(cv2.cvtColor(input_image1, cv2.COLOR_BGR2RGB))
plt.axis('off')
plt.gca().set_title("Gwalior Fort (Colored Image)")

plt.subplot(1,2,2)
plt.imshow(cv2.cvtColor(input_image2, cv2.COLOR_BGR2RGB))
plt.axis("off")
plt.gca().set_title('River Ganga (Grayscale image)')

cv2.imwrite("result1.bmp",input_image1)
cv2.imwrite("result2.bmp",input_image2)

plt.show()
print("Completed Successfully ...")



                          
                          
                          
                          
                          
                          
                          
