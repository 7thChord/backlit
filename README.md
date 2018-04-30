# Backlit Image Restoration Project

Here's the source code to the TIP paper "Learning-based Backlit Image Restoration"
https://ieeexplore.ieee.org/abstract/document/8101559/

The MATLAB code relies on:
VLFEAT library (www.vlfeat.org/)
MaxFlow v3.01 library (http://vision.csd.uwo.ca/code/)
Please find the zip packages in the root folder, unzip them, and include them before run.

Usage:
run "backlit_demo" function at the package folder
out = backlit_demo(img)
img: input, the RGB image loaded from imread()
out: output RGB image.

Test set available in "backlit_data.zip".

Z. Li
