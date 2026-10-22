% PHASE1_ACE_BASELINE  Step 1.1: ACE with droop only.
clc; clear; close all; setup_paths;
p = lfc_params(2);
res = simulate_lfc_linear(p, zeros(2,3));
fig = figure('Color','w');
plot(res.t, res.ace(:,1), 'LineWidth',1.6); hold on; grid on;
plot(res.t, res.ace(:,2), 'LineWidth',1.6);
xlabel('Time (s)'); ylabel('ACE (pu)'); xlim([0 res.t(end)]);
legend('ACE_1','ACE_2','Location','east');
title('Area control error with droop-only control');
format_figure(fig);
exportgraphics(fig, fullfile('results','figures','fig_2_ace_droop_only.png'),'Resolution',200,'BackgroundColor','white');
fprintf('final ACE1 = %.5f, final ACE2 = %.5f\n', res.ace(end,1), res.ace(end,2));
