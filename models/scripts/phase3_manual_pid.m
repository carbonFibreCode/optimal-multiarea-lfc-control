% PHASE3_MANUAL_PID  Step 3.1: one-gain-at-a-time tuning, KI fixed at 0.5.
clc; clear; close all; setup_paths;
p = lfc_params(2);
KI = 0.5;
KPs = [0 0.2 0.5 1.0];
KDs = [0 0.1 0.3 0.5];
[KP, ~] = bestOf(p, @(v) [v KI 0], KPs, 'A (KP, KD=0)');
[KD, ~] = bestOf(p, @(v) [KP KI v], KDs, 'B (KD)');
[KP, J] = bestOf(p, @(v) [v KI KD], KPs, 'C (KP again)');
Gm = [KP KI KD];
fprintf('\nManual PID = [%.2f %.2f %.2f], ITAE = %.4f\n', Gm, J);
res = simulate_lfc_linear(p, repmat(Gm,2,1)); m = lfc_metrics(res,p);
log_result('3.1','Manual PID','2A step 0.05',repmat(Gm,2,1),m);
save(fullfile('results','data','phase3_manual.mat'),'Gm','res','m');

function [bestV, bestJ] = bestOf(p, makeGain, values, label)
fprintf('\nStage %s\n', label);
bestJ = Inf; bestV = NaN;
for v = values
    g = makeGain(v);
    res = simulate_lfc_linear(p, repmat(g,2,1));
    if ~res.stable
        fprintf('  [%.2f %.2f %.2f]  UNSTABLE\n', g); continue
    end
    m = lfc_metrics(res, p);
    fprintf('  [%.2f %.2f %.2f]  ITAE = %8.4f  min df1 = %.4f  ts = %5.1f\n', g, m.ITAE, m.min_df1, m.ts_df1);
    if m.ITAE < bestJ, bestJ = m.ITAE; bestV = v; end
end
end
