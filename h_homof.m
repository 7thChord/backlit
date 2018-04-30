function z = h_homof(img)

[h w d] = size(img);
yuv = rgb2yuv(img);
epsilon = 1e-6;
y = yuv(:,:,1)+epsilon;
ly = log(y);

f = fftshift(fft2(ly));
g = zeros(h,w);
sigma = min([w h])/30;
% sigma = diag(min([w h])/10*ones(1,2));
% [Px Py]=meshgrid(1:h,1:w);
% P = [reshape(Px,h*w,1),reshape(Py,h*w,1)];
% g = mvnpdf(P,[h/2+0.5 w/2+0.5],sigma);
% g = reshape(g,h,w);
for x=1:w
    for y=1:h
        g(y,x) = normpdf(norm([x-(w/2+0.5) y-(h/2+0.5)]),0,sigma);
    end
end

g = g/max(max(g));
%figure; imshow(g);
f = ifftshift(f.*g);
z = real(exp(ifft2(f)));

% figure;imshow(z/100);