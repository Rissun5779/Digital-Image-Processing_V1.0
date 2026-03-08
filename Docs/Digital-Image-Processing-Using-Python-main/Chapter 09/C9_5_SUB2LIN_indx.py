#======================================================================
# PURPOSE : Convert subscripted indices to linear and vice versa
#======================================================================
import numpy as np

# Create a 2D array and print it
input_array=np.array([[1,2,3,4,5],[4,5,6,7,8],[3,4,5,6,7]])
print(input_array)

# Find all subscipted indices in the array that follow a given condition
sub_indx=np.where(input_array>5)
print(sub_indx)

# Convert those subscripted indices to linear
lin_indx=np.ravel_multi_index(sub_indx,np.shape(input_array),order='F')
# order in the above line tells us whether we want to count
# column wise ('F' - Fortran order) or row wise ('C' - C lang. order)
# The result returned by ravel_multi_index is not sorted.
print(lin_indx)

# Convert linear indices so formed back to subscripted indices
recovered_sub_indx=np.unravel_index(lin_indx,np.shape(input_array),order='F')
print(recovered_sub_indx)

print("Completed Successfully ...")













