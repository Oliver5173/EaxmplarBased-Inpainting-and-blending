function [examplar] = getExemplar(im,Ip,fillRegion,sourceRegion)
% r and c are patch location
% fillRegion contains to-fill point index
% souceRegion is original part of img(logical values)
[h,w,~] = size(im);
examplar_location = exemplarhelper(h,w,size(Ip,1),size(Ip,2),im,Ip,fillRegion,sourceRegion);
r = examplar_location(1) : examplar_location(2);
c = examplar_location(3) : examplar_location(4);
examplar = zeros(size(r,2),size(c,2));
i = 1;
for j = c
    for k = r
        examplar(i) = (j - 1) * h + k;
        i = i + 1;
    end
end
examplar = examplar';
end
