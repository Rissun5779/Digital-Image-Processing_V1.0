#======================================================================
# PURPOSE : Learning Hit and Miss Transform
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
# Creating a binary image for understanding the concept
#--------------------------------------------------------------------------
Bimg2=np.uint8(255*np.array([\
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], \
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], \
    [0,0,1,1,1,0,0,1,1,1,0,0,1,1,1,0,0], \
    [0,0,0,1,0,0,0,1,1,0,0,0,0,1,0,0,0], \
    [0,0,0,1,0,0,0,0,1,0,0,0,1,1,0,0,0], \
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], \
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]] ))

#--------------------------------------------------------------------------
# Creating structuring element
#--------------------------------------------------------------------------
SE_HITMISS=np.array([\
    [-1,-1,-1,-1,-1], \
    [-1, 1, 1, 1,-1], \
    [-1,-1, 1,-1,-1], \
    [ 0, 0, 1,-1,-1], \
    [-1,-1,-1,-1,-1], ])
# In above SE,     1 is for foreground
#                 -1 is for background
#                  0 is for dont care

result_image=cv2.morphologyEx(Bimg2,cv2.MORPH_HITMISS,SE_HITMISS,anchor=(-1,-1))

#--------------------------------------------------------------------------
#                  Plotting Logic
#--------------------------------------------------------------------------

fig,ax= plt.subplots(2,1)

mf.my_imshow(Bimg2,'(a) Binary Image',ax[0])
plot_pixel_grid_on_image(np.shape(Bimg2),ax[0],Bimg2)

mf.my_imshow(result_image,'(c) Hit and Miss Transform',ax[1])
plot_pixel_grid_on_image(np.shape(result_image),ax[1],result_image)

ax1= fig.add_subplot(1,4,4)
mf.my_imshow(np.uint8(255*(SE_HITMISS>0)+100*(SE_HITMISS==0)),\
             '(b) Structuring Element',ax1)
plot_pixel_grid_on_image(np.shape(SE_HITMISS),ax1,\
              np.uint8(255*(SE_HITMISS>0)+100*(SE_HITMISS==0)))

plt.show()
print("Completed Successfully ...")




