function R = ZRotation(theta)
%This function return a rotation matrix along Z axis
%   此处显示详细说明
R = [cos(theta), -sin(theta), 0; sin(theta), cos(theta), 0;0,0,1];
end

