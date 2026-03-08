#======================================================================
# PURPOSE : Learning How to deal with EXCEL files using PANDAS
#======================================================================
import pandas as pd
import xlsxwriter

# Creating File Handle to EXCEL File
file1=pd.ExcelFile("Marks Entry.xlsx")

# Printing all sheet names available
print('............................................... 1')
print(file1.sheet_names)

# Accessing Sheet 1 (NOTICE the argument as sheet name 'Hi' for that below)
s1=file1.parse('Hi') # Alternatively 0 can be passed instead of sheet name
# as it's the first sheet and numbering begin from 0 in Python

# Accessing Sheet 2 (NOTICE the argument 1 for that below)
s2=file1.parse(1)

# Display all column names of sheet s1
print('............................................... 2')
print(s1.columns)

# Access one column from s1
print('............................................... 3')
print(s1['Name'])

# Access multiple columns from s1
print('............................................... 4')
print(s1[['Name',"S.No.",'Name']])

# Access any one row from s1
print('............................................... 5')
print(s1.iloc[2]) # Counting starts from 0 as usual but header is not counted !

# Display first n rows (header counted)
print('............................................... 6')
print(s1.head(3))

# Access arbitrary rows from s1
print('............................................... 7')
print(s1.iloc[[2,4,0]]) # Counting starts from 0 as usaul but header is not counted !

# Access a cell from s1
print('............................................... 8')
print(s1.iloc[0,1])

# write sheets (dataframes) to excel file
data2excel=pd.ExcelWriter('output1.xlsx',engine='xlsxwriter')
s1.to_excel(data2excel,sheet_name='result1')
data2excel.save()

# Sorting by ONLY ONE Column
print('............................................... 9')
var1=s1['Name'].sort_values(ascending=True)
print(var1)

data2excel=pd.ExcelWriter('output2.xlsx',engine='xlsxwriter')
var1.to_excel(data2excel,sheet_name='result1')
data2excel.save()

# Sorting by ENTIRE WORKSHEET as per ONE Column
print('............................................... 10')
var1=s1.sort_values('Name',ascending=True)
print(var1)

data2excel=pd.ExcelWriter('output3.xlsx',engine='xlsxwriter')
var1.to_excel(data2excel,sheet_name='result1')
data2excel.save()

# Filter data i.e. columns as per a condition
print('............................................... 11')
print(s1[s1['Marks in Physics']<40])

# Know the datatypes of each column
print('............................................... 12')
print(s1.dtypes)

print("\nCompleted Successfully ...")







