% REPORT_FIGURE  Compact vector figure (df1 of the four conventional controllers)
% sized for the one-page report. Output: results/figures/fig_9_df1_comparison.pdf
clc; clear; close all; setup_paths;
p = lfc_params(2);
S1 = load(fullfile('results','data','phase3_manual.mat'));
S2 = load(fullfile('results','data','phase3_pidtune.mat'));
r0 = simulate_lfc_linear(p, zeros(2,3));
r1 = simulate_lfc_linear(p, repmat([0 0.5 0],2,1));
r2 = simulate_lfc_linear(p, repmat(S1.Gm,2,1));
p2 = p; p2.N = S2.Npid; r3 = simulate_lfc_linear(p2, S2.Gt);
R = {r0,r1,r2,r3}; names = {'Droop','Integral','Manual PID','pidtune PID'};
fig = figure('Color','w','Units','inches','Position',[1 1 3.7 2.7]);
hold on; grid on;
for k = 1:4
    plot(R{k}.t, R{k}.df(:,1), 'LineWidth', 1.2, 'Color', plot_style(names{k}));
end
yline(-0.10, '--', 'Color', [0.64 0.08 0.18], 'LineWidth', 0.8);
text(8, -0.097, '-0.10 Hz limit', 'Color', [0.64 0.08 0.18], 'FontSize', 7, ...
     'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
xlim([0 30]); ylim([-0.125 0.04]);
xlabel('Time (s)'); ylabel('\Delta f_1 (Hz)');
legend(names, 'Location', 'southeast');
format_figure(fig);
ax = gca; ax.FontSize = 8; ax.XLabel.FontSize = 8; ax.YLabel.FontSize = 8;
lg = findall(fig, 'Type', 'legend'); lg.FontSize = 7;
exportgraphics(fig, fullfile('results','figures','fig_9_df1_comparison.pdf'), 'ContentType','vector');
exportgraphics(fig, fullfile('results','figures','fig_9_df1_comparison.png'), 'Resolution', 400, 'BackgroundColor','white');
