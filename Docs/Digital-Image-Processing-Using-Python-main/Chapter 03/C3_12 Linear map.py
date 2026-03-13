#===========================================================================
# PURPOSE : Understanding Linear Mapping
#===========================================================================
import matplotlib.pyplot as plt
import numpy as np

#---------------------------------------------------------------------------
#                    Defining points on X-Yplane
#---------------------------------------------------------------------------
# Constructing a 1D array of all row coordinates
org_x=np.float32([0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3])
# Constructing a 1D array of corresponding column coordinates
org_y=np.float32([0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3])

#---------------------------------------------------------------------------
#        Creating 2D linear transformation matrices (LTM) for use
#---------------------------------------------------------------------------
#1. Identity Transformation
LTM1=np.array([[1,0],[0,1]])

#2. Scaling
LTM2=np.array([[2,0],[0,1]])   # Scaling in X-direction by a factor of 2
LTM3=np.array([[1,0],[0,3]])   # Scaling in Y-direction by a factor of 3
LTM4=np.array([[2,0],[0,3]])   # Scaling in X & Y-direction by a factor of 2 & 3 resp.

#3. Rotating by angle theta in ACW direction
theta=np.pi/6 # (30 degrees)
LTM5=np.array([[np.cos(theta),-np.sin(theta)],[np.sin(theta),np.cos(theta)]])

#4. Mirroring
LTM6=np.array([[-1,0],[0,1]])       # Mirror about X axis
LTM7=np.array([[1,0],[0,-1]])       # Mirror about Y axis
LTM8=np.array([[-1,0],[0,-1]])      # Mirror about X & Y axis

#5. Shear mapping
m=2
LTM9=np.array([[1,m],[0,1]])    # Horizonatal shear mapping by factor 'm'
n=3
LTM10=np.array([[1,0],[n,1]])   # Vertical shear mapping by factor 'n'
LTM11=np.array([[1,m],[n,1]])   # Horizonatal & Vertical shear mapping by factor 'm' & 'n' resp.

#6. Squeeze mapping by factor 'k'
k=2
LTM12=np.array([[k,0],[0,1/k]])

#7. Projection onto 'y' axis
m=2
LTM13=np.array([[0,0],[0,1]])  # Projection onto 'y' axis
LTM14=np.array([[1,0],[0,0]])  # Projection onto 'x' axis

#---------------------------------------------------------------------------
#           SELECTING ONE LTM FROM THE ABOVE LTM's
#---------------------------------------------------------------------------
LTM=LTM5

#---------------------------------------------------------------------------
#   Transforming every 2D point by using linear transformation matrix
#---------------------------------------------------------------------------
trans_x=org_x*0
trans_y=org_x*0
for i in np.arange(0,len(org_y),1):
    trans_x[i],trans_y[i]=np.matmul(LTM,[org_y[i],org_x[i]])

#---------------------------------------------------------------------------
#          Plotting Everything
#---------------------------------------------------------------------------
fig,ax=plt.subplots()
fig.show()
ax.plot(org_y,org_x,'co',label="Original Points",markersize=12)
ax.grid()
ax.axis('equal')
ax.set_xlabel("X axis -->")
ax.set_ylabel("Y axis -->")
ax.plot(trans_x,trans_y,'k>',label="Transformed Points")
ax.legend()

plt.show()
print("Completed Successfully ...")







