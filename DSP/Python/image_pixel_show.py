import cv2
import os

folder = r"C:\Users\USER\Desktop\Git\Digital-Image-Processing_V1.0\DSP\Python"
filename = input("Enter the image file name (without extension): ")
filepath = os.path.join(folder, filename + ".png")  # 組合完整路徑

img = cv2.imread(filepath)

nr = img.shape[0]
nc = img.shape[1]
print("Number of rows: ", nr)
print("Number of columns: ", nc)
print("Number of ndim = ", img.ndim)

if img.ndim != 3:
  print("Gray-level image")
else:
  print("Color image")