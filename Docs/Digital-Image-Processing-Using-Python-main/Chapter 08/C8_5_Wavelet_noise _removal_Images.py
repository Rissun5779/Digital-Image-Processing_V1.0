#============================================================================
# PURPOSE : Denoising of Images by Wavelet based MRA
#============================================================================
import cv2
import numpy as np
import matplotlib.pyplot as plt
from skimage.util import random_noise
import pywt
import scipy.ndimage as sci
import my_package.my_functions as mf # This is a user defined package

#-----------------------------------------------------------------------
#         Importing Image and Displaying
#-----------------------------------------------------------------------
img0 = np.float64(cv2.imread('img1.bmp',0))
fig,ax=plt.subplots(2,2)
fig.show()
mf.my_imshow(mf.norm_uint8(img0),"(a) Original Image",ax[0,0])

#-----------------------------------------------------------------------
#       Creating and Adding Gaussian Noise to Image
#-----------------------------------------------------------------------
img =  random_noise(img0/255, mode='Gaussian',mean=0,var=.05)
mf.my_imshow(mf.norm_uint8(img),"(b) Noisy Image",ax[0,1])

#-----------------------------------------------------------------------
#       Performing Decomposition (Wavelet & MRA)
#-----------------------------------------------------------------------
coeffs = pywt.wavedec2(img, 'db2', level=2)
# coeffs are in format of list [cAn, (cHn,cVn,cDn), ... , (cH1,cV1,cD1)]
# Approximation coeff are only given for the last (nth) decomposition level

#-----------------------------------------------------------------------
#       Performing Denoising (Hard Thresholding)
#-----------------------------------------------------------------------
len_list=len(coeffs)
hard_thresh=70/100 # Hard hard_thresholding
for i in np.arange(1,len_list,1):
    cH = coeffs[i][0].copy()
    cV = coeffs[i][1].copy()
    cD = coeffs[i][2].copy()

    cH[np.where(cH<hard_thresh*np.max(cH))] = 0
    cV[np.where(cV<hard_thresh*np.max(cV))] = 0
    cD[np.where(cD<hard_thresh*np.max(cD))] = 0
    coeffs[i] = (cH,cV,cD)

#-----------------------------------------------------------------------
#       Performing Reconstruction (Wavelet & MRA)
#-----------------------------------------------------------------------
reconstructed_image=pywt.waverec2(coeffs, 'db2')
mf.my_imshow(mf.norm_uint8(reconstructed_image),"(c) Denoised by - Wavelet & MRA",ax[1,0])

#-----------------------------------------------------------------------
#       Conventional Denoising by filtering
#-----------------------------------------------------------------------
r,c=np.shape(img)
n=np.int32(.05*r)
filter1=np.ones((n,n))
filter1=filter1/np.sum(filter1)
reconstructed_image2=sci.correlate(img,filter1)
mf.my_imshow(mf.norm_uint8(reconstructed_image2),"(d) Denoised by - Averaging",ax[1,1])

plt.show()
print("Completed Successfully ...")



