function [inpainted,C,D] = inpaint(im,fillColor)
im = double(im);
inpainted = im;
[h,w,c] = size(im);
%define target region.
for i = 1:h
    for j = 1:w
        targetRegion(i,j) = im(i,j,1) == fillColor(1) && im(i,j,2) == fillColor(2) && im(i,j,3) == fillColor(3);
    end
end
sourceRegion = ~targetRegion;
%initialization
alpha = 255;
%isophote(direction and intensity) at point P.
[Ix Iy] = gradient(im);
Ix = sum(Ix,3) / c;
Iy = sum(Iy,3) / c;
%confidence
C = double(~targetRegion);

while(any(targetRegion(:)))
    contour = find(conv2(targetRegion,[1,1,1;1,-8,1;1,1,1],'same')>0);
    %N is normal to the contour.
    [Nx,Ny] = gradient(double(~targetRegion));
    N = normr([Nx(contour(:)) Ny(contour(:))]);
    N(~isfinite(N))=0;
    %calculate confidence
    for p = contour'
        %unfinished
        patch = getpatch(p,patchsize);
        q = patch(~targetRegion(patch));
        C(p) = sum(C(q)) / numel(patch);
    end
    %calculate data
    D = abs(Ix(contour) * N(:,1) + Iy(contour) * N(:,2)) / alpha;
    %priorities
    P = C(contour)*D(contour);
    %find fill point.
    [~,idx] = max(P);
    p = contour(idx);
    [patch,r,c] = getPatch(p,patchsize);
    %fillRegion stores boolean values
    fillRegion = targetRegion(patch);
    %find to-fill patch with minium error;
    q = bestexemplar(im,im(r,c,:),fillRegion',sourceRegion);
    for ch = 1:c
        inpainted(patch(fillRegion),c) = inpainted(q(fillRegion),c);
    end
    %update C,D,targetRegion;
    C(patch(fillRegion)) = C(p);
    Ix(patch(fillRegion)) = Ix(q(fillRegion));
    Iy(patch(fillRegion)) = Iy(q(fillRegion));
    targetRegion(patch(fillRegion)) = 0;
    targetRegion = logical(targetRegion);
    
end 
end
