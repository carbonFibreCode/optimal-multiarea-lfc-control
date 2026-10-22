function m = lfc_metrics(res, p)
% LFC_METRICS  Performance indices exactly as Part B.4 of the plan.
n = p.nAreas; t = res.t;
if n == 2, nt = 1; else, nt = n; end
e  = sum(abs(res.df),2) + sum(abs(res.ptie(:,1:nt)),2);
e2 = sum(res.df.^2,2)   + sum(res.ptie(:,1:nt).^2,2);
m.ITAE = trapz(t, t.*e);
m.IAE  = trapz(t, e);
m.ISE  = trapz(t, e2);
m.ITSE = trapz(t, t.*e2);
y = res.df(:,1); yf = y(end);
idx = find(abs(y - yf) > 0.0005, 1, 'last');
if isempty(idx), m.ts_df1 = 0; else, m.ts_df1 = t(idx); end
m.min_df1 = min(res.df(:,1));
if n >= 2, m.min_df2 = min(res.df(:,2)); else, m.min_df2 = NaN; end
m.maxabs_ptie1 = max(abs(res.ptie(:,1)));
m.final_df1 = res.df(end,1);
m.final_ptie1 = res.ptie(end,1);
m.max_u1 = max(abs(res.u(:,1)));
m.cea_ok = all(res.df(:) >= -0.10) && all(res.df(:) <= 0.05);   % thesis 3.4.5 (49.90-50.05 Hz)
end
