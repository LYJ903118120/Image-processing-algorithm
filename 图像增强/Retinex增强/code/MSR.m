f=imread('1vis.png');


mr=im2double(f);
n=141;%����ģ���С�� kid=141��
n1=floor((n+1)/2);%ȷ������

a1=60; %�����׼��߶ȣ� kid=60��
for i=1:n
for j=1:n
b(i,j) =exp(-((i-n1)^2+(j-n1)^2)/(a1*a1))/(pi*a1*a1); %��˹������
end
end

nr1=imfilter(mr,b,'conv','replicate');


ur1=log(nr1);
tr1=log(mr+eps);
yr1=(tr1-ur1)/3;

a2=10; %�����׼��߶ȣ�
for i=1:n
33
for j=1:n
a(i,j) =exp(-((i-n1)^2+(j-n1)^2)/(a2*a2))/(pi*a2*a2); %��˹������
end
end
nr2=imfilter(mr,a,'conv','replicate');

ur2=log(nr2);
tr2=log(mr+eps);
yr2=(tr2-ur2)/3;

a3=150; %�����׼��߶ȣ�kid=150��
for i=1:n
for j=1:n
e(i,j) =exp(-((i-n1)^2+(j-n1)^2)/(a3*a3))/(pi*a3*a3); %��˹������
end
end
nr3=imfilter(mr,e,'conv','replicate');

ur3=log(nr3);
tr3=log(mr+eps);
yr3=(tr3-ur3)/3;


dr=yr1+yr2+yr3;
cr=im2uint8(dr);
subplot(1,2,1);imshow(f);title('ԭͼ');
subplot(1,2,2);imshow(cr);title('MSR �����');%��ʾ������ͼ��