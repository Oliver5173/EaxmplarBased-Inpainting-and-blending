close all;

%% cut the object out and hole filling
%
im = imread('1.jpg');
mask_obj = getMask(im); 
mask_BW = ~mask_obj;
tofill = fileTofill(im,mask_BW);
imshow(uint8(tofill));
% inpaint2(imread('bungee1.png'),imread('bungee1.png'),[0 255 0]);
inpaint(tofill,[0 255 0]);


%% take the cutted out object and resize
% obj(:,:,1) = double(mask_obj) .* double(im(:,:,1));
% obj(:,:,2) = double(mask_obj) .* double(im(:,:,2));
% obj(:,:,3) = double(mask_obj) .* double(im(:,:,3));
% imshow(uint8(imresize(obj, 0.5)));
[im_resized, mask_new] = resizer(im, mask_obj,0.5);

imshow(uint8(im_resized));