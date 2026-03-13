#======================================================================
# PURPOSE : Learning Homomorphic Filtering
#======================================================================
import cv2,matplotlib.pyplot as plt
import numpy as np
import scipy.fft as sfft
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

#---------------------------------------------------------------------------
#    FUNCTION : Designing BUTTERWORTH LOW PASS Filter
#---------------------------------------------------------------------------
def Butter_LPF(freq_points,fc,n):
    freq_domain_filter=np.zeros((freq_points,freq_points))
    # Creating 2D freq. grid for Butterworth filter generation in freq. domain
    f_positions_norm=np.linspace(0,freq_points,freq_points)
    fx=f_positions_norm/np.max(f_positions_norm)-0.5
    fy=fx                  # Because we are taking circularly symmetry
    fxx,fyy=np.meshgrid(fx,fy)  # 2 arrays of fx & fy coordinates in 2D
    # 2D Butterworth creation (fc is already -3db frequency)
    freq_domain_filter=np.sqrt(1/(1+((np.sqrt(fxx**2+fyy**2))/(fc))**(2*n)))
    return(freq_domain_filter)

#---------------------------------------------------------------------------
#    Importing and displaying image in space domain
#---------------------------------------------------------------------------
input_image=np.float32(cv2.imread('img5.bmp',0))
r,c=np.shape(input_image)
fig1,ax1=plt.subplots(3,1)
fig1.show()
mf.my_imshow(mf.norm_uint8(input_image),'(a) Input Image',ax1[0])
input_image=np.log(1+input_image)
# Although we need the logarithm of the input image but instead, in the above line,
# we use (1+input_image) because log(0) is -Inf and since uint8 images have range
# from 0-255, we change it to 1-256 for intermediate computations, later
# mf.norm_uint8 function will bring them to 0-255 range after processing

#---------------------------------------------------------------------------
#    Bring the log image into frequency domain
#---------------------------------------------------------------------------
freq_points=np.max([r,c])
fft_input_image=sfft.fft2(input_image,[freq_points,freq_points])

#---------------------------------------------------------------------------
#    Designing LPF for illumination enhancement & Filtering
#---------------------------------------------------------------------------
fc1=.05 # Cutoff Frequency of LPF
n1=10 # Order of Butterworth LPF
freq_domain_filter_LPF=.01*Butter_LPF(freq_points,fc1,n1)
# Butterworth filter gain (.01) in above line is explained in text
freq_filtered_image_LPF=sfft.fftshift(fft_input_image)*freq_domain_filter_LPF

#---------------------------------------------------------------------------
#    Designing HPF for contrast enhancement & Filtering
#---------------------------------------------------------------------------
fc2=.0000001 # Cutoff Frequency of HPF
n2=10 # Order of Butterworth HPF
freq_domain_filter_HPF=1-Butter_LPF(freq_points,fc2,n2)
freq_filtered_image_HPF=sfft.fftshift(fft_input_image)*freq_domain_filter_HPF

#---------------------------------------------------------------------------
#    Image Transformed back in time domain (displayed without zero padding)
#---------------------------------------------------------------------------
image_back_in_time_LPF=np.exp(sfft.ifft2(sfft.ifftshift(freq_filtered_image_LPF)))
# exponential function in above line is used to remove the effect of logarithm
mf.my_imshow(mf.norm_uint8(image_back_in_time_LPF[0:r,0:c]),'(b) Illumination enhanced',ax1[1])

image_back_in_time_HPF=np.exp(sfft.ifft2(sfft.ifftshift(freq_filtered_image_HPF)))
# exponential function in above line is used to remove the effect of logarithm
mf.my_imshow(mf.norm_uint8(np.log(1+image_back_in_time_HPF[0:r,0:c])),'(c) Contrast enhanced',ax1[2])

plt.show()
print("Completed Successfully ...")























