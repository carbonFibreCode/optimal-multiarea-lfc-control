function format_figure(fig)
% FORMAT_FIGURE  Publication style: white background, black text and axes,
% light grid, readable font sizes. Call before exporting any figure.
set(fig, 'Color', 'w');
ax = findall(fig, 'Type', 'axes');
for k = 1:numel(ax)
    set(ax(k), 'Color', 'w', 'XColor', 'k', 'YColor', 'k', ...
        'GridColor', [0.15 0.15 0.15], 'GridAlpha', 0.20, ...
        'FontSize', 11, 'LineWidth', 0.8, 'Box', 'on');
    ax(k).Title.Color  = 'k';
    ax(k).XLabel.Color = 'k';
    ax(k).YLabel.Color = 'k';
end
lg = findall(fig, 'Type', 'legend');
for k = 1:numel(lg)
    set(lg(k), 'TextColor', 'k', 'Color', 'w', 'EdgeColor', [0.4 0.4 0.4], 'FontSize', 10);
end
end
