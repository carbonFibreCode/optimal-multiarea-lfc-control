clc;
clear;
close all;

%% =========================================================
% TWO AREA LOAD FREQUENCY CONTROL
% Primary Governor Control
% Load disturbance occurs in Area-1
%% =========================================================

%% ---------------- AREA-1 PARAMETERS ----------------

Tg1 = 0.2;          % Governor time constant (sec)
Tt1 = 1.0;          % Turbine time constant (sec)
Tp1 = 10;           % Power system time constant (sec)
Kp1 = 100;          % Power system gain (Hz/pu)
R1  = 0.05;         % Speed regulation (Hz/pu)

%% ---------------- AREA-2 PARAMETERS ----------------

Tg2 = 0.2;
Tt2 = 1.0;
Tp2 = 10;
Kp2 = 100;
R2  = 0.05;

%% ---------------- TIE-LINE ----------------

T12 = 0.05;         % Synchronizing coefficient

%% ---------------- LOAD DISTURBANCE ----------------

DeltaPL1 = 0.05;    % Load increase in Area-1
DeltaPL2 = 0;       % No load change in Area-2

%% ---------------- SIMULATION TIME ----------------

t = 0:0.01:100;

%% =========================================================
% STATE VECTOR
%
% x(1) = Delta f1
% x(2) = Delta Pg1 (Governor output)
% x(3) = Delta Pm1 (Turbine output)
% x(4) = Delta f2
% x(5) = Delta Pg2
% x(6) = Delta Pm2
% x(7) = Delta Ptie
%% =========================================================

%% State-space matrix

A = zeros(7,7);

%% -------- AREA 1 --------

% d(Delta f1)/dt
A(1,1) = -1/Tp1;
A(1,3) = Kp1/Tp1;
A(1,7) = -Kp1/Tp1;

% d(Delta Pg1)/dt
A(2,1) = -1/(R1*Tg1);
A(2,2) = -1/Tg1;

% d(Delta Pm1)/dt
A(3,2) = 1/Tt1;
A(3,3) = -1/Tt1;

%% -------- AREA 2 --------

% d(Delta f2)/dt
A(4,4) = -1/Tp2;
A(4,6) = Kp2/Tp2;
A(4,7) = Kp2/Tp2;

% d(Delta Pg2)/dt
A(5,4) = -1/(R2*Tg2);
A(5,5) = -1/Tg2;

% d(Delta Pm2)/dt
A(6,5) = 1/Tt2;
A(6,6) = -1/Tt2;

%% -------- TIE-LINE --------

% d(Delta Ptie)/dt
A(7,1) = 2*pi*T12;
A(7,4) = -2*pi*T12;

%% =========================================================
% INPUT MATRIX
%% =========================================================

B = zeros(7,2);

% Area-1 load disturbance
B(1,1) = -Kp1/Tp1;

% Area-2 load disturbance
B(4,2) = -Kp2/Tp2;

%% =========================================================
% OUTPUT MATRIX
%% =========================================================

% Outputs:
% y1 = Delta f1
% y2 = Delta f2
% y3 = Delta Ptie

C = zeros(3,7);

C(1,1) = 1;
C(2,4) = 1;
C(3,7) = 1;

D = zeros(3,2);

%% =========================================================
% STATE SPACE MODEL
%% =========================================================

sys = ss(A,B,C,D);

%% =========================================================
% LOAD DISTURBANCE INPUT
%% =========================================================

u = zeros(length(t),2);

% Step load increase in Area-1
u(:,1) = DeltaPL1;

% No load disturbance in Area-2
u(:,2) = DeltaPL2;

%% =========================================================
% SIMULATION
%% =========================================================

[y,x] = lsim(sys,u,t);

%% Extract outputs

Delta_f1   = y(:,1);
Delta_f2   = y(:,2);
Delta_Ptie = y(:,3);

%% =========================================================
% PLOTS
%% =========================================================

figure('Color','w');

subplot(3,1,1)

plot(t,Delta_f1,'b','LineWidth',1.8);
grid on;

xlabel('Time (sec)');
ylabel('\Delta f_1 (Hz)');
title('Area-1 Frequency Deviation');

subplot(3,1,2)

plot(t,Delta_f2,'r','LineWidth',1.8);
grid on;

xlabel('Time (sec)');
ylabel('\Delta f_2 (Hz)');
title('Area-2 Frequency Deviation');

subplot(3,1,3)

plot(t,Delta_Ptie,'k','LineWidth',1.8);
grid on;

xlabel('Time (sec)');
ylabel('\Delta P_{tie} (pu)');
title('Tie-Line Power Deviation');

sgtitle('Two-Area Load Frequency Control');

%% =========================================================
% FINAL VALUES
%% =========================================================

fprintf('\n============================================\n');
fprintf(' TWO AREA LOAD FREQUENCY CONTROL RESULTS\n');
fprintf('============================================\n');

fprintf('Final Area-1 Frequency Deviation = %.6f Hz\n', ...
        Delta_f1(end));

fprintf('Final Area-2 Frequency Deviation = %.6f Hz\n', ...
        Delta_f2(end));

fprintf('Final Tie-Line Power Deviation = %.6f pu\n', ...
        Delta_Ptie(end));

fprintf('============================================\n');

%% =========================================================
% POLE LOCATIONS
%% =========================================================

disp('System Poles:');

poles = pole(sys)

%% =========================================================
% ROOT LOCUS
%% =========================================================

figure;
rlocus(sys(1,1));
grid on;
title('Root Locus - Area 1');

%% =========================================================
% BODE PLOT
%% =========================================================

figure;
bode(sys(1,1));
grid on;
title('Bode Plot - Area 1');

%% =========================================================
% POLE-ZERO MAP
%% =========================================================

figure;
pzmap(sys);
grid on;
title('Pole-Zero Map - Two Area LFC');

%% =========================================================
% IMPULSE RESPONSE
%% =========================================================

figure;
impulse(sys(1,1));
grid on;
title('Impulse Response - Area 1');