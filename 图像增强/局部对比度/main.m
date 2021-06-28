clear all;
clc;
Img = imread('2.jpg');
Img = rgb2gray(Img);
imwrite(Img,'1.png')
W = fspecial('gaussian',[5,5],1); 
G = imfilter(Img, W, 'replicate');
image = double(G) + double((Img-G)) .* ACE(Img);
imwrite(mat2gray(image),'2.png');