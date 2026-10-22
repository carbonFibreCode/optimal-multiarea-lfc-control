% PHASE3_COMPARE  Step 3.3: conventional controllers.
clc; clear; close all; setup_paths;
p = lfc_params(2);
S1 = load(fullfile('results','data','phase3_manual.mat'));
S2 = load(fullfile('results','data','phase3_pidtune.mat'));
r0 = simulate_lfc_linear(p, zeros(2,3));
r1 = simulate_lfc_linear(p, repmat([0 0.5 0],2,1));
r2 = simulate_lfc_linear(p, repmat(S1.Gm,2,1));
p2 = p; p2.N = S2.Npid; r3 = simulate_lfc_linear(p2, S2.Gt);
plot_compare({r0,r1,r2,r3},{'Droop','Integral','Manual PID','pidtune PID'},p, ...
    'Conventional controllers: droop, integral, manual PID and pidtune PID','fig_5_conventional_controllers.png');
n = {'Droop','Integral','Manual PID','pidtune PID'}; R = {r0,r1,r2,r3};
for k=1:4, fprintf('%-12s final df1 = %.2e\n', n{k}, R{k}.df(end,1)); end
