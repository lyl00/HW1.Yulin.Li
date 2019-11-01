%% In this code, we establish the configuration of Michell Truss of order 4 of BOB'S book with single
%% load applied on the node n00 on Michell Topology.
%% To finish this task, first we read Prof.bewley's paper and 4.1-4.3 of Bob's book.
%% Then, take TBar.m and TBar3.m as reference

% add source codes to path
root = fileparts(pwd);
homework_name = "HW1.Yulin.Li";
addpath(genpath(fullfile(root,homework_name)));

% Using expoential expression to express all the vectors(complex notation)
% Define global parameter theta and beta and order q; these three parameter
% define how the topology work, while in this case, specified as follows.
phi = pi/16; beta = pi/6; q = 4;
% length of radius and line
dim = 2;
a = sin(beta)/sin(beta + phi);
c = sin(phi)/sin(beta + phi);
r = zeros(q+1,1);
for i = 0:q
    if i == 0
        r(i+1,1) = 10;%an arbitary initial
    else
        r(i+1,1) = a * r(i,1);
    end
end
p = c * r(1:q,1); % if we use bewley's toolbox, we will use M = NC' rather than use p to express m. 

% Construct original nodes matrix n(i,k), replace 0 to those unexisted elements.
N_origin = zeros(q+1,q+1);
j_complex = 1j; % complex number
num_allNodes = (q+2)*(q+1)/2;
num_fixNodes = q + 1;
num_freeNodes = num_allNodes - num_fixNodes;
 
for i = 0:q
    for k =0:q-i
       N_origin(i+1,k+1) =  r(i+k+1)*exp(j_complex*((i-k)*phi));
    end
end

% the left circle nodes are fixed while others are free, so we extract
% bewley's N from our N_origin
% I can write the extract process together, but divide fix and free nodes
% into two seperate loop is for better understanding that 

%fixed nodes
P = zeros(1,num_fixNodes);
Q = [];
for i = 1:q+1
    j = (q+2)-i;
    P(i) = N_origin(i,j);
end
%All other nodes
% decide node fall on which r
for k = q+1:-1:2
    for i = 1:k-1
        j = k-i;
        Q = [Q,N_origin(i,j)];
    end
end
Q = c2r(Q);
P = c2r(P);
N = [Q,P];%All nodes

% In this case, all members need to take both tension and compression, so we
% take them all Bars.
num_members = (1+q)*q;% half m and half of its conjugate 
num_bar = num_members;
num_string = 0;

% I can write it as a general case q order if have times.
D = zeros(num_allNodes,num_members);
D(1,1) = -1; D(6,1) = 1;
D(6,2) = -1; D(10,2) = 1;
D(10,3) = -1; D(13,3) = 1;
D(13,4) = -1; D(15,4) = 1;

D(2,5) = -1; D(7,5) = 1;
D(7,6) = -1; D(11,6) = 1;
D(11,7) = -1; D(14,7) = 1;

D(3,8) = -1; D(8,8) = 1;
D(8,9) = -1; D(12,9) = 1;

D(4,10) = -1; D(9,10) = 1;

%--------------------------conjugate------------------------%

D(5,11) = -1; D(9,11) = 1;
D(9,12) = -1; D(12,12) = 1;
D(12,13) = -1; D(14,13) = 1;
D(14,14) = -1; D(15,14) = 1;

D(4,15) = -1; D(8,15) = 1;
D(8,16) = -1; D(11,16) = 1;
D(11,17) = -1; D(13,17) = 1;

D(3,18) = -1; D(7,18) = 1;
D(7,19) = -1; D(10,19) = 1;

D(2,20) = -1; D(6,20) = 1;

D = circshift(D,-5);% a modification for misorder Q and P in deduce D
C = D';
%the force vector applied on n(i,k) is w(i,k) = w(i,k)*exp(j?(i,k))
%In this case, only single force applied on node n00
%In our code, we test for three circumstances, that is:
%1¡¢beta < theta < pi-beta
%2¡¢beta-pi < theta < -beta
%3¡¢theta = pi/2
    config = 3;
switch config
    case 1
        theta = 2/(3*pi);    
    case 2
        theta = -2/(3*pi);
    otherwise
        theta = pi/2;
end
w = 0.1;
w = w * exp(j_complex*theta);
U = zeros(dim,num_freeNodes);
U(1,num_freeNodes) = real(w);
U(2,num_freeNodes) = imag(w);

%----use bewley's function to calculate the static and plot---------%

[c_bars,t_strings,V]=tensegrity_statics(num_bar,num_string,num_freeNodes,num_fixNodes, ...
    dim,Q,P,C,U);

tensegrity_plot(Q,P,C,num_bar,num_string,U,V,true,2.0); grid on;





