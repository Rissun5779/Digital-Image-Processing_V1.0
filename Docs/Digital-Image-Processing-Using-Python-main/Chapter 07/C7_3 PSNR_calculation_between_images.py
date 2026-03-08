#======================================================================
# PURPOSE : Calculating PSNR between two images of same shape
#======================================================================
import cv2

img1=cv2.imread('img2.bmp',0)
img2=cv2.imread('img24.bmp',0)

psnr = cv2.PSNR(img1,img2)
print("PSNR is : "+str(psnr)+' dB')

print("Completed Successfully ...")





