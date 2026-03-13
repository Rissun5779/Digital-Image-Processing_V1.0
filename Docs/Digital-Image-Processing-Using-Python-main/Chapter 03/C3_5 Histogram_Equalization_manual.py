#======================================================================
# PURPOSE : Understanding Mechanism of Histogram Equalization
#======================================================================
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# Input Un-normalized histogram here
occurrence_input=np.array([7,8,9,8,8,8,6,5,4,3,2,1,0,0,0,0,0])

total_gray_level=len(occurrence_input)
total_pixel=np.sum(occurrence_input) # total data points (if the histogram is not from image)
max_gray_level=total_gray_level-1 # this is because 0 is also counted as gray level
gray_levels_X_axis=np.arange(0,total_gray_level,1) # X-axis of histogram

PDF_input=occurrence_input/total_pixel # Normalised Histogram of input image

fig,ax=plt.subplots(2,1)
fig.show()
ax[0].stem(gray_levels_X_axis,occurrence_input)
ax[0].grid('On')
ax[0].set_title('(a) Un-normalized input histogram (arbitrary distribution)',fontsize=15)
ax[0].set_xlabel('Grayscale values')
ax[0].set_ylabel('No. of pixel')

CDF_input=np.cumsum(PDF_input) # Transformation function derived from input itself
OP_unnormalized_histogram=max_gray_level*CDF_input
Hist_eq_level=np.round(OP_unnormalized_histogram)

occurrence_output=np.zeros((total_gray_level)) # initialising output un-normalized histogram
for i in gray_levels_X_axis:
    occurrence_output[i]=np.sum(np.array(occurrence_input[np.where(Hist_eq_level==i)]))
PDF_output=occurrence_output/total_pixel # Normalized Histogram of output image
ax[1].stem(gray_levels_X_axis,occurrence_output)
ax[1].grid('On')
ax[1].set_title('(b) Un-Normalized output histogram (uniform distribution expected)',fontsize=15)
ax[1].set_xlabel('Grayscale values')
ax[1].set_ylabel('No. of pixel')

# For printing data onto shell
summary=np.hstack([gray_levels_X_axis,occurrence_input,PDF_input,CDF_input,OP_unnormalized_histogram,Hist_eq_level])
summary=summary.reshape(6,total_gray_level).T

np.set_printoptions(suppress=True) # for printing integers without decimal point
np.set_printoptions(precision=2) # for making decimal precision =2 while printing
print(summary)

df = pd.DataFrame(summary, columns = ['IP gray level','IP Un-normalized histogram','IP PDF','IP CDF','OP Gray Level (not rounded off)','OP Gray Level'])
print(df)
data2excel=pd.ExcelWriter('output1.xlsx',engine='xlsxwriter')
df.to_excel(data2excel,sheet_name='histogram equalization',index=False)
data2excel.save()

plt.show()
print("Completed Successfully ...")