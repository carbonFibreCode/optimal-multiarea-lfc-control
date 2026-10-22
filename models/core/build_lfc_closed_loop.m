function [CL, Kc] = build_lfc_closed_loop(p, gains)
% BUILD_LFC_CLOSED_LOOP  Plant + one PID per area acting on ACE.
% gains: n x 3 matrix, row i = [KP KI KD] of area i. All zeros = droop only.
% Control law: dPc_i = -C_i(s)*ACE_i,  C_i = KP + KI/s + KD*N*s/(s+N).
n = p.nAreas;
P = build_lfc_plant(p);
Kc = [];
for i = 1:n
    KP = gains(i,1); KI = gains(i,2); KD = gains(i,3);
    if KD == 0
        Ci = ss(pid(KP, KI));
    else
        Ci = ss(pid(KP, KI, KD, 1/p.N));
    end
    if isempty(Kc)
        Kc = Ci;
    else
        Kc = append(Kc, Ci);
    end
end
% negative feedback from outputs ACE (2n+1..3n) into inputs dPc (n+1..2n)
CL = feedback(P, Kc, n+1:2*n, 2*n+1:3*n);
end
