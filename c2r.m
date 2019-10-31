function [mr,r,image] = c2r(c)
% Give a comlex matrix, return the coordinate of x and y as matrix
r = real(c);
image = imag(c);
mr = [r;image];
end

