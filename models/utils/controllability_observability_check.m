clc;
clear;
close all;
% Define state-space variable matrices
A = [0 1 0 0 0;
    1 0 -1 0 1;
    0 0 0 1 0;
    0 0 0 0 -1;
    0 -1 0 -1 0];
B = [0 0;
    1 -1;
    0 0;
    0 0;
    1 1];
C = [1 1 1 1 1];
D = [0 0];
% Create state-space model
sys = ss(A,B,C,D);
% Check controllability
co = ctrb(A,B);
rank_co = rank(co);
if rank_co == size(A,1)
    disp('the system is completely controllable');
else 
    disp('the system is not completely controllable');
end 
% Check observability 
ob = obsv(A,C);
rank_co = rank(ob);
if rank_co == size(A,1)
    disp('the system is completely observable');
else
    disp('the system is not completely observable');
end
% Display the matrices 
disp('controllability matrix:');
disp(co);
disp('observability matrix:');
disp(ob);

