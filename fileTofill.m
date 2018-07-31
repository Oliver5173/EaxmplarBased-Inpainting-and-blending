function file = fileTofill(im,mask)
%     im = imread('1.jpg');
    im = double(im);
    mask = double(mask);
    file(:,:,1) = mask .* im(:,:,1);
    file(:,:,2) = mask .* im(:,:,2);
    file(:,:,3) = mask .* im(:,:,3);
    
    [h,w,~] = size(im);
    for i = 1:h
        for j = 1:w
            if (mask(i,j) == 0)
                file(i,j,1)= 0;
                file(i,j,2)= 255;
                file(i,j,3)= 0;
            end
        end   
    end
    
end