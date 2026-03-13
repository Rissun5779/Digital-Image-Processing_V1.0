#======================================================================
# PURPOSE : Adding noise of various distributions to the image [PART 2]
#======================================================================
import cv2,matplotlib.pyplot as plt, numpy as np
# (install the package below using 'pip install scikit-image'
# as per the procedure illustrated in section YYY)
import scipy.ndimage as sp
from skimage.util import random_noise
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

#----------------------------------------------------------------------
#   Importing and normalising the image to the range [0,1]
#----------------------------------------------------------------------
input_img=cv2.imread('img2.bmp',0)
img=np.float64(input_img)/255
# Pixel values above are normalised to range 0 to 1
# This is the requirement of 'random_noise' function imported above

#----------------------------------------------------------------------
#      Choosing noise to be added and adding noise
#----------------------------------------------------------------------
select_noise_distribution=1 # (CHOOSE NOISE DISTRIBUTION HERE)
# note that zero mean noise distribution is assumed wherever applicable
match(select_noise_distribution):
    case 1:
        method_name='Salt & Pepper'
        noisy_img = random_noise(img, mode='s&p',amount=.1)
    case 2:
        method_name='Gaussian'
        noisy_img = random_noise(img, mode='gaussian',mean=0,var=.05,clip=True)
    case 3:
        method_name='Poisson'
        noisy_img = random_noise(mf.norm_uint8(255*img), mode='poisson',clip=True)
    # The Poisson distribution is only defined for positive integers. To apply
    # this noise type, the number of unique values in the image is found and
    # the next round power of two is used to scale up the floating-point result,
    # after which it is scaled back down to the floating-point image range.
    case 4:
        method_name='Speckle'
        noisy_img = random_noise(img, mode='speckle',mean=0,var=.1,clip=True)

#----------------------------------------------------------------------
#      Displaying
#----------------------------------------------------------------------
fig,ax=plt.subplots(1,2)
fig.show()
mf.my_imshow(input_img,'(a) Grayscale Image',ax[0])
mf.my_imshow(mf.norm_uint8(noisy_img),'(b) Noisy image ('+str(method_name)+')',ax[1])

plt.show()
print("Completed Successfully ...")


