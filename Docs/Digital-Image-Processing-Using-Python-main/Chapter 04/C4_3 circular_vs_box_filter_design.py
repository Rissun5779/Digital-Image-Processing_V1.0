#======================================================================
# PURPOSE : Creating and visualizing Box & Circular filters
#======================================================================
import pandas as pd
import xlsxwriter
import numpy as np
import scipy.signal as sci
#------------------------------------------------------------------------------
#                BOX & CIRCULAR FILTER DESIGN
#------------------------------------------------------------------------------
m=111         # shape of circular filter is (mxm) (keep this odd x odd)
circular_filter=np.zeros((m,m)) # circular filter initialised with zeros

# Double loop to create circular filter
for i in np.arange(0,m,1):
    for j in np.arange(0,m,1):
        # this next if conition helps in creating circular filter
        # it does so by making all the coef's = 1
        # within a predefined distance from the central
        # point of filter
        if np.sqrt((i-(m-1)/2)**2+(j-(m-1)/2)**2)<(m-1)/2:
            circular_filter[i,j]=1
            # upto this point the circular filter is UN-normalised
s1=pd.DataFrame(circular_filter) # Converting array to dataframe
#for writing into excel file

# in the next line we calculate the shape of square filter
# which has same no. of ones as present in circular filter
# where 'n' is one side of square
n=np.int16(np.sqrt(np.sum(circular_filter)))
box_filter=np.ones([n,n])    # BOX FILTER of shape nxn (UN-normalised)
s2=pd.DataFrame(box_filter)# Converting array to dataframe
#for writing into excel file

# Normalising the circular filter & box_filter
circular_filter=circular_filter/np.sum(circular_filter)
box_filter=box_filter/(n**2)

#------------------------------------------------------------------------------
#                Saving to excel sheet
#------------------------------------------------------------------------------
# write sheets (dataframes) to excel file
data2excel=pd.ExcelWriter('Box and Circular Filter.xlsx',engine='xlsxwriter')
s1.to_excel(data2excel,sheet_name='Circular_filter')
s2.to_excel(data2excel,sheet_name='Box_filter')
data2excel.save()
print("\nCompleted Successfully ...")








