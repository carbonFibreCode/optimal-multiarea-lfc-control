function p = lfc_params(nAreas)
% LFC_PARAMS  All parameters of the multi-area LFC study (Part B.1 of the plan).
%   p = lfc_params()      -> 2 areas
%   p = lfc_params(3)     -> 3 identical areas
if nargin < 1, nAreas = 2; end
p.nAreas = nAreas;
p.f0  = 50;      % Hz
p.Tg  = 0.2;     % s
p.Tt  = 1.0;     % s
p.Tp  = 10;      % s
p.Kp  = 20;      % Hz/pu
p.R   = 2.4;     % Hz/pu
p.T12 = 0.05;    % tie-line synchronising coefficient (all pairs)
p.beta = 1/p.R + 1/p.Kp;   % frequency bias, 0.466667 (recompute if R or Kp change)
p.N    = 100;    % PID derivative filter coefficient
p.dt   = 0.01;   % s
p.Tend = 100;    % s
% ---- load disturbances (pu) ----
p.dPL  = zeros(nAreas,1); p.dPL(1) = 0.05;   % step at t = 0
p.dPL2 = zeros(nAreas,1);                    % second step ...
p.tL2  = 20;                                 % ... at this time (s)
p.randAmp  = zeros(nAreas,1);                % random load amplitude (Simulink only)
p.randTs   = 5;                              % random load hold time (s)
p.randSeed = 100;                            % random seed base
% ---- non-linearities (Simulink only) ----
p.grc = Inf;     % generation rate limit, pu/s (Inf = off)
p.db  = 0;       % governor dead band half-width, Hz (0 = off)
% ---- controller gains, one row per area: [KP KI KD] ----
p.K = zeros(nAreas,3);
end
