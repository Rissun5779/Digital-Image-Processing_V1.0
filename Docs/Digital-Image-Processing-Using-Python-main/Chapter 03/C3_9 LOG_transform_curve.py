#======================================================================
# PURPOSE : LOG transformation curve
#======================================================================
import cv2,matplotlib.pyplot as plt, numpy as np
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

#--------------------------------------------------------------------------
#                   Log Transformation (Global Transform)
#--------------------------------------------------------------------------
input_intensities=np.arange(0,256,1) # Input Grayscale Range
amp_factor=1;
log_trans_intensities=amp_factor*np.log(1+np.float32(input_intensities))
log_trans_intensities=mf.norm_uint8(log_trans_intensities)
plt.plot(input_intensities,log_trans_intensities)
plt.grid()
plt.title("Log Transformation")
plt.xlabel("Input Intensities")
plt.ylabel("Output Intensities")

plt.show()
print("Completed Successfully ...")




