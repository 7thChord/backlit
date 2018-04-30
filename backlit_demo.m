function out=backlit_demo(img)
%the algorithm is not optimized thus with quite low time efficency.
%image no larger than 400*300 is recommended.

run('vlfeat/toolbox/vl_setup');
addpath('maxflow');

[w h ~]=size(img);
lab=rgb2Lab(img);

sp = double(vl_slic(single(lab), 40, 1))+1;

load('svm_116.mat');
load('svm_border.mat');
S=l_applysvm_sp23n(img,sp,svm_116,svm_border);
out=l_octm(img,S);
