#======================================================================
# PURPOSE : Learning EROSION operation
#======================================================================
import cv2
import matplotlib.pyplot as plt
import numpy as np
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

#--------------------------------------------------------------------------
# Defining Custom function to annotate the plots (not necessary once we
# understand the concept)
#--------------------------------------------------------------------------

# Function for plotting grid lines over pixels of image and pixel numbering
def plot_pixel_grid_on_image(req_size,ax,img):
    req_size_x=req_size[1]+1
    req_size_y=req_size[0]+1

#------------------ For grid lines on image -------------------------------
    for i in np.arange(0,req_size_x,1):
        ax.plot(i*np.ones(req_size_y)-.5,np.arange(0,req_size_y,1)-.5,color='.5')
    for i in np.arange(0,req_size_y,1):
        ax.plot(np.arange(0,req_size_x,1)-.5,i*np.ones(req_size_x)-.5,color='.5')
        # In the above, color can be set as grayscale value between 0 to 1 also
        
#------------------ For pixel numbering -----------------------------------
    for i in np.arange(0,req_size_x-1,1):
        for j in np.arange(0,req_size_y-1,1):
            if img[j,i]==0:
                # White text on black background
                ax.text(i-.25,j+.25,str(i+(req_size_y-2)*i+j),color='1',fontsize=8)
            else:
                # Black text on white (or any non-zero gray) background
                ax.text(i-.25,j+.25,str(i+(req_size_y-2)*i+j),color='0',fontsize=8)

#--------------------------------------------------------------------------
# Creating a binary image for understanding the concept (This could be
# replaced by a binary image instead when working with real images)
#--------------------------------------------------------------------------
Bimg1=np.uint8(255*np.array([\
    [0,0,0,0,0,0,0,0,0,0,0], \
    [0,0,0,0,0,0,0,0,0,0,0], \
    [0,0,0,0,0,0,0,0,0,0,0], \
    [0,0,0,1,1,1,1,1,0,0,0], \
    [0,0,1,1,1,1,1,1,1,0,0], \
    [0,0,1,1,1,1,1,1,1,0,0], \
    [0,0,1,1,1,1,1,1,1,0,0], \
    [0,0,0,1,1,1,1,1,0,0,0], \
    [0,0,0,0,0,0,0,0,0,0,0], \
    [0,0,0,0,0,0,0,0,0,0,0], \
    [0,0,0,0,0,0,0,0,0,0,0]] ))

#--------------------------------------------------------------------------
# Creating structuring elements (SE) for performing morphological operations
#--------------------------------------------------------------------------
SE=np.uint8(255*np.array([\
    [1,1,0], \
    [1,1,0], \
    [0,1,1], ]))

result_image = cv2.erode(Bimg1,SE,iterations = 1,anchor=(-1,-1))
    
#--------------------------------------------------------------------------
#                  Plotting Logic
#--------------------------------------------------------------------------
fig = plt.figure()
ax1= fig.add_subplot(1,3,1)
ax2= fig.add_subplot(3,7,11)
ax3= fig.add_subplot(1,3,3)

mf.my_imshow(Bimg1,'(a) Binary Image',ax1)
plot_pixel_grid_on_image(np.shape(Bimg1),ax1,Bimg1)

mf.my_imshow(SE,'(b) Structuring Element',ax2)
plot_pixel_grid_on_image(np.shape(SE),ax2,SE)

mf.my_imshow(result_image,'(c) '+'Erosion',ax3)
plot_pixel_grid_on_image(np.shape(result_image),ax3,result_image)

plt.show()
print("Completed Successfully ...")





