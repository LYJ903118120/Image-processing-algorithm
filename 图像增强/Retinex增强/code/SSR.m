clear;
close all;
% 读入图像
I = imread('1vis.png');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% R分量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 取输入分量的R分量
R = I(:,:,1);
[N1,M1] = size(R);
%%%%%%%%%%%%%%%  步骤一：对图像取对数，将照射光分量和反射光分量分离%%%%%%%%%%%
% 对R分量进行数据转换，并对其取对数
R0 = double(R);
Rlog = log(R0+1);  
%%%%%%%%%%%%%%%  步骤二：用高斯模板对原图像作卷积，得到低通滤波后的图像D %%%%%%%%%%
% 对R分量进行二维傅里叶变换
Rfft2 = fft2(R0);
% 形成高斯滤波函数
sigma = 250;
F = zeros(N1,M1);
for i = 1:N1
    for j = 1:M1
        F(i,j) = exp(-((i-N1/2)^2+(j-M1/2)^2)/(2*sigma*sigma));
    end
end
F = F./(sum(F(:)));  % 矩阵归一化？？
% 对高斯滤波函数进行二维傅里叶变换
Ffft = fft2(double(F));
% 对R分量与高斯滤波函数进行卷积运算
DR0 = Rfft2.* Ffft;
DR = ifft2(DR0);
%%%%%%%%%%%%%%%  步骤三：在对数域中，用原图像减去低通滤波后的图像，得到高频增强图像 %%%%%%%%%%
DRdouble = double(DR);
DRlog = log(DRdouble + 1);
Rr = Rlog - DRlog;
%%%%%%%%%%%%%%%  步骤四：取反对数,得到增强后的图像分量 %%%%%%%%%%
EXPRr = exp(Rr);
%%%%%%%%%%%%%%%  步骤五：作对比度增强 %%%%%%%%%%
MIN = min(min(EXPRr));
MAX = max(max(EXPRr));
EXPRr = (EXPRr - MIN)/(MAX - MIN);
EXPRr = adapthisteq(EXPRr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% G分量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 取输入分量的G分量
G = I(:,:,2);
[N1,M1] = size(G);
%%%%%%%%%%%%%%%  步骤一：对图像取对数，将照射光分量和反射光分量分离%%%%%%%%%%%
% 对G分量进行数据转换，并对其取对数
G0 = double(G);
Glog = log(G0+1);   % ?????????????????????????加1干嘛
%%%%%%%%%%%%%%%  步骤二：用高斯模板对原图像作卷积，得到低通滤波后的图像D %%%%%%%%%%
% 对G分量进行二维傅里叶变换
Gfft2 = fft2(G0);
% 形成高斯滤波函数
sigma = 250;
for i = 1:N1
    for j = 1:M1
        F(i,j) = exp( - ((i - N1/2)^2 + (j - M1/2)^2)/(2 * sigma * sigma));
    end
end
F = F./(sum(F(:)));
% 对高斯滤波函数进行二维傅里叶变换
Ffft = fft2(double(F));
% 对G分量与高斯滤波函数进行卷积运算
DG0 = Gfft2.* Ffft;
DG = ifft2(DG0);
%%%%%%%%%%%%%%%  步骤三：在对数域中，用原图像减去低通滤波后的图像，得到高频增强图像 %%%%%%%%%%
DGdouble = double(DG);
DGlog = log(DGdouble + 1);
Gg = Glog - DGlog;
%%%%%%%%%%%%%%%  步骤四：取反对数,得到增强后的图像分量 %%%%%%%%%%
EXPGg = exp(Gg);
%%%%%%%%%%%%%%%  步骤五：作对比度增强 %%%%%%%%%%
MIN = min(min(EXPGg));
MAX = max(max(EXPGg));
EXPGg = (EXPGg - MIN)/(MAX - MIN);
EXPGg = adapthisteq(EXPGg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% B分量 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 取输入分量的B分量
B = I(:,:,3);
[N1,M1] = size(B);
%%%%%%%%%%%%%%%  步骤一：对图像取对数，将照射光分量和反射光分量分离%%%%%%%%%%%
% 对B分量进行数据转换，并对其取对数
B0 = double(B);
Blog = log(B0+1); 
%%%%%%%%%%%%%%%  步骤二：用高斯模板对原图像作卷积，得到低通滤波后的图像D %%%%%%%%%%
% 对B分量进行二维傅里叶变换
Bfft2 = fft2(B0);
% 形成高斯滤波函数
sigma = 250;
for i = 1:N1
    for j = 1:M1
        F(i,j) = exp( - ((i - N1/2)^2 + (j - M1/2)^2)/(2 * sigma * sigma));
    end
end
F = F./(sum(F(:)));
% 对高斯滤波函数进行二维傅里叶变换
Ffft = fft2(double(F));
% 对B分量与高斯滤波函数进行卷积运算
DB0 = Gfft2.* Ffft;
DB = ifft2(DB0);
%%%%%%%%%%%%%%%  步骤三：在对数域中，用原图像减去低通滤波后的图像，得到高频增强图像 %%%%%%%%%%
DBdouble = double(DB);
DBlog = log(DBdouble + 1);
Bb = Blog - DBlog;
%%%%%%%%%%%%%%%  步骤四：取反对数,得到增强后的图像分量 %%%%%%%%%%
EXPBb = exp(Bb);
%%%%%%%%%%%%%%%  步骤五：作对比度增强 %%%%%%%%%%
MIN = min(min(EXPBb));
MAX = max(max(EXPBb));
EXPBb = (EXPBb - MIN)/(MAX - MIN);
EXPBb = adapthisteq(EXPBb);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   RGB 各个分量处理完毕    %%%%%%%%%%%%%%%%%%

% 对增强后的图像R、G、B分量进行融合
I0(:,:,1) = EXPRr;
I0(:,:,2) = EXPGg;
I0(:,:,3) = EXPBb;

% 显示运行结果
subplot(121),imshow(I);
subplot(122),imshow(I0);