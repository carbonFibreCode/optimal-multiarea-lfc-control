% PHASE0_BASELINE  Step 0.7: droop-only baseline, 2 areas.
clc; clear; close all; setup_paths;
p = lfc_params(2);
res = simulate_lfc_linear(p, zeros(2,3));
m = lfc_metrics(res, p);
df_theory = -p.dPL(1)/(2*p.beta);
ptie_theory = -p.dPL(1)/2;
fprintf('stable = %d\n', res.stable);
fprintf('final df1 = %.5f Hz (theory %.5f)\n', m.final_df1, df_theory);
fprintf('final df2 = %.5f Hz\n', res.df(end,2));
fprintf('final Ptie1 = %.5f pu (theory %.5f)\n', m.final_ptie1, ptie_theory);
fprintf('final ACE1 = %.5f\n', res.ace(end,1));
fprintf('min df1 = %.4f, min df2 = %.4f\n', m.min_df1, m.min_df2);
fprintf('ITAE = %.2f, ts_df1 = %.1f s, CEA band ok = %d\n', m.ITAE, m.ts_df1, m.cea_ok);
log_result('0.7','Droop','2A step 0.05',zeros(2,3),m);
plot_compare({res},{'Droop'},p,'Phase 0: droop-only baseline','phase0_baseline.png');
save(fullfile('results','data','phase0_baseline.mat'),'res','m','p');
