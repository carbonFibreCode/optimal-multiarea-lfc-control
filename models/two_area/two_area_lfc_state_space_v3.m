clc;
clear;
close all;

%% =========================================================
% TWO-AREA LOAD FREQUENCY CONTROL
% Primary Governor Control
% Base frequency = 50 Hz
% Load disturbance in Area-1
%% =========================================================

s = tf('s');

%% ================= AREA 1 PARAMETERS =================

Tg1 = 0.2;          % Governor time constant (s)
Tt1 = 1.0;          % Turbine time constant (s)
Tp1 = 10;           % Power system time constant (s)
Kp1 = 20;           % Power system gain
R1  = 2.4;           % Speed regulation

%% ================= AREA 2 PARAMETERS =================

Tg2 = 0.2;
Tt2 = 1.0;
Tp2 = 10;
Kp2 = 20;
R2  = 2.4;

%% ================= TIE LINE =================

T12 = 0.05;

%% ================= LOAD DISTURBANCE =================

DeltaPL1 = 0.05;        % pu load increase in Area 1
DeltaPL2 = 0;           % No load disturbance in Area 2

%% =====================================================
% TRANSFER FUNCTIONS
%% =====================================================

% Governor
Gg1 = 1/(Tg1*s + 1);
Gg2 = 1/(Tg2*s + 1);

% Turbine
Gt1 = 1/(Tt1*s + 1);
Gt2 = 1/(Tt2*s + 1);

% Power system
Gp1 = Kp1/(Tp1*s + 1);
Gp2 = Kp2/(Tp2*s + 1);

%% =====================================================
% AREA CONTROL BLOCKS
%% =====================================================

% Governor + turbine
G1 = Gg1*Gt1;
G2 = Gg2*Gt2;

%% =====================================================
% STATE-SPACE MODEL
%
% x1 = df1
% x2 = governor-1
% x3 = turbine-1
% x4 = df2
% x5 = governor-2
% x6 = turbine-2
% x7 = Ptie
%% =====================================================

A = zeros(7,7);

% -------- AREA 1 --------

A(1,1) = -1/Tp1;
A(1,3) = Kp1/Tp1;
A(1,7) = -Kp1/Tp1;

A(2,1) = -1/(R1*Tg1);
A(2,2) = -1/Tg1;

A(3,2) = 1/Tt1;
A(3,3) = -1/Tt1;

% -------- AREA 2 --------

A(4,4) = -1/Tp2;
A(4,6) = Kp2/Tp2;
A(4,7) = Kp2/Tp2;

A(5,4) = -1/(R2*Tg2);
A(5,5) = -1/Tg2;

A(6,5) = 1/Tt2;
A(6,6) = -1/Tt2;

% -------- TIE LINE --------

A(7,1) = 2*pi*T12;
A(7,4) = -2*pi*T12;

%% =====================================================
% INPUT MATRIX
%% =====================================================

B = zeros(7,2);

% Area-1 load increase
B(1,1) = -Kp1/Tp1;

% Area-2 load increase
B(4,2) = -Kp2/Tp2;

%% =====================================================
% OUTPUT MATRIX
%% =====================================================

C = zeros(3,7);

% Area-1 frequency deviation
C(1,1) = 1;

% Area-2 frequency deviation
C(2,4) = 1;

% Tie-line deviation
C(3,7) = 1;

D = zeros(3,2);

%% =====================================================
% CREATE SYSTEM
%% =====================================================

sys = ss(A,B,C,D);

%% =====================================================
% CHECK STABILITY
%% =====================================================

p = pole(sys);

disp('System poles:')
disp(p)

if all(real(p) < 0)
    disp('SYSTEM IS STABLE')
else
    disp('SYSTEM IS UNSTABLE - CHECK MODEL')
end

%% =====================================================
% SIMULATION
%% =====================================================

t = 0:0.01:100;

u = zeros(length(t),2);

% 0.05 pu load increase in Area 1
u(:,1) = DeltaPL1;

% No load disturbance in Area 2
u(:,2) = DeltaPL2;

[y,x] = lsim(sys,u,t);

%% OUTPUTS

df1 = y(:,1);
df2 = y(:,2);
Ptie = y(:,3);

%% =====================================================
% ACTUAL FREQUENCY
%% =====================================================

f0 = 50;

f1 = f0 + df1;
f2 = f0 + df2;

%% =====================================================
% FREQUENCY DEVIATION GRAPH
%% =====================================================

figure;

subplot(3,1,1)

plot(t,df1,'b','LineWidth',1.5);
grid on;

xlabel('Time (seconds)');
ylabel('\Delta f_1 (Hz)');
title('Area-1 Frequency Deviation');

subplot(3,1,2)

plot(t,df2,'r','LineWidth',1.5);
grid on;

xlabel('Time (seconds)');
ylabel('\Delta f_2 (Hz)');
title('Area-2 Frequency Deviation');

subplot(3,1,3)

plot(t,Ptie,'k','LineWidth',1.5);
grid on;

xlabel('Time (seconds)');
ylabel('\Delta P_{tie} (pu)');
title('Tie-Line Power Deviation');

sgtitle('Two-Area Load Frequency Control');

%% =====================================================
% ACTUAL FREQUENCY GRAPH
%% =====================================================

figure;

plot(t,f1,'b','LineWidth',1.5);
hold on;

plot(t,f2,'r','LineWidth',1.5);

yline(50,'k--','50 Hz');

grid on;

xlabel('Time (seconds)');
ylabel('Frequency (Hz)');

title('Two-Area Grid Frequency Response');

legend('Area 1','Area 2','Reference');

%% =====================================================
% FINAL RESULTS
%% =====================================================

fprintf('\n============================================\n');
fprintf(' TWO-AREA LOAD FREQUENCY CONTROL RESULTS\n');
fprintf('============================================\n');

fprintf('Final Delta f1 = %.6f Hz\n',df1(end));
fprintf('Final Delta f2 = %.6f Hz\n',df2(end));
fprintf('Final Delta Ptie = %.6f pu\n',Ptie(end));

fprintf('Final Frequency Area-1 = %.6f Hz\n',f1(end));
fprintf('Final Frequency Area-2 = %.6f Hz\n',f2(end));

fprintf('Minimum Frequency Area-1 = %.6f Hz\n',min(f1));
fprintf('Minimum Frequency Area-2 = %.6f Hz\n',min(f2));

fprintf('============================================\n');