

gfI = double(imread('lena512.png'));
% gfI = rgb2gray(gfI);
r0=2;r1=3;r2=4;
eps0=0.01,eps1=0.04,eps2=0.09;
% subplot(3,3,1);
gfout1_1=guidedfilter(gfI,gfI,r0,eps0);
imshow(mat2gray(gfout1_1));
title('r=2,eps=0.01');