function [im_s2, mask2] = alignSource(im_s, mask, im_t)
%had been rewriten
figure, hold off, imagesc(uint8(im_t)), axis image
[tx, ty] = ginput(1);
tx = floor(tx);
ty = floor(ty);
[h,w,~] = size(im_s);
[th,tw,~] = size(im_t);
r = max(ty,1): min(ty + h - 1, th);
c = max(tx,1): min(tx + w - 1, tw);
im_s2 = zeros(th,tw,3);
im_s2(r,c,:) = im_s(:,:,:);
mask2 = zeros(th,tw);
mask2(r,c) = mask;
end
