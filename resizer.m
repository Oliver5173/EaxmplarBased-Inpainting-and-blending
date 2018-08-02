function [resized,objmask] = resizer(im,mask,scaler)
mask = double(mask);
masked = double(im).*mask;
[ux,uy,lx,ly] = getCorner(masked);
resized = imresize(masked(uy:ly,ux:lx,:),scaler,'nearest');
objmask = imresize(mask(uy:ly,ux:lx,:),scaler,'nearest');

%% for testing
imshow(uint8(resized));
end
