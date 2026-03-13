#======================================================================
# PURPOSE : Adding noise of various distributions to the image [PART 1]
#======================================================================
import cv2,matplotlib.pyplot as plt, numpy as np
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

#----------------------------------------------------------------------
#       Importing image
#----------------------------------------------------------------------
img=np.float32(cv2.imread('img2.bmp',0))
r,c=np.shape(img)

#----------------------------------------------------------------------
#       Choosing noise to be added
#----------------------------------------------------------------------
select_noise_distribution=4 # (CHOOSE NOISE DISTRIBUTION HERE)
# note that zero mean noise distribution is assumed wherever applicable
match(select_noise_distribution):
    case 1:
        method_name='Gaussian Noise'
        mu=0        # Mean of the Gaussian (keep it 0)
        sigma=60    # standard deviation of the Gaussian
        syn_noise=np.random.normal(mu, sigma, [r,c])
    case 2:
        method_name='Rayleigh'
        mode=50 # Most occouring value in Rayleigh distribution
        syn_noise=np.random.rayleigh(mode, [r,c])
    case 3:
        method_name='Erlang (Gamma)'
        shape=5 # Controls shape of Gamma distribution (must be +ve)
        scale=15 # Controls spread of distribution
        syn_noise=np.random.gamma(shape, scale, [r,c])
    case 4:
        method_name='Exponential'
        scale=50
        syn_noise=np.random.exponential(scale, [r,c])
    case 5:
        method_name='Uniform'
        low_lim=50
        high_lim=150
        syn_noise=np.random.uniform(low_lim, high_lim, [r,c])
syn_noise2=syn_noise.copy() # Storing a copy of noise for later use        
#----------------------------------------------------------------------
# Trimming the noise pixel values outside 0-255 range for display only
#----------------------------------------------------------------------
syn_noise[syn_noise>255]=255       # To clip noise values above 255
syn_noise[syn_noise<0]=0           # To clip noise values below zero
syn_noise=np.uint8(syn_noise)      # not mf.norm_uint8 because that will
                                   # stretch max value to 255
fig,ax=plt.subplots(2,2)
fig.show()
mf.my_imshow(mf.norm_uint8(img),'(a) Grayscale Image',ax[0,0])
mf.my_imshow(syn_noise+30,'(b) '+method_name+' (bias of 30)',ax[0,1])
# syn_noise+30 in above line because otherwise noise will be 
# added to black image and hence will not be clearly visible
# this is for display purposes only

#----------------------------------------------------------------------
#  Plotting normalized histogram of noise distribution
#----------------------------------------------------------------------
no_of_bins=256 # This defines the total no. of points on X axis of histogram
X_axis=255*np.arange(0,no_of_bins,1)/(no_of_bins-1)
# Corresponding values on Y axis
hist_values=cv2.calcHist([syn_noise],[0],None,[no_of_bins],[0,256]) 

normalised_hist=hist_values/(r*c)
ax[1,0].plot(X_axis[1:255],normalised_hist[1:255])
# above is a probability density function
ax[1,0].grid()
ax[1,0].set_title('(c) '+method_name+' distribution')
ax[1,0].set_xlabel('Grayscale Values')
ax[1,0].set_ylabel('probability')

#----------------------------------------------------------------------
#  Adding noise to the image and displaying
#----------------------------------------------------------------------
noisy_image=np.float32(img)+np.float32(syn_noise2) # adding un-trimmed version of noise
noisy_image[noisy_image>255]=255
noisy_image[noisy_image<0]=0
mf.my_imshow(mf.norm_uint8(noisy_image),'(d) Noise added to image',ax[1,1])

plt.show()
print("Completed Successfully ...")



