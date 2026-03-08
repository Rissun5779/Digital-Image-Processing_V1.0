#======================================================================
# Purpose : creating custom functions for usage
#======================================================================

import matplotlib.pyplot as plt
import cv2
import numpy as np

# Function my_imshow is used to display image using matplotlib method and is
# usually used with subplots

def my_imshow(input_image,str='',ax='Nothing Passed'):
    if ax=='Nothing Passed':
        fig1,ax1=plt.subplots()
        fig1.show()
        if input_image.ndim==3:
            plt.imshow(cv2.cvtColor(input_image, cv2.COLOR_BGR2RGB))
        else:
            plt.imshow(cv2.cvtColor(input_image, cv2.COLOR_GRAY2RGB))
        plt.axis("off")
        plt.gca().set_title(str)
        return fig1,ax1
    else:
        if input_image.ndim==3:
            ax.imshow(cv2.cvtColor(input_image, cv2.COLOR_BGR2RGB))
        else:
            ax.imshow(cv2.cvtColor(input_image, cv2.COLOR_GRAY2RGB))
        ax.axis("off")
        ax.set_title(str)   

# Function norm_uint8 defined below,
# Normalises and convert to uint8 an input_image and return the same, usually
# used while displaying a grayscale image which has been converted to float32
# during processing
    
def norm_uint8(input_image):  
    input_image=input_image-np.min(input_image)
    input_image=255*input_image/np.max(input_image)
    input_image=np.uint8(input_image)
    return input_image






        

        

