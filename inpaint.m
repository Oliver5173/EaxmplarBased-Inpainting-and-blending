function [inpainted,C,D] = inpaint(im,fillColor,patch_range)
outputVideo = VideoWriter('./sample.avi');
outputVideo.FrameRate = 10;
open(outputVideo);
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

disp('define texture box,enter q to stop, only select letf up and right down corner;');
figure(1), hold off, imagesc(uint8(im)), axis image;
sx = [];
sy = [];
while 1
    figure(1);
    [x, y, z] = ginput(1);
    if z=='q'
        break;
    end
    sx(end+1) = x;
    sy(end+1) = y;
    hold on, plot(sx, sy, '*-');
end
if(size(sx,2) == 0)
    sx = [1,w];
    sy = [1,h];
end
sy = ceil(sy(1)) : ceil(sy(2));
sx = ceil(sx(1)) : ceil(sx(2));
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
    temp_inpainted = inpainted(sy,sx,:);
    examplar = getExemplar(temp_inpainted,inpainted(r,c,:),fillRegion',sourceRegion(sy,sx));
    
    for ch = 1:b
        inpainted(patch(fillRegion) + (ch - 1)*h*w) = temp_inpainted(examplar(fillRegion) + (ch - 1)*size(sy,2)*size(sx,2));
    end
    %update C,D,targetRegion;
    targetRegion(patch(fillRegion)) = 0;
    C(patch(fillRegion)) = C(p);
    Ix(patch(fillRegion)) = Ix(examplar(fillRegion));
    Iy(patch(fillRegion)) = Iy(examplar(fillRegion));
    writeVideo(outputVideo,uint8(inpainted));
end
close(outputVideo);
end
