from numpy import mat


Lab1 = False

if Lab1:
  import sys
  import cv2

  img_path = (
      r"C:\Users\USER\Desktop\Git\Digital-Image-Processing_V1.0\DSP\Python\lenna.png"
  )
  img = cv2.imread(img_path)

  def main():
    cv2.imshow("lenna", img)
    cv2.waitKey(0)
    sys.exit()
      
  if __name__ == "__main__":
    main()

else:
    from matplotlib import pyplot as plt
    from matplotlib import image as mpimg

    plt.title("lenna Image")
    plt.xlabel("x-axis")
    plt.ylabel("y-axis")

    img_path = (
        r"C:\Users\USER\Desktop\Git\Digital-Image-Processing_V1.0\DSP\Python\lenna.png"
    )
    img = mpimg.imread(img_path)
    plt.imshow(img)
    plt.show()