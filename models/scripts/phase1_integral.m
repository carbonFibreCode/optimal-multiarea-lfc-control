% PHASE1_INTEGRAL  Step 1.2: integral control on ACE, KI = 0.5.
clc; clear; close all; setup_paths;
p = lfc_params(2);
G = repmat([0 0.5 0], 2, 1);
res = simulate_lfc_linear(p, G);
m = lfc_metrics(res, p);
fprintf('stable = %d, largest pole real part = %.4f\n', res.stable, max(real(res.poles)));
fprintf('final df1 = %.2e, final Ptie1 = %.2e\n', m.final_df1, m.final_ptie1);
fprintf('ITAE = %.3f, min df1 = %.4f, ts = %.1f s, max u1 = %.4f\n', m.ITAE, m.min_df1, m.ts_df1, m.max_u1);
log_result('1.2','Integral','2A step 0.05',G,m);
save(fullfile('results','data','phase1_integral.mat'),'res','m','G');
