#======================================================================
# PURPOSE : Learning Hole Filling Algorithm
#======================================================================
import cv2
import matplotlib.pyplot as plt
import numpy as np
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

I=cv2.imread('img26.bmp',0) # INPUT IMAGE
r,c=np.shape(I)
SE=np.uint8(np.array([[0,1,0],\
                      [1,1,1],\
                      [0,1,0]])) # SE FOR HOLE FILLING

# Take input from user (inside the hole to be filled)
fig,ax=plt.subplots(1,2)
mf.my_imshow(I,'(a) Input Binary Image',ax[0])
mf.my_imshow(I,'(b) Input Binary Image',ax[1])
src=np.int16(np.asarray(plt.ginput(1))) # Src Pt (I/p from user)
ax[0].plot(src[0,0],src[0,1],'r.',markersize=10)

# INTERMEDIATE DILATION IMAGE AT kth ITERATION
D=np.uint8(np.zeros((r,c)))
D[src[0,1],src[0,0]]=255 # Mark the pixel as inputed by user

# INTERMEDIATE DILATION IMAGE AT (k-1)th ITERATION
D_prev=np.zeros((r,c)) # D(k-1)
I_comp=np.uint8(255*(I==0))

while 1:
    D=np.uint8(cv2.dilate(D,SE,iterations = 1))
    D=np.uint8(1*np.logical_and(D,I_comp))  
    if np.sum(1*np.logical_xor(D_prev,D))==0:
        break # break if D(k)=D(k-1)
    D_prev=np.uint8(D.copy())

hole_filled_image=np.uint8(1*np.logical_or(D,I))
mf.my_imshow(np.uint8(255*hole_filled_image),'(b) Hole filled',ax[1])

plt.show()
print("Completed Successfully ...")





