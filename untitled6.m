P1 = 40; %Active Power in MW 
V = 11/sqrt(3) + 1i*0;  %Terminal Phase-Voltage in kV 
disp(V) 
Xs = 1.21; %Synchronous Reactance 
Zs = 0 + 1i*Xs; %Synchronous Impedance 
angle = acos(0.5);  %Angle = cosine inverse (0.5) 
theta = angle:-0.1:-angle;  %Series of phase angles ranging from 0.5pf leading 
... to 0.5pf lagging 
P1 = P1*ones(1,length(theta));  %Initialization of an array for 3-phase active power 
I_arm = P1./(3*abs(V)*cos(theta));   
%3-phase armature current, kA 
Ia = I_arm.*cos(theta) + 1i.*I_arm.*sin(theta); % Armature Current in Phasor form 
E = V + Zs.*Ia; %Equivalent circuit of Sync Generator 
Em = abs(E); %Excitation Voltage magnitude 
If = Em*1e3/200; %Field current formula as given in the question 
%% Another Power 
P2 = 60; %Active Power in MW 
V = 11/sqrt(3) + 1i*0;  %Terminal Phase-Voltage in kV 
disp(V) 
Xs = 1.21; %Synchronous Reactance  Zs = 0 + 1i*Xs; %Synchronous Impedance 
angle = acos(0.5);  %Angle = cosine inverse (0.5) 
theta = angle:-0.1:-angle;  %Series of phase angles ranging from 0.5pf leading 
... to 0.5pf lagging 
P2 = P2*ones(1,length(theta));  %Initialization of an array for 3-phase active   I_arm2 = P2./(3*abs(V)*cos(theta));   %3-phase armature current, kA  Ia2 = I_arm2.*cos(theta) + 1i.*I_arm2.*sin(theta); % Armature Current in Phasor form  E2 = V + Zs.*Ia2; %Equivalent circuit of Sync Generator  Em2 = abs(E2); %Excitation Voltage magnitude  If2 = Em2*1e3/200; %Field current formula as given in the question  %% Another Power  %% Another Power  P3 = 30; %Active Power in MW  V = 11/sqrt(3) + 1i*0;  %Terminal Phase-Voltage in kV  disp(V)  Xs = 1.21; %Synchronous Reactance  Zs = 0 + 1i*Xs; %Synchronous Impedance  angle = acos(0.5);  %Angle = cosine inverse (0.5)  theta = angle:-0.1:-angle;  %Series of phase angles ranging from 0.5pf leading  ... to 0.5pf lagging 
P3 = P3*ones(1,length(theta));  %Initialization of an array for 3-phase active power
I_arm3 = P3./(3*abs(V)*cos(theta));   %3-phase armature current, kA  Ia3 = I_arm3.*cos(theta) + 1i.*I_arm3.*sin(theta); % Armature Current in Phasor form E3 = V + Zs.*Ia3; %Equivalent circuit of Sync Generator  Em3 = abs(E3); %Excitation Voltage magnitude  If3 = Em3*1e3/200; %Field current formula as given in the  
plot(If,I_arm,If2,I_arm2,'r',If3,I_arm3,'g'), grid on, xlabel('Field Current, A') 
ylabel('Armature Current, kA'), text(44, 3, 'Leading pf') 
text(24, 3, 'Lagging pf'), text(31, 1.3, 'Unity pf') 
Ia3 = I_arm3.*cos(theta) + 1i.*I_arm3.*sin(theta); % Armature Current in Phasor form
E3 = V + Zs.*Ia3; %Equivalent circuit of Sync Generator 
Em3 = abs(E3); %Excitation Voltage magnitude 
If3 = Em3*1e3/200; %Field current formula as given in the  
plot(If,I_arm,If2,I_arm2,'r',If3,I_arm3,'g'), grid on, xlabel('Field Current, A') 
ylabel('Armature Current, kA'), text(44, 3, 'Leading pf') 
text(24, 3, 'Lagging pf'), text(31, 1.3, 'Unity pf') 