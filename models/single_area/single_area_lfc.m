clc;
clear;
close all;

% Governor Parameters
Tg = 0.08;          % Governor time constant (s)
R  = 2.4;           % Speed regulation (Hz/pu MW)

% Turbine Parameters
Tt = 0.3;           % Turbine time constant (s)

% Generator-Load Parameters
Tp = 20;            % Power system time constant (s)
Kp = 120;           % Power system gain

%% Governor Transfer Function
Gg = tf(1,[Tg 1]);

%% Turbine Transfer Function
Gt = tf(1,[Tt 1]);

%% Generator-Load Transfer Function
Gp = tf(Kp,[Tp 1]);

%% Open Loop Transfer Function
Gol = series(Gg,Gt);
Gol = series(Gol,Gp);

%% Closed Loop Transfer Function
H = tf(1/R);

Gcl = feedback(Gol,H);

disp('Closed Loop Transfer Function:')
Gcl;

%% Time Vector
t = 0:0.01:100;

%% Step Load Disturbance
[y,t] = step(Gcl,t);

%% Plot Frequency Deviation
figure;
plot(t,y,'b','LineWidth',2);
grid on;
xlabel('Time (seconds)');
ylabel('\Delta f (Hz)');
title('Single Area Load Frequency Control');
legend('Frequency Deviation');

%% Step Information
disp('Performance Parameters')
stepinfo(Gcl)

%% Bode Plot
figure;
bode(Gcl);
grid on;
title('Bode Plot');

%% Root Locus
figure;
rlocus(Gcl);
grid on;
title('Root Locus');

%% Pole Zero Map
figure;
pzmap(Gcl);
grid on;
title('Pole Zero Map');

%% Impulse Response
figure;
impulse(Gcl);
grid on;
title('Impulse Response');

%% Nyquist Plot
figure;
nyquist(Gcl);
grid on;
title('Nyquist Plot');