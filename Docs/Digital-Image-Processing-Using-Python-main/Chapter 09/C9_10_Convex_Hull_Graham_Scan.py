#=============================================================================
# PURPOSE : Finding Convex Hull using Graham Scan Algorithm
#=============================================================================
import cv2
import matplotlib.pyplot as plt
import numpy as np
import skimage as ski
import math
import my_package.my_functions as mf # This is a user defined package
# one may find the details related to its contents and usage in section XXX

# Function to calculate the convex hull using Grahm Scan Procedure
def conv_hull_graham_scan(points_list): # Input - Unsorted List of 2D points
    n = len(points_list)
    
    # Nested-Function to find the orientation indicator of triplet 
    # of points (p, q, r). Returns:
    # 0: Collinear points_list
    # 1: Clockwise points_list
    # 2: Counterclockwise points_list
    def find_orient_indicator(p, q, r):
        val = (q[1] - p[1]) * (r[0] - q[0]) - (q[0] - p[0]) * (r[1] - q[1])
        if val == 0:
            return 0
        return 1 if val > 0 else 2

    # Find the point with the lowest y-coordinate (and leftmost if tie appears)
    btm_left_pt = min(points_list, key=lambda point: (point[1], point[0]))

    # Sort the points_list based on polar angle with respect to the btm_left_pt point
    sorted_points_list = sorted(points_list, key=lambda point:\
    (math.atan2(point[1] - btm_left_pt[1], point[0] - btm_left_pt[0]), point))

    # Initialize the convex hull with the first three points_list
    hull = [sorted_points_list[0], sorted_points_list[1], sorted_points_list[2]]
    hull_index=[0,1,2]
    
    # Iterate over the sorted points_list to build the convex hull
    print('p','q','r','Pass?')
    for i in range(3, n):
        print(hull_index[-3],hull_index[-2], hull_index[-1],1)
        while len(hull) > 1 and find_orient_indicator(hull[-2], hull[-1], sorted_points_list[i]) != 2:
            hull.pop()
            pop_ele=hull_index.pop()
            print(hull_index[-1],pop_ele,i,0)
        hull.append(sorted_points_list[i])
        hull_index.append(i)
    print(hull_index[-3],hull_index[-2], hull_index[-1],1)
    print(hull_index[-2], hull_index[-1],0,1)
        
    return hull,sorted_points_list
    
# Creating Random points in 2D space (points should be more than 2)
# Although fractional coordinates can also be taken, for illustration,
# we take integer coordinates.
#points_list = np.random.randint(1,10,(10,2)).tolist()
points_list = np.array([(7,9),(5,8),(2,7),(4,6),(2,6),(6,6),(4,5),(8,5),(1,4),(6,4)]).tolist()

# Calculate the convex hull
convex_hull_pts_list,sorted_points_list = conv_hull_graham_scan(points_list)
sorted_points_list=np.array(sorted_points_list)

#--------------------------------------------------------------------------
#                 Plotting Logic
#--------------------------------------------------------------------------
# Plot the convex hull and points_list
fig,ax=plt.subplots(1,2)
fig.show()
points_array=np.array(points_list)
convex_hull_pts_array=np.array(convex_hull_pts_list)
ax[1].plot(points_array[:,0],points_array[:,1],'k.',markersize=10,label="2D Points")

# Append the initial point at the last of the array as well for plotting
# so that the convex hull is closed curve
convex_hull_pts_array2=np.vstack((convex_hull_pts_array,convex_hull_pts_array[0]))
ax[1].plot(convex_hull_pts_array[0,0],convex_hull_pts_array[0,1],'ko',markersize=10,label="Pivot point")
r,c=np.shape(points_array)

for i in np.arange(1,r,1):
    ax[1].plot([sorted_points_list[0,0],sorted_points_list[i,0]],\
    [sorted_points_list[0,1],sorted_points_list[i,1]],'--',markersize=10,color=[.7,.7,.7])
    ax[1].text(sorted_points_list[i,0],sorted_points_list[i,1],'('+str(i)+')')
ax[1].plot(convex_hull_pts_array2[:,0],convex_hull_pts_array2[:,1],'-',color='black',label="Convex Hull")
ax[0].plot(points_array[:,0],points_array[:,1],'k.',markersize=10,label="2D Points")
ax[0].grid()
ax[0].set_title("(a) Set of points",fontsize=15)
ax[0].set_xlabel("The X axis ->")
ax[0].set_ylabel("The Y axis ->")
ax[0].axis("equal")
ax[0].legend()
ax[1].grid()
ax[1].set_title("(b) Convex Hull of set of points",fontsize=15)
ax[1].set_xlabel("The X axis ->")
ax[1].set_ylabel("The Y axis ->")
ax[1].axis("equal")
ax[1].legend()

plt.show()
print("Completed Successfully ...")