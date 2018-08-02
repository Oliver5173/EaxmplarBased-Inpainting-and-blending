close all;
%paramaters
im_scalar = 0.8; % resize to the desired resolution for the read in image
scalar = 0.5;
patch_range = 3; % patch size = (patch_range * 2 + 1) ^ 2;

im = imresize( imread('./bungee0.jpg'), im_scalar , 'bilinear');
mask = getMask(im);
[obj,objmask] = resizer(im,mask,scalar);
filledIm = fileTofill(im,~mask);
[inpainted,C,D] = inpaint(filledIm,[0 255 0],patch_range);

[im_s,mask_s] = alignSource(obj,objmask,inpainted);
mixBlended = mixedBlend(im_s,mask_s,inpainted);
poissonBlended = poissonBlend(im_s,mask_s,inpainted);
figure;
subplot(231);image(uint8(im)); title('Original image');
subplot(232);image(uint8(poissonBlended)); title('Poisson Result');
subplot(233);image(uint8(mixBlended)); title('Mixed Bleding Result');
