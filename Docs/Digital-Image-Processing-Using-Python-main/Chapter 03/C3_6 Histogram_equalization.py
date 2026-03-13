#======================================================================
# PURPOSE : Histogram Matching / Specification
#======================================================================
import cv2
import matplotlib.pyplot as plt
import skimage.exposure as sk  # use 'pip install scikit-image' for using this
import my_package.my_functions as mf # This is a user defined package and ...
# one may find the details related to its contents and usage in section XXX

image=cv2.imread('img5.bmp',0) # Input Grayscale Image
r1,c1=image.shape
no_of_bins=256
hist_image = cv2.calcHist([image],[0],None,[no_of_bins],[0,256])/(r1*c1)

hist_equ_image = cv2.equalizeHist(image) # Histogram Equalised Image
hist_equ=cv2.calcHist([hist_equ_image],[0],None,[no_of_bins],[0,256])/(r1*c1) 

reference=cv2.imread('img6.bmp',0) # Reference image
r2,c2=reference.shape
hist_reference = cv2.calcHist([reference],[0],None,[no_of_bins],[0,256])/(r2*c2)

matched = sk.match_histograms(image,reference) # Histogram matched image
matched=mf.norm_uint8(matched)
r3,c3=matched.shape
hist_matched = cv2.calcHist([matched],[0],None,[no_of_bins],[0,256])/(r3*c3)

fig,ax=plt.subplots(2,2)
fig.show()

mf.my_imshow(image,'(a) Input Grayscale Image',ax[0,0])
mf.my_imshow(hist_equ_image,'(b) Histogram Equalized Image',ax[0,1])
mf.my_imshow(reference,'(c) Reference Grayscale Image',ax[1,0])
mf.my_imshow(matched,'(d) Matched Grayscale Image',ax[1,1])

fig2,ax2=plt.subplots(2,2)
fig2.show()

ax2[0,0].plot(hist_image)
ax2[0,0].set_title("(a) Histogram of input image")
ax2[0,0].grid(1)

ax2[0,1].plot(hist_equ)
ax2[0,1].set_title("(b) Histogram of Equalized image")
ax2[0,1].grid(1)

ax2[1,0].plot(hist_reference)
ax2[1,0].set_title("(c) Histogram of reference image")
ax2[1,0].grid(1)


ax2[1,1].plot(hist_matched)
ax2[1,1].set_title("(d) Histogram of matched image")
ax2[1,1].grid(1)

plt.show()
print("Completed Successfully ...")
