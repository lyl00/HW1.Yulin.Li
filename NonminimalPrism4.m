%% In this code, we establish the configuration of  for a non minimal tensegrity prism with 4 bars 
%% as shown in Figure 3.43 of Bob¡¯s book, but with 4 bars (all nodal points are taken as free nodes Q_i
%% To finish this task, first we read Prof.bewley's paper and Figure 3.43 and of Bob's book.
%% The 4 bars configuration is actually as Figure 1.26, it has 4 bars and 16 string and 8 free nodes

% add source codes to path
root = fileparts(pwd);
homework_name = "HW1.Yulin.Li";
addpath(genpath(fullfile(root,homework_name)));

% Based on Figure 1.26, we manually define three parameters to give a configuration of this structure
a_large = 9; % side length of the bigger square
a_small = 3; % side length of the smaller square
H = 10; % the height of the structure
theta = -pi/6; % the rotation angle of the smaller square, positive as couterclockwise

% Then I write a 3D rotation matrix regarding to the z axis as a function(because the matlab 2019 is new
% in my computer, not many toolbox contains that function included...);

Q = zeros(3,8);
Q(:,1) = [-4.5;4.5;0];
Q(:,2) = ZRotation(pi/2) * Q(:,1) ;
Q(:,3) = ZRotation(pi/2) * Q(:,2);
Q(:,4) = ZRotation(pi/2) * Q(:,3); 

Q(:,5) = ZRotation(theta) * [-1.5;1.5;H];
Q(:,6) = ZRotation(pi/2) * Q(:,5);
Q(:,7) = ZRotation(pi/2) * Q(:,6);
Q(:,8) = ZRotation(pi/2) * Q(:,7);
P = [];

% Then construct matrix D, that is C'
dim = 3;
num_allNodes = 8;
num_fixNodes = 0;
num_freeNodes = num_allNodes - num_fixNodes;
num_allMembers = 20;
num_bars = 4;
num_strings = 16;
D = zeros(num_allNodes,num_allMembers);
%----------for bars--------------%
D(1,1) = -1; D(7,1) = 1;
D(2,2) = -1; D(8,2) = 1;
D(3,3) = -1; D(5,3) = 1;
D(4,4) = -1; D(6,4) = 1;

%----------for strings-----------%
D(1,5) = -1; D(2,5) = 1;
D(2,6) = -1; D(3,6) = 1;
D(3,7) = -1; D(4,7) = 1;
D(4,8) = -1; D(1,8) = 1;

D(5,9) = -1; D(6,9) = 1;
D(6,10) = -1; D(7,10) = 1;
D(7,11) = -1; D(8,11) = 1;
D(8,12) = -1; D(5,12) = 1;

D(1,13) = -1; D(5,13) = 1;
D(1,14) = -1; D(6,14) = 1;
D(2,15) = -1; D(6,15) = 1;
D(2,16) = -1; D(7,16) = 1;

D(3,17) = -1; D(7,17) = 1;
D(3,18) = -1; D(8,18) = 1;
D(4,19) = -1; D(5,19) = 1;
D(4,20) = -1; D(8,20) = 1;

C = D';

%------give arbitary force to the system------%
% should be careful with the U, because all nodes are free so that total U
% need to be zero.
U = zeros(dim,num_freeNodes);
U(3,1:4) = 0.3;
U(3,5:8) = -0.3;




%----use bewley's function to calculate the static and plot---------%

[c_bars,t_strings,V]=tensegrity_statics(num_bars,num_strings,num_freeNodes,num_fixNodes, ...
    dim,Q,P,C,U);

tensegrity_plot(Q,P,C,num_bars,num_strings,U,V,true,2.0); grid on;





