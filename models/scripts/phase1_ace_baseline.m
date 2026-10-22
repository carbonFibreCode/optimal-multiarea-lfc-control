% PHASE1_ACE_BASELINE  Step 1.1: ACE with droop only.
clc; clear; close all; setup_paths;
p = lfc_params(2);
res = simulate_lfc_linear(p, zeros(2,3));
fig = figure('Color','w');
plot(res.t, res.ace(:,1), 'LineWidth',1.6); hold on; grid on;
plot(res.t, res.ace(:,2), 'LineWidth',1.6);
xlabel('Time (s)'); ylabel('ACE (pu)'); legend('ACE_1','ACE_2');
title('Phase 1: ACE with droop only (never returns to zero)');
exportgraphics(fig, fullfile('results','figures','phase1_ace_droop.png'),'Resolution',200);
fprintf('final ACE1 = %.5f, final ACE2 = %.5f\n', res.ace(end,1), res.ace(end,2));
