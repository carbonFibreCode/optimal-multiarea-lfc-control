% PHASE1_COMPARE  Step 1.4: droop vs integral.
clc; clear; close all; setup_paths;
p = lfc_params(2);
r0 = simulate_lfc_linear(p, zeros(2,3));
r1 = simulate_lfc_linear(p, repmat([0 0.5 0],2,1));
plot_compare({r0,r1},{'Droop','Integral'},p,'Phase 1: droop vs integral (K_I = 0.5)','phase1_droop_vs_integral.png');
fprintf('final df1: droop %.5f, integral %.2e\n', r0.df(end,1), r1.df(end,1));
