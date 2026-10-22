% PHASE3_PIDTUNE  Step 3.2: pidtune reference controller.
clc; clear; close all; setup_paths;
p = lfc_params(2);
P = build_lfc_plant(p);
G = P('ACE1','dPc1');                 % loop seen by the Area-1 controller
[C, info] = pidtune(G, 'PIDF');
wc = info.CrossoverFrequency;
for attempt = 1:6
    p2 = p;
    if C.Tf > 0, p2.N = 1/C.Tf; end
    Gt = repmat([C.Kp C.Ki C.Kd], 2, 1);
    res = simulate_lfc_linear(p2, Gt);
    fprintf('attempt %d: wc = %.4f  Kp=%.4f Ki=%.4f Kd=%.4f N=%.2f  stable=%d\n', ...
        attempt, wc, C.Kp, C.Ki, C.Kd, p2.N, res.stable);
    if res.stable, break; end
    wc = wc/2;
    C = pidtune(G, 'PIDF', wc);
end
if ~res.stable, error('pidtune controller unstable after 6 attempts - report to the human'); end
m = lfc_metrics(res, p2);
fprintf('pidtune PID: ITAE = %.4f, min df1 = %.4f, ts = %.1f s, max u1 = %.4f\n', m.ITAE, m.min_df1, m.ts_df1, m.max_u1);
log_result('3.2','pidtune PID','2A step 0.05',Gt,m);
Npid = p2.N;
save(fullfile('results','data','phase3_pidtune.mat'),'Gt','Npid','res','m');
