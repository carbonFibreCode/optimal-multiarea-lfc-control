function res = simulate_lfc_linear(p, gains)
% SIMULATE_LFC_LINEAR  Step-load simulation of the linear closed loop.
n = p.nAreas;
t = (0:p.dt:p.Tend)';
[CL, Kc] = build_lfc_closed_loop(p, gains);
res.t = t;
res.poles = pole(CL);
res.stable = all(real(res.poles) < 0);
U = zeros(numel(t), 2*n);
for i = 1:n
    U(:,i) = p.dPL(i)*(t >= 0) + p.dPL2(i)*(t >= p.tL2);
end
y = lsim(CL, U, t);
res.df   = y(:,1:n);
res.ptie = y(:,n+1:2*n);
res.ace  = y(:,2*n+1:3*n);
res.u    = zeros(numel(t), n);
for i = 1:n
    res.u(:,i) = -lsim(Kc(i,i), res.ace(:,i), t);
end
res.load = U(:,1:n);
end
