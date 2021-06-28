close all;
clear all;
clc
I=double(imread('ԭͼ.png'));
I=I+10*randn(size(I));
tic
O1=fastNLmeans(I,2,5,10);
toc
imshow([I,O1],[]);
imwrite(mat2gray(I),'I.png');
imwrite(mat2gray(O1),'01.png');
