function c = plot_style(name)
% PLOT_STYLE  Fixed colour per controller name (same in every figure).
switch name
    case 'Droop',          c = [0.45 0.45 0.45];
    case 'Integral',       c = [0.00 0.45 0.74];
    case 'Manual PID',     c = [0.85 0.33 0.10];
    case 'pidtune PID',    c = [0.00 0.55 0.55];
    case 'GA-PID',         c = [0.49 0.18 0.56];
    case 'PSO-PID',        c = [0.47 0.67 0.19];
    case 'PSO-PID (GRC)',  c = [0.10 0.50 0.10];
    case 'LQR',            c = [0.64 0.08 0.18];
    otherwise,             c = [0 0 0];
end
end
