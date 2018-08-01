function [img] = mixedBlend(s,mask,t)
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
           s_gradient = s(y,x,c) - s(y - 1,x,c);
           t_gradient = t(y,x,c) - t(y - 1,x,c);
           if(abs(t_gradient) < abs(s_gradient))
               b(e) = b(e) + s_gradient;
           else
               b(e) = b(e) + t_gradient; 
           end
       else
           b(e) = b(e) + t(y - 1,x,c); 
       end
       
       if(mask(y + 1,x))
           A(e,im2var(y + 1,x)) = -1;
           s_gradient = s(y,x,c) - s(y + 1,x,c);
           t_gradient = t(y,x,c) - t(y + 1,x,c);
           if(abs(t_gradient) < abs(s_gradient))
               b(e) = b(e) + s_gradient;
           else
               b(e) = b(e) + t_gradient; 
           end
       else
           b(e) = b(e) + t(y + 1,x,c); 
       end
       
       if(mask(y,x - 1))
           A(e,im2var(y,x - 1)) = -1;
           s_gradient = s(y,x,c) - s(y,x - 1,c);
           t_gradient = t(y,x,c) - t(y,x - 1,c);
           if(abs(t_gradient) < abs(s_gradient))
               b(e) = b(e) + s_gradient;
           else
               b(e) = b(e) + t_gradient; 
           end
       else
           b(e) = b(e) + t(y,x - 1,c); 
       end
       
       if(mask(y,x + 1))
           A(e,im2var(y,x + 1)) = -1;
           s_gradient = s(y,x,c) - s(y,x + 1,c);
           t_gradient = t(y,x,c) - t(y,x + 1,c);
           if(abs(t_gradient) < abs(s_gradient))
               b(e) = b(e) + s_gradient;
           else
               b(e) = b(e) + t_gradient; 
           end
       else
           b(e) = b(e) + t(y,x + 1,c); 
       end
       e = e+1;
   end
   v{c} = lscov(A, b);
   v{c}(v{c} < 0) =  0;
end
for i = 1:counts
    for c = 1:imb
        img(yy(i),xx(i),c) = v{c}(i);
    end
end
end
