close all;
%paramaters
scalar = 0.25;

im = imread('bungee0.png');
mask = getMask(im);
[obj,objmask] = resizer(im,mask,scalar);
filledIm = fileTofill(im,~mask);
[inpainted,C,D] = inpaint(filledIm,[0 255 0]);

[im_s,mask_s] = alignSource(im_object,objmask,im_background);
result = mixedBlend(im_s,mask_s,inpainted);
