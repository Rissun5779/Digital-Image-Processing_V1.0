#======================================================================
# PURPOSE : GAMMA transformation
#======================================================================
import cv2,matplotlib.pyplot as plt, numpy as np
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

#--------------------------------------------------------------------------
#                   GAMMA Transformation (Global Transform)
#--------------------------------------------------------------------------
input_image=cv2.imread('img4.bmp',0)

fig,ax=plt.subplots(1,2)
fig.show()
mf.my_imshow(input_image,"(a) Input Grayscale Image",ax[0])

amp_factor=1;

G=.3
Gamma_trans_image=mf.norm_uint8(amp_factor*(np.float32(input_image))**(G))
mf.my_imshow(Gamma_trans_image,"(b) Gamma Transformed Image with Y = "+str(G),ax[1])

plt.show()
print("Completed Successfully ...")




