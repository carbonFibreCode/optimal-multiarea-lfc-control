% PHASE2_PRETTY_MODEL  Step 2.4: subsystem view of lfc_2area for the thesis.
clc; setup_paths;
src = 'lfc_2area'; dst = 'lfc_2area_pretty';
load_system(src);
root = fileparts(which('lfc_2area.slx'));
save_system(src, fullfile(root,[dst '.slx'])); close_system(dst,0);
load_system(src);   % re-open the working model unchanged
open_system(fullfile(root,[dst '.slx']));
for i = 1:2
    names = {'PL','PL2','Rand','RandAmp','SumL','SumP','Gen','GDB','Rinv','SumG','Gov', ...
             'SumT','TtInv','GRC','Turb','Beta','SumACE','PID'};
    h = zeros(1,numel(names));
    for q = 1:numel(names)
        h(q) = get_param(sprintf('%s/%s_%d', dst, names{q}, i), 'Handle');
    end
    Simulink.BlockDiagram.createSubsystem(h);
    sub = find_system(dst,'SearchDepth',1,'BlockType','SubSystem','Name','Subsystem');
    set_param(sub{1},'Name',sprintf('Area %d',i));
end
try, Simulink.BlockDiagram.arrangeSystem(dst); catch, end
save_system(dst);
print(['-s' dst], '-dpng', '-r200', fullfile('results','figures','fig_7_simulink_model_2area.png'));
fprintf('Saved pretty model and screenshot\n');
