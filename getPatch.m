function [patch,r,c] = getPatch(p_ind, range,h,w)
x = ceil(p_ind / h);
y = rem(p_ind,h);
r = max(1,y-range):min(h,y+range);
c = max(1,x-range):min(w,x+range);
% len_r = size(r,2);
% len_c = size(c,2);
patch = zeros(size(r,2),size(c,2));
i = 1;
for j = c
    for k = r
        patch(i) = (j - 1) * h + k;
        i = i + 1;
    end
end

end
