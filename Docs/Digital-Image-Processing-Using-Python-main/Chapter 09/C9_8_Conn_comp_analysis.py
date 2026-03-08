#======================================================================
# PURPOSE : Learning Connected Component Analysis
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
def plot_pixel_grid_on_image(req_size,ax,img,pass0):
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
                ax.text(i-.25,j+.25,str(pass0[j,i]),color='1',fontsize=8)
            else:
                # Black text on white (or any non-zero gray) background
                ax.text(i-.25,j+.25,str(pass0[j,i]),color='0',fontsize=8)

#--------------------------------------------------------------------------
# Creating a binary image for understanding the concept (This could be
# replaced by a binary image instead when working with real images)
#--------------------------------------------------------------------------
I=np.uint8(255*np.array([\
    [0,0,0,0,0,0,0,0,0,0,1,1,1], \
    [0,0,1,0,0,0,0,0,1,0,0,1,1], \
    [0,1,1,0,1,0,1,1,0,0,0,0,0], \
    [0,0,0,1,0,0,0,1,0,1,1,1,0], \
    [0,0,0,0,0,0,0,0,0,1,0,1,0], \
    [0,1,0,1,0,0,1,0,0,1,0,1,0], \
    [0,0,1,0,0,1,1,1,0,0,1,0,0], \
    [0,1,0,1,0,0,1,0,0,0,0,0,1], \
    [0,0,0,0,0,0,0,0,0,0,1,0,1], \
    [0,0,0,0,0,0,0,0,0,0,1,1,1]] ))

# Creating zero padded image
I2=cv2.copyMakeBorder(I,1,1,1,1,cv2.BORDER_CONSTANT,value=0)
r,c=np.shape(I)

#--------------------------------------------------------------------
#                     PASS 1
#--------------------------------------------------------------------
next_label=1 # variable for creation of new labels
equ_list=[] # Equivalent labels list

pass1=np.zeros((r+2,c+2))
for i in np.arange(0,r+2,1):
    for j in np.arange(0,c+2,1):
        if I2[i,j]==255:
            arr=np.sort(np.array([pass1[i-1,j-1],pass1[i-1,j],\
                                  pass1[i-1,j+1],pass1[i,j-1]]),0)
            if (np.sum(arr)==0): # If all processed pixels are background
                pass1[i,j]=next_label
                next_label=next_label+1
            else: # If all processed pixels are background
                arr=np.delete(arr,np.where(arr==0))     
                pass1[i,j]=arr[0]
                if (len(np.unique(arr))!=1):
                    equ_list.append(arr.tolist())
                    
pass1=np.int16(pass1)
fig,ax=plt.subplots(1,2)
mf.my_imshow(I2,'(a) PASS 1',ax[0])
plot_pixel_grid_on_image(np.shape(I2),ax[0],I2,pass1)

#--------------------------------------------------------------------
#             Equivalent labels list management logic
#--------------------------------------------------------------------
len_list=len(equ_list)
dummy_arr=np.zeros((len_list,2))
for i in np.arange((len_list-1),-1,-1):
    dummy_arr[i,0]=i
    dummy_arr[i,1]=equ_list[i][0]
dummy_arr=dummy_arr[dummy_arr[:,1].argsort()]

#--------------------------------------------------------------------
#                     PASS 2
#--------------------------------------------------------------------
pass2=pass1.copy()
for i in np.arange(len_list-1,-1,-1):
    len_sub_list=len(equ_list[i])
    for j in np.arange(1,len_sub_list,1):
        pass2[np.where(pass2==equ_list[i][j])]=equ_list[i][0]

mf.my_imshow(I2,'(b) PASS 2',ax[1])
plot_pixel_grid_on_image(np.shape(I2),ax[1],I2,pass2)

plt.show()
print("Completed Successfully ...")









