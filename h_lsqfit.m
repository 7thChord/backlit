function [Sh,Ss]=h_lsqfit(img)
[w,h,~]=size(img);
yuv=rgb2yuv(img);
Y=yuv(:,:,1);Y=uint8(Y);
H=imhist(Y);
H=H/max(H);

init=[1;0;20;1;255;20];
p=lsqcurvefit(@gmm,init,0:255,H');
f1=p(1)*normpdf(0:255,p(2),p(3));
f2=p(4)*normpdf(0:255,p(5),p(6));
[~,watershed]=min(f1+f2);
Sh=Y<=watershed;

m=floor(p(2))+1; M=ceil(p(5))+1;
if (m<1) m=1; end
if (M>256) M=256; end
seg=zeros(256,1);
for i=m:M
    seg(i)=f1(i)/(f1(i)+f2(i));
end
seg(1:m)=1;
Ss=zeros(w,h);
for i=1:w
    for j=1:h
        Ss(i,j)=seg(Y(i,j)+1);
    end
end

figure;hold on;
plot(H,'g');
plot((f1+f2)/max(f1+f2),'r');

w
p'

end

function f=gmm(p,x)
%params = [p1,m1,s1,p2,m2,s2]
f = p(1)/p(3)*exp(-(x-p(2)).^2/p(3).^2*0.5)+p(4)/p(6)*exp(-(x-p(5)).^2/p(6).^2*0.5);
end
