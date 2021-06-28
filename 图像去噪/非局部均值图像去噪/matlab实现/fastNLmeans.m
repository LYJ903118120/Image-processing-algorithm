function DenoisedImg=fastNLmeans(I,ds,Ds,h)
%I:含噪声图像
%ds:邻域窗口半径
%Ds:搜索窗口半径
%h:高斯函数平滑参数
%DenoisedImg：去噪图像
I=double(I);
[m,n]=size(I);
PaddedImg = padarray(I,[Ds+ds+1,Ds+ds+1],'symmetric','both');
PaddedV = padarray(I,[Ds,Ds],'symmetric','both');
average=zeros(m,n);
sweight=average;
wmax=average;
h2=h*h;
d2=(2*ds+1)^2;
for t1=-Ds:Ds
    for t2=-Ds:Ds
        if(t1==0&&t2==0)
            continue;
        end
        St=integralImgSqDiff(PaddedImg,Ds,t1,t2);
        v = PaddedV(1+Ds+t1:end-Ds+t1,1+Ds+t2:end-Ds+t2);
        w=zeros(m,n);
        for i=1:m
            for j=1:n
                i1=i+ds+1;
                j1=j+ds+1;
                Dist2=St(i1+ds,j1+ds)+St(i1-ds-1,j1-ds-1)-St(i1+ds,j1-ds-1)-St(i1-ds-1,j1+ds);%欧式距离用积分图计算。
                Dist2=Dist2/d2;
                w(i,j)=exp(-Dist2/h2);
                sweight(i,j)=sweight(i,j)+w(i,j);
                average(i,j)=average(i,j)+w(i,j)*v(i,j);
            end
        end
        wmax=max(wmax,w);
    end
end
average=average+wmax.*I;
sweight=sweight+wmax;
DenoisedImg=average./sweight;



function Sd = integralImgSqDiff(PaddedImg,Ds,t1,t2)
%PaddedImg：边缘填充后的图像
%Ds:搜索窗口半径
%(t1,t2):偏移量
%Sd:积分图像
[m,n]=size(PaddedImg);
m1=m-2*Ds;
n1=n-2*Ds;
Sd=zeros(m1,n1);
Dist2=(PaddedImg(1+Ds:end-Ds,1+Ds:end-Ds)-PaddedImg(1+Ds+t1:end-Ds+t1,1+Ds+t2:end-Ds+t2)).^2;
for i=1:m1
    for j=1:n1
         if i==1 && j==1
             Sd(i,j)=Dist2(i,j);
         elseif i==1 && j~=1
             Sd(i,j)=Sd(i,j-1)+Dist2(i,j); 
         elseif i~=1 && j==1
             Sd(i,j)=Sd(i-1,j)+Dist2(i,j);
         else
             Sd(i,j)=Dist2(i,j)+Sd(i-1,j)+Sd(i,j-1)-Sd(i-1,j-1);
         end
     end
end