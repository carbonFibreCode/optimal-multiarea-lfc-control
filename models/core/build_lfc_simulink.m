function mdl = build_lfc_simulink(nAreas)
% BUILD_LFC_SIMULINK  Generate the N-area LFC Simulink model from the plan.
% All block values are expressions in the struct p (from lfc_params).
% Per area i:
%   load: Step PL_i + Step PL2_i + randAmp*UniformRandom -> SumL_i
%   SumP_i (+dPm -dPtie -load) -> Gen_i: Kp/(Tp s+1) -> df_i
%   df_i -> GDB_i (dead zone) -> Rinv_i (1/R) -> SumG_i (- -) <- PID_i output
%   SumG_i -> Gov_i: 1/(Tg s+1) -> dPg_i
%   turbine with GRC: SumT_i (dPg - dPm) -> TtInv_i -> GRC_i (saturation) -> Turb_i (integrator) -> dPm_i
%   ACE: Beta_i*df_i + dPtie_i -> SumACE_i -> PID_i
% Tie line for each pair i<j: (df_i - df_j) -> 2*pi*T12 -> integrator Tie_i_j
if nargin < 1, nAreas = 2; end
p = lfc_params(nAreas);
assignin('base','p',p);
root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
mdl = sprintf('lfc_%darea', nAreas);
if bdIsLoaded(mdl), close_system(mdl, 0); end
f = fullfile(root,'models','simulink',[mdl '.slx']);
if exist(f,'file'), delete(f); end
new_system(mdl); open_system(mdl);
set_param(mdl,'Solver','ode4','FixedStep','p.dt','StopTime','p.Tend');
set_param(mdl,'SaveTime','on','TimeSaveName','tout','ReturnWorkspaceOutputs','on');
n = nAreas;
for i = 1:n
    s = sprintf('_%d', i);
    % ---------- load ----------
    add_block('simulink/Sources/Step',[mdl '/PL' s],'Time','0','Before','0','After',sprintf('p.dPL(%d)',i));
    add_block('simulink/Sources/Step',[mdl '/PL2' s],'Time','p.tL2','Before','0','After',sprintf('p.dPL2(%d)',i));
    add_block('simulink/Sources/Uniform Random Number',[mdl '/Rand' s],'Minimum','-1','Maximum','1', ...
        'Seed',sprintf('p.randSeed+%d',i),'SampleTime','p.randTs');
    add_block('simulink/Math Operations/Gain',[mdl '/RandAmp' s],'Gain',sprintf('p.randAmp(%d)',i));
    add_block('simulink/Math Operations/Sum',[mdl '/SumL' s],'Inputs','+++','IconShape','rectangular');
    % ---------- power system ----------
    add_block('simulink/Math Operations/Sum',[mdl '/SumP' s],'Inputs','+--','IconShape','rectangular');
    add_block('simulink/Continuous/Transfer Fcn',[mdl '/Gen' s],'Numerator','p.Kp','Denominator','[p.Tp 1]');
    % ---------- governor ----------
    add_block('simulink/Discontinuities/Dead Zone',[mdl '/GDB' s],'LowerValue','-p.db','UpperValue','p.db');
    add_block('simulink/Math Operations/Gain',[mdl '/Rinv' s],'Gain','1/p.R');
    add_block('simulink/Math Operations/Sum',[mdl '/SumG' s],'Inputs','--','IconShape','rectangular');
    add_block('simulink/Continuous/Transfer Fcn',[mdl '/Gov' s],'Numerator','1','Denominator','[p.Tg 1]');
    % ---------- turbine with GRC ----------
    add_block('simulink/Math Operations/Sum',[mdl '/SumT' s],'Inputs','+-','IconShape','rectangular');
    add_block('simulink/Math Operations/Gain',[mdl '/TtInv' s],'Gain','1/p.Tt');
    add_block('simulink/Discontinuities/Saturation',[mdl '/GRC' s],'UpperLimit','p.grc','LowerLimit','-p.grc');
    add_block('simulink/Continuous/Integrator',[mdl '/Turb' s],'InitialCondition','0');
    % ---------- ACE and controller ----------
    add_block('simulink/Math Operations/Gain',[mdl '/Beta' s],'Gain','p.beta');
    add_block('simulink/Math Operations/Sum',[mdl '/SumACE' s],'Inputs','++','IconShape','rectangular');
    add_block('simulink/Continuous/PID Controller',[mdl '/PID' s]);
    set_param([mdl '/PID' s],'Controller','PID','Form','Parallel', ...
        'P',sprintf('p.K(%d,1)',i),'I',sprintf('p.K(%d,2)',i),'D',sprintf('p.K(%d,3)',i),'N','p.N');
    % ---------- logging ----------
    add_block('simulink/Sinks/To Workspace',[mdl '/log_df' s],'VariableName',sprintf('df%d',i),'SaveFormat','Array');
    add_block('simulink/Sinks/To Workspace',[mdl '/log_ptie' s],'VariableName',sprintf('ptie%d',i),'SaveFormat','Array');
    add_block('simulink/Sinks/To Workspace',[mdl '/log_ace' s],'VariableName',sprintf('ace%d',i),'SaveFormat','Array');
    add_block('simulink/Sinks/To Workspace',[mdl '/log_cu' s],'VariableName',sprintf('cu%d',i),'SaveFormat','Array');
    add_block('simulink/Sinks/To Workspace',[mdl '/log_load' s],'VariableName',sprintf('load%d',i),'SaveFormat','Array');
    add_block('simulink/Sinks/To Workspace',[mdl '/log_pm' s],'VariableName',sprintf('pm%d',i),'SaveFormat','Array');
    % ---------- wiring inside the area ----------
    L = @(a,b) add_line(mdl, a, b, 'autorouting','on');
    L(['PL' s '/1'],      ['SumL' s '/1']);
    L(['PL2' s '/1'],     ['SumL' s '/2']);
    L(['Rand' s '/1'],    ['RandAmp' s '/1']);
    L(['RandAmp' s '/1'], ['SumL' s '/3']);
    L(['SumL' s '/1'],    ['SumP' s '/3']);
    L(['SumP' s '/1'],    ['Gen' s '/1']);
    L(['Gen' s '/1'],     ['GDB' s '/1']);
    L(['GDB' s '/1'],     ['Rinv' s '/1']);
    L(['Rinv' s '/1'],    ['SumG' s '/1']);
    L(['SumG' s '/1'],    ['Gov' s '/1']);
    L(['Gov' s '/1'],     ['SumT' s '/1']);
    L(['SumT' s '/1'],    ['TtInv' s '/1']);
    L(['TtInv' s '/1'],   ['GRC' s '/1']);
    L(['GRC' s '/1'],     ['Turb' s '/1']);
    L(['Turb' s '/1'],    ['SumT' s '/2']);
    L(['Turb' s '/1'],    ['SumP' s '/1']);
    L(['Gen' s '/1'],     ['Beta' s '/1']);
    L(['Beta' s '/1'],    ['SumACE' s '/1']);
    L(['SumACE' s '/1'],  ['PID' s '/1']);
    L(['PID' s '/1'],     ['SumG' s '/2']);
    L(['Gen' s '/1'],     ['log_df' s '/1']);
    L(['SumACE' s '/1'],  ['log_ace' s '/1']);
    L(['PID' s '/1'],     ['log_cu' s '/1']);
    L(['SumL' s '/1'],    ['log_load' s '/1']);
    L(['Turb' s '/1'],    ['log_pm' s '/1']);
end
% ---------- tie lines: one integrator per pair i<j ----------
pairs = nchoosek(1:n, 2);
signs = repmat({''}, 1, n);       % sign string of SumTie_i
srcs  = repmat({{}}, 1, n);       % source blocks in the same order
for k = 1:size(pairs,1)
    i = pairs(k,1); j = pairs(k,2); s = sprintf('_%d_%d', i, j);
    add_block('simulink/Math Operations/Sum',[mdl '/SumF' s],'Inputs','+-','IconShape','rectangular');
    add_block('simulink/Math Operations/Gain',[mdl '/Ktie' s],'Gain','2*pi*p.T12');
    add_block('simulink/Continuous/Integrator',[mdl '/Tie' s],'InitialCondition','0');
    add_line(mdl, sprintf('Gen_%d/1',i), ['SumF' s '/1'], 'autorouting','on');
    add_line(mdl, sprintf('Gen_%d/1',j), ['SumF' s '/2'], 'autorouting','on');
    add_line(mdl, ['SumF' s '/1'], ['Ktie' s '/1'], 'autorouting','on');
    add_line(mdl, ['Ktie' s '/1'], ['Tie' s '/1'], 'autorouting','on');
    signs{i} = [signs{i} '+']; srcs{i}{end+1} = ['Tie' s];
    signs{j} = [signs{j} '-']; srcs{j}{end+1} = ['Tie' s];
end
for i = 1:n
    s = sprintf('_%d', i);
    add_block('simulink/Math Operations/Sum',[mdl '/SumTie' s],'Inputs',signs{i},'IconShape','rectangular');
    for q = 1:numel(srcs{i})
        add_line(mdl, [srcs{i}{q} '/1'], sprintf('SumTie%s/%d', s, q), 'autorouting','on');
    end
    add_line(mdl, ['SumTie' s '/1'], ['SumP' s '/2'],    'autorouting','on');
    add_line(mdl, ['SumTie' s '/1'], ['SumACE' s '/2'],  'autorouting','on');
    add_line(mdl, ['SumTie' s '/1'], ['log_ptie' s '/1'],'autorouting','on');
end
try
    Simulink.BlockDiagram.arrangeSystem(mdl);
catch
    % older MATLAB: layout stays unarranged, the model still works
end
save_system(mdl, f);
fprintf('Saved %s\n', f);
end
