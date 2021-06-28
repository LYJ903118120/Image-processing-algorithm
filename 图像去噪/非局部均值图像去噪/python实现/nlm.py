import cv2,math
import ssim
import numpy as np




def NLmeansfilter(I, ds=2, Ds=5, h=5):
# I ：含噪图
# ds：邻域半径
# Ds：搜索半径
# h：高斯平滑参数
# 去噪图


    [ m, n ] = I.shape                                      # 450,620
    DenoisedImg = np.zeros(I.shape)
    PaddedImg = np.pad(I, ((ds,ds),(ds,ds)),'symmetric')
    kernel = np.ones( ( 2*ds+1, 2*ds+1) )
    kernel = kernel * ( 1 / ( (2*ds+1) * (2*ds+1) ) )

    h2 = h ** 2
    x = 0
    y = 0
    for i in range(m):     # x # 模拟循环次数，
        x = x+1            # 450
        y = 0
        for j in range(n): # y

            # 模仿matlab

            y = y+1 # 620

            x1 = x+ds
            y1 = y+ds       # 0:5
            W1 = PaddedImg[x1 - ds - 1: x1 + ds, y1 - ds - 1: y1 + ds]
            Wmax = 0
            average=0
            sweight=0

            # 搜索窗口
            rmin = max(x1 - Ds, ds + 1)   # -2,3 = 3
            rmax = min(x1 + Ds, m + ds)   # 8,512 = 8
            smin = max(y1 - Ds, ds + 1)
            smax = min(y1 + Ds, n + ds)

            for r in range( rmin, rmax+1 ): # 3-9*
                for s in range( smin, smax+1 ):

                    if r-1 == x1-1 and s-1 == y1-1:
                        continue

                    W2 = PaddedImg[ r-ds-1:r+ds, s-ds-1:s+ds ]       #  邻域窗口2


                    Dist2 = sum ( sum ( kernel * (W1-W2) * (W1-W2) ) )     # 邻域间距离

                    w = math.exp( -Dist2 / h2 )                            # W(x,y) = 1 / Z(x)   *   exp()

                    if w > Wmax :
                        Wmax=w

                    sweight = sweight + w
                    average=average + w * PaddedImg[r-1][s-1]

            average = average + Wmax * PaddedImg[x1-1][y1-1]   # 自身取最大权值
            sweight = sweight + Wmax
            DenoisedImg[ x-1 ][ y-1 ] = average / sweight


    return ( DenoisedImg )