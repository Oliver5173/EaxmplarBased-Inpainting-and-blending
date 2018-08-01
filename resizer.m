function [resized,objmask] = resizer(im,mask,scaler)
mask = double(mask);
masked = double(im).*mask;
[ux,uy,lx,ly] = getCorner(masked);
resized = imresize(masked(uy:ly,ux:lx,:),scaler,'bilinear');
objmask = imresize(mask(uy:ly,ux:lx,:),scaler,'bilinear');

%% for testing
imshow(uint8(resized));
end
