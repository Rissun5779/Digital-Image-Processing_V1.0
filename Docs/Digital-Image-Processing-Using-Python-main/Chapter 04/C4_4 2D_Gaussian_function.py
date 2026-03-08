#======================================================================
# PURPOSE : Creating a 2D Gaussian filter/function
#======================================================================
import cv2,matplotlib.pyplot as plt, numpy as np
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

x=np.arange(-10,11,.01) # Array of x-coordinates
# e.g. x=[1,2,3,4]

y=np.arange(-10,11,.01) # Array of y-coordinates
# e.g. y=[1,2,3]

xx,yy=np.meshgrid(x,y)  # 2 arrays of x & y coordinates in 2D
# e.g. xx=[1,2,3,4
#          1,2,3,4    ==> Array of ALL x-coordinates
#          1,2,3,4]

# e.g. yy=[1,1,1,1
#          2,2,2,2    ==> Array of corresponding y-coordinates
#          3,3,3,3]

A=1            # Amplitude of 2D Gaussian Function
sigma_x=5      # Standard deviation along x-direction
sigma_y=5      # Standard deviation along y-direction
x0=0           # Mean along x-direction
y0=0           # Mean along y-direction

# Creating the Gaussian function as per 2D equation
Gauss_function=A*np.exp(-(((xx-x0)**2)/(2*(sigma_x**2))+((yy-y0)**2)/(2*(sigma_y**2))))
mf.my_imshow(mf.norm_uint8(Gauss_function),"Typical 2D Gaussian Function")

plt.show()
print("Completed Successfully ...")


















