#======================================================================
# PURPOSE : Frequency domain Gaussian Low pass filtering of images
#======================================================================
import cv2,matplotlib.pyplot as plt
import numpy as np
import scipy.fft as sfft
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

#---------------------------------------------------------------------------
#    Importing and displaying image in space domain
#---------------------------------------------------------------------------
input_image=np.float32(cv2.imread('img9.bmp',0))
r,c=np.shape(input_image)
fig1,ax1=plt.subplots(2,3)
fig1.show()
mf.my_imshow(mf.norm_uint8(input_image),'(a) Spatial Domain',ax1[0,0])

#---------------------------------------------------------------------------
#    Image in normalised frequency domain (Magnitude Plot)
#---------------------------------------------------------------------------
freq_points=np.max([r,c])
fft_input_image=sfft.fft2(input_image,[freq_points,freq_points])
mag_image=np.abs(sfft.fftshift(fft_input_image))
mf.my_imshow(mf.norm_uint8(np.log(1+mag_image)),"(b) Frequency Domain (Magnitude)",ax1[0,1])

#---------------------------------------------------------------------------
#    Designing GAUSSIAN LOW PASS Filter
#---------------------------------------------------------------------------
# Initialising an image with shape equal to fft_input_image with all zeros
freq_domain_filter=np.zeros((freq_points,freq_points))
fc=.1 # SET CUTOFF FREQUENCY OF FILTER HERE

# Creating 2D freq. grid for Gaussian filter generation in freq. domain
f_positions_norm=np.linspace(0,freq_points,freq_points)
fx=f_positions_norm/np.max(f_positions_norm)-0.5
fy=fx                  # Because we are taking circularly symmetry
fxx,fyy=np.meshgrid(fx,fy)  # 2 arrays of fx & fy coordinates in 2D

# Sigma of Gaussian dictated by cutoff frequency fc
sigma1=np.sqrt((fc**2)/(2*np.log(np.sqrt(2))))
# 2D Gaussian creation
sigma_x=sigma1
sigma_y=sigma1
Gauss_function=np.exp(-((fxx**2)/(2*(sigma_x**2))+(fyy**2)/(2*(sigma_y**2))))
freq_domain_filter=Gauss_function
mf.my_imshow(mf.norm_uint8(freq_domain_filter),"(c) Frequency Domain Filter",ax1[0,2])

#---------------------------------------------------------------------------
#    Filtering in frequency domain
#---------------------------------------------------------------------------
freq_filtered_image=sfft.fftshift(fft_input_image)*freq_domain_filter
mf.my_imshow(mf.norm_uint8(np.log(1+np.abs(freq_filtered_image))),"(d) Frequency Domain Filtering",ax1[1,0])

#---------------------------------------------------------------------------
#    Image Transformed back in time domain
#---------------------------------------------------------------------------
image_back_in_time=sfft.ifft2(sfft.ifftshift(freq_filtered_image))
mf.my_imshow(mf.norm_uint8(image_back_in_time),'(e) PADDED Spatial Domain',ax1[1,1])

#---------------------------------------------------------------------------
#    Image Transformed back in time domain (displayed without padding)
#---------------------------------------------------------------------------
image_back_in_time=sfft.ifft2(sfft.ifftshift(freq_filtered_image))
mf.my_imshow(mf.norm_uint8(image_back_in_time[0:r,0:c]),'(f) Spatial Domain',ax1[1,2])

plt.show()
print("Completed Successfully ...")


















