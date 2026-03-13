#======================================================================
# PURPOSE : GAMMA transformation curve
#======================================================================
import cv2,matplotlib.pyplot as plt, numpy as np
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

#--------------------------------------------------------------------------
#                   GAMMA Transformation (Global Transform)
#--------------------------------------------------------------------------
input_intensities=np.arange(0,256,1) # Input Grayscale Range
G=np.array([.05,.10,.20,.30,.40,.50,.70,1,1.5,2.5,5,10])
amp_factor=1;
j=10
for i in G:
    Gamma_trans_intensities=amp_factor*(np.float32(input_intensities))**i
    Gamma_trans_intensities=mf.norm_uint8(Gamma_trans_intensities)
    plt.plot(input_intensities,Gamma_trans_intensities,'b')
    t=plt.text(input_intensities[j],Gamma_trans_intensities[j],i)
    t.set_bbox(dict(facecolor='pink', alpha=1, edgecolor='red'))
    j=j+20
    
plt.grid()
plt.title("GAMMA Transformation")
plt.xlabel("Input Intensities")
plt.ylabel("Output Intensities")
plt.legend()

plt.show()
print("Completed Successfully ...")




