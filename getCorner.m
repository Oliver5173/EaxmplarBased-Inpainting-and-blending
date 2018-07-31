function [ux,uy,lx,ly] = getCorner(maskedImage)
[h,w,~] = size(maskedImage);
flag = false;
for y = 1:h
    if flag
        break;
    end
    for x = 1:w
        if(maskedImage(y,x,1) > 0 || maskedImage(y,x,2) > 0 || maskedImage(y,x,3) > 0 )
            uy = y;
            flag = true;
            break;
        end
    end
end
flag = false;
for y = h:-1:1
    if flag
        break;
    end
    for x = 1:w
        if(maskedImage(y,x,1) > 0 || maskedImage(y,x,2) > 0 || maskedImage(y,x,3) > 0 )
            ly = y;
            flag = true;
            break;
        end
    end
end
flag = false;
for x = 1:w
    if flag
        break;
    end
    for y = 1:h
        if(maskedImage(y,x,1) > 0 || maskedImage(y,x,2) > 0 || maskedImage(y,x,3) > 0 )
            ux = x;
            flag = true;
            break;
        end
    end
end
flag = false;
for x = w:-1:1
    if flag
        break;
    end
    for y = 1:h
        if(maskedImage(y,x,1) > 0 || maskedImage(y,x,2) > 0 || maskedImage(y,x,3) > 0 )
            lx = x;
            flag = true;
            break;
        end
    end
end
end
