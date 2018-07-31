function [inpainted,C,D] = inpaint(im,fillColor,patch_range)
inpainted = double(im);
[h,w,b] = size(inpainted);
%define target region.
for i = 1:h
    for j = 1:w
        targetRegion(i,j) = inpainted(i,j,1) == fillColor(1) && inpainted(i,j,2) == fillColor(2) && inpainted(i,j,3) == fillColor(3);
    end
end
sourceRegion = ~targetRegion;
%initialization
alpha = 255;
%isophote(direction and intensity) at point P.
[Ix,Iy] = gradient(inpainted);
Ix = sum(Ix,3) / b;
Iy = sum(Iy,3) / b;
%rotate 90 degree
temp = Ix;
Ix = -Iy;
Iy = temp;
%confidence
C = double(~targetRegion);
%data
D = C;
%use for debug
iteration = 0;
while(any(targetRegion(:)))
    iteration = iteration + 1;
    contour = find(conv2(targetRegion,[1,1,1;1,-8,1;1,1,1],'same')>0);
    %N is normal to the contour.
    [Nx,Ny] = gradient(double(~targetRegion));
    N = normr([Nx(contour(:)) Ny(contour(:))]);
    N(~isfinite(N))=0;
    %calculate confidence
    for p = contour'
        %p is point index of inpainted.
        [patch,~,~] = getPatch(p,patch_range,h,w);
        q = patch(~(targetRegion(patch)));
        C(p) = sum(C(q)) / numel(patch);
    end
    %calculate data
    D(contour) = abs(Ix(contour).*N(:,1)+Iy(contour).*N(:,2)) / alpha;
    %priorities
    P = C(contour).*D(contour);
    %find fill point.
    [~,idx] = max(P);
    p = contour(idx);
    [patch,r,c] = getPatch(p,patch_range,h,w);
    %fillRegion stores boolean values
    fillRegion = targetRegion(patch);
    %find to-fill patch with minium error;
    examplar = getExemplar(inpainted,inpainted(r,c,:),fillRegion',sourceRegion);
    for ch = 1:b
        inpainted(patch(fillRegion) + (ch - 1)*h*w) = inpainted(examplar(fillRegion) + (ch - 1)*h*w);
    end
    %update C,D,targetRegion;
    targetRegion(patch(fillRegion)) = 0;
    C(patch(fillRegion)) = C(p);
    Ix(patch(fillRegion)) = Ix(examplar(fillRegion));
    Iy(patch(fillRegion)) = Iy(examplar(fillRegion));
end 
end
