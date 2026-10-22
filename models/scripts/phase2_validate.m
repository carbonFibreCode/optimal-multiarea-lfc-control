% PHASE2_VALIDATE  Step 2.3: Simulink vs linear state-space, 2 areas.
clc; clear; close all; setup_paths;
p = lfc_params(2);
cases = {zeros(2,3), repmat([0 0.5 0],2,1), repmat([1.09 2 0.3975],2,1)};
names = {'Droop','Integral','PID 1.09/2/0.3975'};
for k = 1:3
    rl = simulate_lfc_linear(p, cases{k});
    rs = simulate_lfc_simulink(p, cases{k});
    e_df   = max(abs(rl.df(:)   - rs.df(:)));
    e_ptie = max(abs(rl.ptie(:) - rs.ptie(:)));
    e_u    = max(abs(rl.u(:)    - rs.u(:)));
    fprintf('%-14s  max|df err| = %.2e   max|Ptie err| = %.2e   max|u err| = %.2e\n', names{k}, e_df, e_ptie, e_u);
end
fig = figure('Color','w'); plot(rl.t, rl.df(:,1),'LineWidth',2); hold on; grid on;
plot(rs.t, rs.df(:,1),'--','LineWidth',1.5);
legend('Linear state-space','Simulink','Location','southeast'); xlabel('Time (s)'); ylabel('\Delta f_1 (Hz)');
xlim([0 20]);
title('Simulink model vs linear state-space model (PID case)');
format_figure(fig);
exportgraphics(fig, fullfile('results','figures','fig_6_simulink_validation.png'),'Resolution',200,'BackgroundColor','white');
