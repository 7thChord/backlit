function Image_out=d_trans_lmask(img, Lmask, Tmask, Text)

%img = imread(imgPath);
[w h d]=size(img);

yuv = rgb2yuv(img);
I = round(yuv(:,:,1));

% yuv = rgb2hsi(img);
% I = round(yuv(:,:,3)*255);

Iout=I;
for i=1:w
    for j=1:h
        Iout(i,j) = Lmask(i,j)*(Tmask(I(i,j)+1)-1)+...
            (1-Lmask(i,j))*(Text(I(i,j)+1)-1);
    end
end

Image_out=zeros(w,h,d);
L=double(Iout);
for i=1:w
    for j=1:h
        M=max(img(i,j,:));
        %Approach 1: BLACK -> Linear to R/G/B Border -> Linear to WHITE
        if (M==0 || I(i,j)==0)
            Image_out(i,j,:)=0;
        elseif (L(i,j)/I(i,j)*M<=255)
            Image_out(i,j,:)=L(i,j)/I(i,j)*img(i,j,:);
        else
            l=255/M; t=l*img(i,j,:); l=l*I(i,j);
            Image_out(i,j,:)=((255-L(i,j))*t+255*(L(i,j)-l))/(255-l);
        end

    end
end

% yuv(:,:,1) = Iout;
% Image_out = yuv2rgb(yuv);

% yuv(:,:,3) = Iout/255;
% Image_out = hsi2rgb(yuv);
% Image_out = uint8(Image_out*255);

Image_out = uint8(Image_out);

% figure;imshow(Image_out);