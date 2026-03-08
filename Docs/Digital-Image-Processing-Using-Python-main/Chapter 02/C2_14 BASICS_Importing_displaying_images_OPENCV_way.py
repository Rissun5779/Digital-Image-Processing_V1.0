#======================================================================
# PURPOSE : Import/Displaying Images in OPENCV's Default way
#======================================================================
import cv2

# Read the image 
input_image1=cv2.imread('img1.bmp',1)
input_image2=cv2.imread('img2.bmp',0)
# Second argument in above command is 1 for reading image as colored
# and 0 for reading it as grayscale

# Display the image
cv2.imshow('First Image',input_image1)
cv2.waitKey(2000)     # Put time in milliseconds here
cv2.destroyAllWindows()

cv2.imshow('Second Image',input_image2)
cv2.waitKey(0)        # For 0, python waits for keypress
cv2.destroyAllWindows()

# Print shape of image
a1=input_image1.shape;
a2=input_image2.shape;
print('The shape of image is 1 ... ',a1,'\nThe shape of image is 2 ... ',a2)

print("Completed Successfully ...")

                          
                          
                          
                          
                          
                          
                          