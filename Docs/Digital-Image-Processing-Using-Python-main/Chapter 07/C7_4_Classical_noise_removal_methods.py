#======================================================================
# PURPOSE : Learning Classical Noise Removal Methods
#======================================================================
import cv2,matplotlib.pyplot as plt, numpy as np
from skimage.util import random_noise
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

#----------------------------------------------------------------------
#   Importing and normalising the image to the range [0,1]
#----------------------------------------------------------------------
input_img=np.float64(cv2.imread('img20.bmp',0))
img=input_img/255
# Pixel values above are normalised to range 0 to 1
# This is the requirement of 'random_noise' function imported above

#----------------------------------------------------------------------
#      Choosing noise to be added and adding noise
#----------------------------------------------------------------------
method_name='Gaussian'
noisy_img = random_noise(img, mode='Gaussian',mean=0,var=.01,clip=False)
# clip=False in above line because if it were true, the noise will be
# a mixture of Gaussian and Salt-and-Pepper Noise
noisy_img=mf.norm_uint8(noisy_img)
noisy_img[np.where(noisy_img==0)]=1
noisy_img=np.float64(noisy_img)

#----------------------------------------------------------------------
#      Choosing the neighborhood size for processing
#----------------------------------------------------------------------
filter_size=3 # Keep this odd
half_filter_size=(filter_size-1)/2

#----------------------------------------------------------------------
#      Arithmetic Mean Filtering
#----------------------------------------------------------------------
output_img_Arithmetic=np.float64(np.zeros_like(input_img))
# Above is an array of same size as input_img filled with all zeros
r,c=np.shape(output_img_Arithmetic)
for i in np.arange(half_filter_size,r-half_filter_size,1):
    for j in np.arange(half_filter_size,c-half_filter_size,1):
        output_img_Arithmetic[np.int16(i),np.int16(j)]=np.average(\
        noisy_img[np.int16(i-half_filter_size):\
        np.int16(i+half_filter_size+1),\
        np.int16(j-half_filter_size):\
        np.int16(j+half_filter_size+1)])
        
#----------------------------------------------------------------------
#      Geometric Mean Filtering
#----------------------------------------------------------------------
output_img_Geometric=np.float64(np.zeros_like(input_img)) # array of same size as input_img
# filled with all zeros
r,c=np.shape(output_img_Geometric)
for i in np.arange(half_filter_size,r-half_filter_size,1):
    for j in np.arange(half_filter_size,c-half_filter_size,1):
        output_img_Geometric[np.int16(i),np.int16(j)]=np.prod(\
        noisy_img[np.int16(i-half_filter_size):\
        np.int16(i+half_filter_size+1),\
        np.int16(j-half_filter_size):\
        np.int16(j+half_filter_size+1)])
output_img_Geometric=np.power(output_img_Geometric,1/(filter_size**2))

#----------------------------------------------------------------------
#      Harmonic Mean Filtering
#----------------------------------------------------------------------
output_img_Harmonic=np.float32(np.zeros_like(input_img)) # array of same size as input_img
# filled with all zeros
r,c=np.shape(output_img_Harmonic)
for i in np.arange(half_filter_size,r-half_filter_size,1):
    for j in np.arange(half_filter_size,c-half_filter_size,1):
        output_img_Harmonic[np.int16(i),np.int16(j)]=np.sum(\
        1/noisy_img[np.int16(i-half_filter_size):\
        np.int16(i+half_filter_size+1),\
        np.int16(j-half_filter_size):\
        np.int16(j+half_filter_size+1)])
output_img_Harmonic[np.where(output_img_Harmonic==0)]=1
output_img_Harmonic=(filter_size**2)/output_img_Harmonic

#----------------------------------------------------------------------
#      Contraharmonic Mean Filtering
#----------------------------------------------------------------------
Q=5 # Order of contraharmonic filter
output_img_Contraharmonic=np.zeros_like(input_img) # array of same size as input_img
# filled with all zeros
r,c=np.shape(output_img_Contraharmonic)
noisy_img=np.float32(noisy_img)
for i in np.arange(half_filter_size,r-half_filter_size,1):
    for j in np.arange(half_filter_size,c-half_filter_size,1):
        output_img_Contraharmonic[np.int16(i),np.int16(j)]=np.sum(\
        np.power(noisy_img[np.int16(i-half_filter_size):\
        np.int16(i+half_filter_size+1),\
        np.int16(j-half_filter_size):\
        np.int16(j+half_filter_size+1)],Q+1))/\
        np.sum(\
        np.power(noisy_img[np.int16(i-half_filter_size):\
        np.int16(i+half_filter_size+1),\
        np.int16(j-half_filter_size):\
        np.int16(j+half_filter_size+1)],Q))
#----------------------------------------------------------------------
#      Displaying the results
#----------------------------------------------------------------------
fig,ax=plt.subplots(2,3)
fig.show()
mf.my_imshow(mf.norm_uint8(input_img),'(a) Grayscale image',ax[0,0])
mf.my_imshow(mf.norm_uint8(noisy_img),'(b) Noisy image ('+str(method_name)+')',ax[0,1])
mf.my_imshow(mf.norm_uint8(output_img_Arithmetic),'(c) Arithmetic mean filtered',ax[0,2])
mf.my_imshow(mf.norm_uint8(output_img_Geometric),'(d) Geometric mean filtered',ax[1,0])
mf.my_imshow(mf.norm_uint8(output_img_Harmonic),'(e) Harmonic mean filtered',ax[1,1])
mf.my_imshow(mf.norm_uint8(output_img_Contraharmonic),'(f) Contraharmonic mean filtered',ax[1,2])

plt.show()
print("Completed Successfully ...")


