% MODELS_CHECK_PLANT  Step 0.4 checks:
% (1) structure: with the old v3 numbers the builder must give exactly the v3 A matrix
% (2) reference: one area with the reference numbers must give the closed loop of
%     'Single Area Load Frequency Control.pdf':  120/(0.48 s^3 + 7.624 s^2 + 20.38 s + 51)
clc; setup_paths;
q = lfc_params(2);
q.Tg = 0.2; q.Tt = 1.0; q.Tp = 10; q.Kp = 20; q.R = 2.4; q.T12 = 0.05; q.beta = 1/q.R + 1/q.Kp;
[~, A] = build_lfc_plant(q);
Tg=0.2; Tt=1.0; Tp=10; Kp=20; R=2.4; T12=0.05;
Av3 = zeros(7);
Av3(1,1)=-1/Tp; Av3(1,3)=Kp/Tp; Av3(1,7)=-Kp/Tp;
Av3(2,1)=-1/(R*Tg); Av3(2,2)=-1/Tg;
Av3(3,2)=1/Tt; Av3(3,3)=-1/Tt;
Av3(4,4)=-1/Tp; Av3(4,6)=Kp/Tp; Av3(4,7)=Kp/Tp;
Av3(5,4)=-1/(R*Tg); Av3(5,5)=-1/Tg;
Av3(6,5)=1/Tt; Av3(6,6)=-1/Tt;
Av3(7,1)=2*pi*T12; Av3(7,4)=-2*pi*T12;
fprintf('(1) max |A - Av3| = %.3e\n', max(abs(A(:)-Av3(:))));
p1 = lfc_params(1);
P1 = build_lfc_plant(p1);
Gref = tf(120, [0.48 7.624 20.38 51]);
Gnew = tf(P1('df1','dPc1'));
fprintf('(2) max |step difference| vs reference = %.3e\n', max(abs(step(Gnew,0:0.01:20) - step(Gref,0:0.01:20))));
p = lfc_params(2);
[~, A2] = build_lfc_plant(p);
fprintf('(3) 2-area largest pole real part = %.4f\n', max(real(eig(A2))));
