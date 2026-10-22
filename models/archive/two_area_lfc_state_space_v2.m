clc;
clear;
close all;

%% =========================================================
% TWO-AREA LOAD FREQUENCY CONTROL
% Primary Governor Control
% Reference frequency = 50 Hz
%% =========================================================

%% AREA-1 PARAMETERS

Tg1 = 0.2;          % Governor time constant (sec)
Tt1 = 1.0;          % Turbine time constant (sec)
Tp1 = 10;           % Power-system time constant (sec)
Kp1 = 20;           % Power-system gain
R1  = 2.4;           % Speed regulation

%% AREA-2 PARAMETERS

Tg2 = 0.2;
Tt2 = 1.0;
Tp2 = 10;
Kp2 = 20;
R2  = 2.4;

%% TIE-LINE COEFFICIENT

T12 = 0.05;

%% LOAD DISTURBANCE

DeltaPL1 = 0.05;    % 0.05 pu load increase in Area-1
DeltaPL2 = 0;       % No disturbance in Area-2

%% SIMULATION TIME

t = 0:0.01:100;

%% =========================================================
% STATE VARIABLES
%
% x1 = Delta f1
% x2 = Governor output Area-1
% x3 = Turbine output Area-1
% x4 = Delta f2
% x5 = Governor output Area-2
% x6 = Turbine output Area-2
% x7 = Delta Ptie
%% =========================================================

A = zeros(7,7);
B = zeros(7,2);

%% =========================================================
% AREA-1
%% =========================================================

% Frequency dynamics
A(1,1) = -1/Tp1;
A(1,3) =  Kp1/Tp1;
A(1,7) = -Kp1/Tp1;

% Governor
A(2,1) = -1/(R1*Tg1);
A(2,2) = -1/Tg1;

% Turbine
A(3,2) = 1/Tt1;
A(3,3) = -1/Tt1;

%% =========================================================
% AREA-2
%% =========================================================

% Frequency dynamics
A(4,4) = -1/Tp2;
A(4,6) =  Kp2/Tp2;
A(4,7) =  Kp2/Tp2;

% Governor
A(5,4) = -1/(R2*Tg2);
A(5,5) = -1/Tg2;

% Turbine
A(6,5) = 1/Tt2;
A(6,6) = -1/Tt2;

%% =========================================================
% TIE-LINE
%
% Delta Ptie = (2*pi*T12/s)(Delta f1 - Delta f2)
%% =========================================================

A(7,1) =  2*pi*T12;
A(7,4) = -2*pi*T12;

%% =========================================================
% LOAD DISTURBANCES
%% =========================================================

B(1,1) = -Kp1/Tp1;
B(4,2) = -Kp2/Tp2;

%% =========================================================
% OUTPUTS
%
% y1 = Delta f1
% y2 = Delta f2
% y3 = Delta Ptie
%% =========================================================

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
% INPUT
%% =========================================================

u = zeros(length(t),2);

% Load increase in Area-1
u(:,1) = DeltaPL1;

% No load disturbance in Area-2
u(:,2) = DeltaPL2;

%% =========================================================
% SIMULATION
%% =========================================================

[y,x] = lsim(sys,u,t);

Delta_f1   = y(:,1);
Delta_f2   = y(:,2);
Delta_Ptie = y(:,3);

%% =========================================================
% ACTUAL FREQUENCY
%% =========================================================

f0 = 50;        % Indian grid reference frequency

f1 = f0 + Delta_f1;
f2 = f0 + Delta_f2;

%% =========================================================
% PLOT FREQUENCY DEVIATION
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
% ACTUAL FREQUENCY PLOT
%% =========================================================

figure('Color','w');

plot(t,f1,'b','LineWidth',1.8);
hold on;

plot(t,f2,'r','LineWidth',1.8);

yline(50,'k--','50 Hz');
yline(49.90,'k:','49.90 Hz');
yline(50.05,'k:','50.05 Hz');

grid on;

xlabel('Time (sec)');
ylabel('Frequency (Hz)');

title('Indian Grid Frequency Response');

legend('Area-1','Area-2','Reference','Lower Limit','Upper Limit');

ylim([49.85 50.10]);

%% =========================================================
% FINAL RESULTS
%% =========================================================

fprintf('\n============================================\n');
fprintf(' TWO-AREA LFC RESULTS\n');
fprintf('============================================\n');

fprintf('Final Delta f1 = %.6f Hz\n',Delta_f1(end));
fprintf('Final Delta f2 = %.6f Hz\n',Delta_f2(end));
fprintf('Final Delta Ptie = %.6f pu\n',Delta_Ptie(end));

fprintf('\nFinal Area-1 Frequency = %.6f Hz\n',f1(end));
fprintf('Final Area-2 Frequency = %.6f Hz\n',f2(end));

fprintf('Minimum Area-1 Frequency = %.6f Hz\n',min(f1));
fprintf('Minimum Area-2 Frequency = %.6f Hz\n',min(f2));

fprintf('============================================\n');

%% =========================================================
% SYSTEM POLES
%% =========================================================

disp('System poles:');
pole(sys)

%% =========================================================
% POLE-ZERO MAP
%% =========================================================

figure;
pzmap(sys);
grid on;
title('Pole-Zero Map - Two Area LFC');

%% =========================================================
% BODE PLOT
%% =========================================================

figure;
bode(sys(1,1));
grid on;
title('Bode Plot - Area-1');

%% =========================================================
% ROOT LOCUS
%% =========================================================

figure;
rlocus(sys(1,1));
grid on;
title('Root Locus - Area-1');