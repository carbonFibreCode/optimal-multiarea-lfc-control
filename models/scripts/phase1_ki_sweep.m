% PHASE1_KI_SWEEP  Step 1.3: effect of KI, stability limit.
clc; clear; close all; setup_paths;
p = lfc_params(2);
KIs = [0.1 0.2 0.3 0.5 0.8 1.0 1.5 2.0];
fig = figure('Color','w'); hold on; grid on;
leg = {};
fprintf('%6s %8s %10s %10s %8s\n','KI','stable','maxRe','ITAE','ts');
for k = 1:numel(KIs)
    G = repmat([0 KIs(k) 0], 2, 1);
    res = simulate_lfc_linear(p, G);
    if res.stable
        m = lfc_metrics(res, p);
        fprintf('%6.2f %8d %10.4f %10.3f %8.1f\n', KIs(k), 1, max(real(res.poles)), m.ITAE, m.ts_df1);
        log_result('1.3','Integral',sprintf('KI sweep %.2f',KIs(k)),G,m);
        plot(res.t, res.df(:,1), 'LineWidth', 1.4); leg{end+1} = sprintf('K_I = %.2f', KIs(k)); %#ok<SAGROW>
    else
        fprintf('%6.2f %8d %10.4f %10s %8s\n', KIs(k), 0, max(real(res.poles)), 'UNSTABLE', '-');
    end
end
xlabel('Time (s)'); ylabel('\Delta f_1 (Hz)'); legend(leg,'Location','southeast');
title('Phase 1: integral gain sweep (stable cases only)');
exportgraphics(fig, fullfile('results','figures','phase1_ki_sweep.png'),'Resolution',200);
% bisection for the exact stability limit
lo = 1.0; hi = 1.5;
for it = 1:30
    mid = (lo+hi)/2;
    r = simulate_lfc_linear(p, repmat([0 mid 0],2,1));
    if r.stable, lo = mid; else, hi = mid; end
end
fprintf('KI stability limit = %.4f\n', lo);
