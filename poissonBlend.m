function [img] = poissonBlend(s,mask,t)
[imh,imw,imb] = size(t);
im2var = zeros(imh,imw);
img = t .* (1 - mask);
%building map;
[yy,xx] = find(mask>0);
counts = size(yy,1);
e = 1;
v = {};
for i = 1:counts
    im2var(yy(i),xx(i)) = e;
    e = e + 1;
end
%rgb
for c = 1:imb
    A = sparse([], [], [], counts, counts );
    b = zeros(counts,1);
    e = 1;
   for i = 1:counts
       y = yy(i);
       x = xx(i);
       A(e,im2var(y,x)) = 4;
       if(y >= imh)
           y = imh - 1;
       end
       if(x >= imw)
           x = imw - 1;
       end
       
       if(mask(y - 1,x))
           A(e,im2var(y - 1,x)) = -1;
           b(e) = b(e) + s(y,x,c) - s(y - 1,x,c); 
       else
           b(e) = b(e) + t(y - 1,x,c); 
       end
       
       if(mask(y + 1,x))
           A(e,im2var(y + 1,x)) = -1;
           b(e) = b(e) + s(y,x,c) - s(y + 1,x,c); 
       else
           b(e) = b(e) + t(y + 1,x,c); 
       end
       
       if(mask(y,x - 1))
           A(e,im2var(y,x - 1)) = -1;
           b(e) = b(e) + s(y,x,c) - s(y,x - 1,c); 
       else
           b(e) = b(e) + t(y,x - 1,c); 
       end
       
       if(mask(y,x + 1))
           A(e,im2var(y,x + 1)) = -1;
           b(e) = b(e) + s(y,x,c) - s(y,x + 1,c); 
       else
           b(e) = b(e) + t(y,x + 1,c); 
       end
       e = e+1;
   end
   v{c} = lscov(A, b); 
end
for i = 1:counts
    for c = 1:imb
        img(yy(i),xx(i),c) = v{c}(i);
    end
end
end
