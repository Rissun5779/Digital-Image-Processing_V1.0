#======================================================================
# PURPOSE : Interactive filter design
#======================================================================
import cv2,matplotlib.pyplot as plt
import numpy as np
import scipy.fft as sfft
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

#----------------------------------------------------------------------
#    Butterworth Lowpass filter design
#----------------------------------------------------------------------
def Butter_LPF(freq_points,fc,n):
    FREQfilter=np.zeros((freq_points,freq_points))
    # Creating 2D freq. grid for Butterworth filter generation in freq. domain
    f_positions_norm=np.linspace(0,freq_points,freq_points)
    fx=f_positions_norm/np.max(f_positions_norm)-0.5
    fy=fx                  # Because we are taking circularly symmetry
    fxx,fyy=np.meshgrid(fx,fy)  # 2 arrays of fx & fy coordinates in 2D
    # 2D Butterworth creation (fc is already -3db frequency)
    FREQfilter=np.sqrt(1/(1+((np.sqrt(fxx**2+fyy**2))/(fc))**(2*n)))
    return(FREQfilter)

#----------------------------------------------------------------------
#    Importing and displaying image in space domain
#----------------------------------------------------------------------
input_image=np.float32(cv2.imread('img18.bmp',0))
r,c=np.shape(input_image)
fig1,ax1=plt.subplots(2,2)
fig1.show()
# Input Image (spatial domain)
mf.my_imshow(mf.norm_uint8(input_image),'(a) Input',ax1[0,0])
# Output Image (spatial domain- default initialisation)
mf.my_imshow(mf.norm_uint8(input_image),'(b) Output',ax1[0,1])

#----------------------------------------------------------------------
# Designing Patch of Butterworth HPF for Interactive click
#----------------------------------------------------------------------
freq_points=np.max([r,c])
PatchBy2=np.int16(freq_points/10)
patch=2*PatchBy2
patch_filter=1-Butter_LPF(patch,.2,5)

#----------------------------------------------------------------------
# Image in normalised frequency domain (Magnitude Plot)
#----------------------------------------------------------------------
FFTimg=sfft.fft2(input_image,[freq_points,freq_points])
MAGimg=np.abs(sfft.fftshift(FFTimg))
# Input Image (frequency domain)
mf.my_imshow(mf.norm_uint8(np.log(1+MAGimg[PatchBy2:(freq_points-PatchBy2),PatchBy2:(freq_points-PatchBy2)])),"(c) Input (Mag)",ax1[1,0])
# Output Image (frequency domain- default initialisation)
mf.my_imshow(mf.norm_uint8(np.log(1+MAGimg[PatchBy2:(freq_points-PatchBy2),PatchBy2:(freq_points-PatchBy2)])),"(d) Output (Mag)",ax1[1,1])


#----------------------------------------------------------------------
#    Designing interactive filter
#----------------------------------------------------------------------
# Frequency domain filter
FREQfilter=np.ones((freq_points,freq_points))

# Infinite Loop for creating interactive filter
# and editing the response in realtime
while(True):
    # Getting the coordinates of mouse
    src=np.int32(np.asarray(plt.ginput(1)))
    # Calculating top left (row) and top left (column) corner coordinates
    TLC_c=np.int16(src[0,0]-patch/2)+PatchBy2 # Top left corner (column)
    TLC_r=np.int16(src[0,1]-patch/2)+PatchBy2 # Top left corner (row)

    # Replacing the patch in default initialised frequency domain filter by
    # patch created above according to the interactive mouse coordinates
    FREQfilter[TLC_r:(TLC_r+patch),TLC_c:(TLC_c+patch)]=FREQfilter[TLC_r:(TLC_r+patch),TLC_c:(TLC_c+patch)]*patch_filter
    MAGimg[TLC_r:(TLC_r+patch),TLC_c:(TLC_c+patch)]=MAGimg[TLC_r:(TLC_r+patch),TLC_c:(TLC_c+patch)]*patch_filter
    mf.my_imshow(mf.norm_uint8(np.log(1+MAGimg[PatchBy2:(freq_points-PatchBy2),PatchBy2:(freq_points-PatchBy2)])),"(d) Output (Mag)",ax1[1,1])
    
    #------------------------------------------------------------------
    # Filtering in frequency domain
    #------------------------------------------------------------------
    freq_filtered_image=sfft.fftshift(FFTimg)*FREQfilter

    #------------------------------------------------------------------
    # Image Transformed back in time domain (displayed without padding)
    #------------------------------------------------------------------
    image_back_in_time=sfft.ifft2(sfft.ifftshift(freq_filtered_image))
    mf.my_imshow(mf.norm_uint8(image_back_in_time[0:r,0:c]),'(b) Output',ax1[0,1])

plt.show()
print("Completed Successfully ...")
