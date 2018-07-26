RGB = imread('im1.jpg');
imshow(RGB);
h1 = impoly(gca,[309 500;247 498;217 102;256 163;352 157;386 99;356 499],'Closed',false);
foresub = getPosition(h1);
foregroundInd = sub2ind(size(RGB),foresub(:,2),foresub(:,1));
h2 = impoly(gca,[55 465;203 18],'Closed',false);
backsub = getPosition(h2);
backgroundInd = sub2ind(size(RGB),backsub(:,2),backsub(:,1));

L = superpixels(RGB,10500);
BW = lazysnapping(RGB,L,foregroundInd,backgroundInd);
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
figure; 
imshow(maskedImage);
