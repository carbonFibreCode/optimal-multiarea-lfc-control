function T = read_results_log()
% READ_RESULTS_LOG  Read results/results_log.csv with text columns kept as strings.
root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
f = fullfile(root,'results','results_log.csv');
opts = detectImportOptions(f, 'Delimiter', ',');
opts = setvartype(opts, {'step','controller','testcase','gains'}, 'string');
T = readtable(f, opts);
end
