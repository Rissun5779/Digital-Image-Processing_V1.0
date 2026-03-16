import cv2
import os

def onMouse(event, x, y, flags, param):
    x, y = y, x
    if img.ndim != 3:
        print("(x,y)=(%d, %d)" % (x, y), end = "gray-level value=")
        print(img[x, y])
    else:
        print("(x,y)=(%d, %d)" % (x, y), end = "RGB value=")
        print(img[x, y])

folder = r"C:\Users\USER\Desktop\Git\Digital-Image-Processing_V1.0\DSP\Python"
filename = input("Enter the image file name (without extension): ")
filepath = os.path.join(folder, filename + ".png")  # 組合完整路徑

img = cv2.imread(filepath)

cv2.namedWindow("Image")
cv2.setMouseCallback("Image", onMouse)
cv2.imshow("Image", img)
cv2.waitKey(0)
cv2.destroyAllWindows()
