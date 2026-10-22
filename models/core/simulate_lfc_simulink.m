function res = simulate_lfc_simulink(p, gains, mdl)
% SIMULATE_LFC_SIMULINK  Run lfc_<n>area.slx with parameters p and gains (n x 3).
if nargin < 3, mdl = sprintf('lfc_%darea', p.nAreas); end
n = p.nAreas;
p.K = gains;
if ~bdIsLoaded(mdl), load_system(mdl); end
in = Simulink.SimulationInput(mdl);
in = in.setVariable('p', p);
in = in.setModelParameter('StopTime', num2str(p.Tend), 'FixedStep', num2str(p.dt));
res.stable = true;
try
    out = sim(in);
    if ~isempty(out.ErrorMessage), error('LFC:sim', '%s', out.ErrorMessage); end
catch err
    res.stable = false; res.error = err.message;
    res.t = (0:p.dt:p.Tend)'; z = nan(numel(res.t), n);
    res.df = z; res.ptie = z; res.ace = z; res.u = z; res.load = z; res.pm = z;
    return
end
res.t = out.get('tout');
for i = 1:n
    res.df(:,i)   = out.get(sprintf('df%d',i));
    res.ptie(:,i) = out.get(sprintf('ptie%d',i));
    res.ace(:,i)  = out.get(sprintf('ace%d',i));
    res.u(:,i)    = -out.get(sprintf('cu%d',i));
    res.load(:,i) = out.get(sprintf('load%d',i));
    res.pm(:,i)   = out.get(sprintf('pm%d',i));
end
if any(~isfinite(res.df(:))) || max(abs(res.df(:))) > 1
    res.stable = false;
end
end
