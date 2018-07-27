function [inpainted,confidence,data] = inpaint(im,fillColor)
im = double(im);
[h,w,c] = size(im);
%define target region.
for i = 1:h
    for j = 1:w
        targetRegion(i,j) = im(i,j,1) == fillColor(1) && im(i,j,2) == fillColor(2) && im(i,j,3) == fillColor(3);
    end
end
%initialization
alpha = 255;
%isophote(direction and intensity) at point P.
[Ix Iy] = gradient(im);
Ix = sum(Ix,3) / c;
Iy = sum(Iy,3) / c;
%confidence
C = ~targetRegion;

while(any(targetRegion(:)))
    contour = find(conv2(targetRegion,[1,1,1;1,-8,1;1,1,1],'same')>0);
    
    
end
