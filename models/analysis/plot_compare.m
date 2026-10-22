function fig = plot_compare(resList, names, p, titleText, fileName)
% PLOT_COMPARE  3-panel figure (df1, df2, dPtie1) for several results.
fig = figure('Color','w','Position',[100 100 900 750]);
labels = {'\Delta f_1 (Hz)','\Delta f_2 (Hz)','\Delta P_{tie,1} (pu)'};
for k = 1:3
    subplot(3,1,k); hold on; grid on;
    for r = 1:numel(resList)
        res = resList{r};
        switch k
            case 1, y = res.df(:,1);
            case 2, y = res.df(:,min(2,p.nAreas));
            case 3, y = res.ptie(:,1);
        end
        plot(res.t, y, 'LineWidth', 1.6, 'Color', plot_style(names{r}));
    end
    ylabel(labels{k});
    xlim([0 res.t(end)]);
    if k == 3, xlabel('Time (s)'); end
    if k == 1, legend(names,'Location','southeast'); end
end
format_figure(fig);
sgtitle(titleText, 'Color', 'k', 'FontWeight', 'bold', 'FontSize', 13);
root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
exportgraphics(fig, fullfile(root,'results','figures',fileName), 'Resolution', 200, 'BackgroundColor', 'white');
end
