#======================================================================
# PURPOSE : General Code for frequency domain filtering of images
# This code implements - Lowpass, Highpass, Band stop and Bandpass filtering
# This code will do the above for Ideal, Gaussian and Butterworth filters
#======================================================================
import cv2,matplotlib.pyplot as plt
import numpy as np
import scipy.fft as sfft
import sys
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

#---------------------------------------------------------------------------
#    FUNCTION : Designing IDEAL LOW PASS Filter
#---------------------------------------------------------------------------
def Ideal_LPF(freq_points,fc):
    # Initialising an image with shape equal to fft_input_image with all zeros
    freq_domain_filter=np.zeros((freq_points,freq_points))
    # Creating the LPF in following loop
    for i in np.arange(0,freq_points,1):
        for j in np.arange(0,freq_points,1):
            if np.sqrt((i-freq_points/2)**2+(j-freq_points/2)**2)<fc*freq_points:
                freq_domain_filter[i,j]=1
    return(freq_domain_filter)

#---------------------------------------------------------------------------
#    FUNCTION : Designing GAUSSIAN LOW PASS Filter
#---------------------------------------------------------------------------
def Gauss_LPF(freq_points,fc):
    freq_domain_filter=np.zeros((freq_points,freq_points))
    # Creating 2D freq. grid for Gaussian filter generation in freq. domain
    f_positions_norm=np.linspace(0,freq_points,freq_points)
    fx=f_positions_norm/np.max(f_positions_norm)-0.5
    fy=fx                  # Because we are taking circularly symmetry
    fxx,fyy=np.meshgrid(fx,fy)  # 2 arrays of fx & fy coordinates in 2D
    # Sigma of Gaussian dictated by cutoff frequency fc (half power freq.)
    sigma_c=np.sqrt((fc**2)/(2*np.log(np.sqrt(2))))
    # 2D Gaussian creation
    freq_domain_filter=np.exp(-((fxx**2+fyy**2)/(2*(sigma_c**2))))
    return(freq_domain_filter)

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
input_image=np.float32(cv2.imread('img18.bmp',0))
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

# Select the nature of filter (Low pass Highpass, Band Stop, Band Pass) ...
# ... and the type (Ideal, Gaussian, Butterworth) accoding to  below ...
# the match case ladder below ...
filter_type=12

fc1=.15 # First cutoff (the only cutoff for Lowpass or Highpass filter)
fc2=.25 # Second cutoff (for Band stop and band pass filter)

n=10 # Order of butterworth filter (if used)

#---------------------------------------------------------------------------
#    Designing Required Filter
#---------------------------------------------------------------------------
match filter_type:
    case 1:
        Str='IDEAL Lowpass Filter'
        freq_domain_filter=Ideal_LPF(freq_points,fc1)
    case 2:
        Str='Gaussian Lowpass Filter'
        freq_domain_filter=Gauss_LPF(freq_points,fc1)
    case 3:
        Str='Butterworth Lowpass Filter'
        freq_domain_filter=Butter_LPF(freq_points,fc1,n)
    case 4:
        Str='IDEAL Highpass Filter'
        freq_domain_filter=1-Ideal_LPF(freq_points,fc1)
    case 5:
        Str='GAUSSIAN Highpass Filter'
        freq_domain_filter=1-Gauss_LPF(freq_points,fc1)
    case 6:
        Str='Butterworth Highpass Filter'
        freq_domain_filter=1-Butter_LPF(freq_points,fc1,n)
    case 7:
        Str='IDEAL Band Stop Filter'
        LPF=Ideal_LPF(freq_points,fc1)
        HPF=1-Ideal_LPF(freq_points,fc2)
        freq_domain_filter=(HPF+LPF)-np.min(HPF+LPF)
        freq_domain_filter=(freq_domain_filter)/np.max(freq_domain_filter)
    case 8:
        Str='GAUSSIAN Band Stop Filter'
        LPF=Gauss_LPF(freq_points,fc1)
        HPF=1-Gauss_LPF(freq_points,fc2)
        freq_domain_filter=(HPF+LPF)-np.min(HPF+LPF)
        freq_domain_filter=(freq_domain_filter)/np.max(freq_domain_filter)
    case 9:
        Str='Butterworth Band Stop Filter'
        LPF=Butter_LPF(freq_points,fc1,n)
        HPF=1-Butter_LPF(freq_points,fc2,n)
        freq_domain_filter=(HPF+LPF)-np.min(HPF+LPF)
        freq_domain_filter=(freq_domain_filter)/np.max(freq_domain_filter)
    case 10:
        Str='IDEAL Bandpass Filter'
        LPF=Ideal_LPF(freq_points,fc1)
        HPF=1-Ideal_LPF(freq_points,fc2)
        freq_domain_filter=(HPF+LPF)-np.min(HPF+LPF)
        freq_domain_filter=(freq_domain_filter)/np.max(freq_domain_filter)
        freq_domain_filter=1-(HPF+LPF)
    case 11:
        Str='GAUSSIAN Bandpass Filter'
        LPF=Gauss_LPF(freq_points,fc1)
        HPF=1-Gauss_LPF(freq_points,fc2)    
        freq_domain_filter=(HPF+LPF)-np.min(HPF+LPF)
        freq_domain_filter=(freq_domain_filter)/np.max(freq_domain_filter)
        freq_domain_filter=1-(HPF+LPF)
    case 12:
        Str='Butterworth Bandpass Filter'
        LPF=Butter_LPF(freq_points,fc1,n)
        HPF=1-Butter_LPF(freq_points,fc2,n)
        freq_domain_filter=(HPF+LPF)-np.min(HPF+LPF)
        freq_domain_filter=(freq_domain_filter)/np.max(freq_domain_filter)
        freq_domain_filter=1-(HPF+LPF)
    case _:
        print('select valid input')
        sys.exit()  # To exit the system

#---------------------------------------------------------------------------
#    Plotting the filter response
#---------------------------------------------------------------------------
mf.my_imshow(mf.norm_uint8(freq_domain_filter),"(c) Frequency Domain Filter",ax1[0,2])
ax1[0,2].plot(freq_points-c*freq_domain_filter[np.int16(freq_points/2),:])
ax1[0,2].axis('on')

# Setting the x-ticks as per frequency (f) in range [-.5 to .5]
x_positions=np.linspace(0,freq_points-1,5);
x_labels=x_positions/np.max(x_positions)-0.5
ax1[0,2].set_xticks(x_positions, x_labels)

# Setting the y-ticks as per frequency (f) in range [-.5 to .5]
y_positions=np.linspace(0,freq_points-1,5);
y_labels=y_positions/np.max(y_positions)-0.5
ax1[0,2].set_yticks(y_positions, y_labels)

ax1[0,2].set_xlabel('fx & f axis ->')
ax1[0,2].set_ylabel('fy & amp [0 to 1] axis ->')

fig1.suptitle(Str)

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



















