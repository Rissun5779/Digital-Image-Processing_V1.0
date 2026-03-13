#======================================================================
# PURPOSE : Learning Log Transformation on images
#======================================================================
import cv2,matplotlib.pyplot as plt, numpy as np
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

#--------------------------------------------------------------------------
#                   Log Transformation (Global Transform)
#--------------------------------------------------------------------------
input_image=cv2.imread('img4.bmp',0)

fig,ax=plt.subplots(1,2)
fig.show()
mf.my_imshow(input_image,'(a) Input Image',ax[0])

amp_factor=1;
log_trans_image=amp_factor*np.log(1+np.float32(input_image))
log_trans_image=mf.norm_uint8(log_trans_image)
mf.my_imshow(log_trans_image,"(b) Log Transformed Image",ax[1])

plt.show()
print("Completed Successfully ...")




