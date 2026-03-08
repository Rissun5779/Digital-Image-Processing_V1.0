#======================================================================
# PURPOSE : Learning Morphological Opening & Closing
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
                ax.text(i-.25,j+.25,str(i+(req_size_y-2)*i+j),color='1',fontsize=8)
            else:
                ax.text(i-.25,j+.25,str(i+(req_size_y-2)*i+j),color='0',fontsize=8)
#--------------------------------------------------------------------------
# Creating some binary images for understanding the concepts
#--------------------------------------------------------------------------
Bimg1=np.uint8(255*np.array([\
    [0,0,0,0,0,0,0,0,0,0,0,0], \
    [0,0,0,0,0,0,0,0,0,0,0,0], \
    [0,0,0,1,1,0,0,0,1,0,0,0], \
    [0,0,1,1,1,1,1,1,1,1,0,0], \
    [0,0,0,1,1,0,0,0,1,0,0,0], \
    [0,0,0,1,0,0,0,0,0,0,0,0], \
    [0,0,0,1,1,0,0,1,0,0,0,0], \
    [0,0,0,0,0,1,1,0,0,0,0,0], \
    [0,0,0,0,0,0,0,0,0,0,0,0], \
    [0,0,0,0,0,0,0,0,0,0,0,0]] ))

#--------------------------------------------------------------------------
# Creating structuring element (SE) for performing morphological operations
#--------------------------------------------------------------------------
SE=np.uint8(255*np.array([\
    [0,1,1], \
    [1,1,1], \
    [0,1,0], ]))

result_image_E = cv2.erode(Bimg1,SE,iterations = 1,anchor=(-1,-1))
result_image_D = cv2.dilate(Bimg1,SE,iterations = 1,anchor=(-1,-1))
result_image_O = cv2.morphologyEx(Bimg1,cv2.MORPH_OPEN,SE,anchor=(-1,-1))
result_image_C = cv2.morphologyEx(Bimg1,cv2.MORPH_CLOSE,SE,anchor=(-1,-1))
        
#--------------------------------------------------------------------------
#                  Plotting Logic
#--------------------------------------------------------------------------
fig,ax=plt.subplots(2,3)

mf.my_imshow(Bimg1,'(a) Binary Image',ax[0,0])
plot_pixel_grid_on_image(np.shape(Bimg1),ax[0,0],Bimg1)

mf.my_imshow(result_image_E,'(b) '+'Erosion',ax[0,1])
plot_pixel_grid_on_image(np.shape(result_image_E),ax[0,1],result_image_E)

mf.my_imshow(result_image_D,'(c) '+'Dilation',ax[0,2])
plot_pixel_grid_on_image(np.shape(result_image_E),ax[0,2],result_image_D)

mf.my_imshow(SE,'(d) Structuring Element',ax[1,0])
plot_pixel_grid_on_image(np.shape(SE),ax[1,0],SE)

mf.my_imshow(result_image_O,'(e) '+'Opening',ax[1,1])
plot_pixel_grid_on_image(np.shape(result_image_O),ax[1,1],result_image_O)

mf.my_imshow(result_image_C,'(f) '+'Closing',ax[1,2])
plot_pixel_grid_on_image(np.shape(result_image_O),ax[1,2],result_image_C)

plt.show()
print("Completed Successfully ...")




