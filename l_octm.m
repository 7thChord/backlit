function out=l_octm(img,S0)
% imgpath = strcat('./backlit/',filename,'.jpg');
% maskpath = strcat('./backlit/',filename,'_guided.png');
% 
% img = imread(imgpath);
% S0 = double(imread(maskpath))/255;

lab = rgb2yuv(img);
y = lab(:,:,1);
S0 = double(S0(:,:,1));

[h w]=size(y);
% S0 = imguidedfilter(S0,img,'DegreeOfSmoothing',0.01,'NeighborhoodSize',round(min(h,w)/20));
% S0(S0>1)=1; S0(S0<0)=0;

S = S0>0.5;
W = S0<0.5;
simg = uint8(y(S));
wimg = uint8(y(W));

Hs = imhist(simg)/length(simg);
Hw = imhist(wimg)/length(wimg);

%detect dynamic range
Cs = cumsum(Hs);
Cw = cumsum(Hw);
ts2=0;ts1=256;tw=0;
for i=1:256
    if Cs(i)>0.1 ts2=i; break; end
end
for i=256:-1:1
    if Cs(i)<0.9 ts1=i; break; end
end
for i=1:256
    if Cw(i)>0.8 tw=i; break; end
end
gs = min(256/(ts1-ts2),5)
gw = min(256/tw,3)

%Use OCTM to get the optimal tone mapping.
%The 2nd parameter ~ Global contrast gain.
Ts = OCTM_hist(Hs,gs);
Tw = OCTM_hist(Hw,gw);

figure;
% subplot(211);
% hold on; plot(Ts/255,'r'); plot(Tw/255,'b');
% plot(Hs/max(Hs),'g'); plot(Hw/max(Hw),'m');

%Regionwise enhancement.
%2nd parameter: S-region map.
%3rd, 4th parameter: S-region & W-region tone mapping

out = d_trans_lmask(img,S0,Ts,Tw);
subplot(121);imshow(S0);
subplot(122);imshow(uint8(out));
% imwrite(uint8(out),strcat('./backlit/',filename,'_octm2.png'));