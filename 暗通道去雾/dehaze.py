import cv2
from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
from skimage.morphology import disk  #生成扁平的盘状结构元素，其主要参数是生成圆盘的半径
import skimage.filters.rank as sfr

def min_box(image,kernel_size=15):
    min_image = sfr.minimum(image,disk(kernel_size))  #skimage.filters.rank.minimum()返回图像的局部最小值

    return min_image

def calculate_dark(image):
    if not isinstance(image,np.ndarray):
        raise ValueError("input image is not numpy type")  #手动抛出异常
    dark = np.minimum(image[:,:,0],image[:,:,1],image[:,:,2]).astype(np.float32) #取三个通道的最小值来获取暗通道
    dark = min_box(dark,kernel_size=15)
    return dark/255

hazeir = np.array(cv2.imread("vis/35.png"))[:,:,0:3]/255
hazevis = np.array(cv2.imread("ir/35.png"))[:,:,0:3]/255
dark_hazeir = calculate_dark(hazeir)
dark_hazevis = calculate_dark(hazevis)


plt.figure()
plt.subplot(2,2,1)
plt.imshow(hazeir)

plt.subplot(2,2,2)
plt.imshow(dark_hazeir,cmap="gray")

plt.subplot(2,2,3)
plt.imshow(hazevis)

plt.subplot(2,2,4)
plt.imshow(dark_hazevis,cmap="gray")

plt.show()

