#======================================================================
# PURPOSE : Learning Convolution
#======================================================================
import matplotlib.pyplot as plt
import numpy as np

my_signal=np.array([4,8,2,7,6,2,3]) # SIGNAL
filter1=np.array([5,6,3,7,1])       # CONVOLUTION FILTER
result_conv1=np.convolve(my_signal,filter1,'same') # CONVOLUTION RESULT

# PLOTTING LOGIC
fig,ax=plt.subplots()
fig.show()
ax.plot(my_signal,'k',label='Original Signal',linewidth=2)
ax.plot(np.arange(0,len(my_signal),1),my_signal,'k.',markersize=10)
ax.plot(result_conv1,'--b',label='Convolution result')
ax.plot(np.arange(0,len(result_conv1),1),result_conv1,'b.',markersize=10)
ax.grid()
ax.legend()
ax.set_xticks(np.arange(0,len(my_signal),1))
ax.set_yticks(np.arange(0,result_conv1.max(),10))
ax.set_title('Illustration of Convolution',fontsize=15)
ax.set_xlabel('Time axis')
ax.set_ylabel('Amplitude axis')

plt.show()
print("Completed Successfully ...")













