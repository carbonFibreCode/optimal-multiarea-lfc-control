function [sys, A, B, C] = build_lfc_plant(p)
% BUILD_LFC_PLANT  Linear N-area LFC plant (no secondary controller).
% States : [df1 dPg1 dPm1 ... dfN dPgN dPmN, dPtie_1 ... dPtie_(N-1)]
% Inputs : [dPL_1..dPL_N, dPc_1..dPc_N]
% Outputs: [df_1..df_N, dPtie_1..dPtie_N, ACE_1..ACE_N]
n  = p.nAreas;
nx = 3*n + (n-1);
A = zeros(nx,nx);
B = zeros(nx,2*n);
% Mt maps the n-1 tie states to the tie power of every area
Mt = zeros(n, n-1);
for i = 1:n-1
    Mt(i,i) = 1;
end
if n >= 2
    Mt(n,:) = -1;
end
it = 3*n;               % tie states are it+1 ... nx
for i = 1:n
    f = 3*(i-1) + 1; g = f + 1; m = f + 2;
    A(f,f) = -1/p.Tp;
    A(f,m) =  p.Kp/p.Tp;
    if n >= 2
        A(f,it+1:nx) = A(f,it+1:nx) - (p.Kp/p.Tp)*Mt(i,:);
    end
    A(g,f) = -1/(p.R*p.Tg);
    A(g,g) = -1/p.Tg;
    A(m,g) =  1/p.Tt;
    A(m,m) = -1/p.Tt;
    B(f,i)   = -p.Kp/p.Tp;   % load input
    B(g,n+i) =  1/p.Tg;      % control input dPc
end
for i = 1:n-1
    fi = 3*(i-1) + 1;
    for j = 1:n
        if j ~= i
            fj = 3*(j-1) + 1;
            A(it+i,fi) = A(it+i,fi) + 2*pi*p.T12;
            A(it+i,fj) = A(it+i,fj) - 2*pi*p.T12;
        end
    end
end
C = zeros(3*n, nx);
for i = 1:n
    f = 3*(i-1) + 1;
    C(i,f) = 1;                       % df_i
    C(2*n+i,f) = p.beta;              % ACE_i frequency part
    if n >= 2
        C(n+i,it+1:nx)   = Mt(i,:);   % dPtie_i
        C(2*n+i,it+1:nx) = Mt(i,:);   % ACE_i tie part
    end
end
D = zeros(3*n, 2*n);
sys = ss(A,B,C,D);
sys.InputName  = [arrayfun(@(k) sprintf('dPL%d',k),1:n,'UniformOutput',false), ...
                  arrayfun(@(k) sprintf('dPc%d',k),1:n,'UniformOutput',false)];
sys.OutputName = [arrayfun(@(k) sprintf('df%d',k),1:n,'UniformOutput',false), ...
                  arrayfun(@(k) sprintf('Ptie%d',k),1:n,'UniformOutput',false), ...
                  arrayfun(@(k) sprintf('ACE%d',k),1:n,'UniformOutput',false)];
end
