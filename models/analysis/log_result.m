function log_result(step, controller, testcase, gains, m)
% LOG_RESULT  Append one row to results/results_log.csv.
root = fileparts(fileparts(fileparts(mfilename('fullpath'))));
f = fullfile(root,'results','results_log.csv');
newFile = ~exist(f,'file');
fid = fopen(f,'a');
if newFile
    fprintf(fid,'step,controller,testcase,gains,ITAE,IAE,ISE,ITSE,ts_df1,min_df1,min_df2,maxabs_ptie1,final_df1,max_u1\n');
end
g = strjoin(arrayfun(@(x) sprintf('%.4f',x), gains(:)','UniformOutput',false),' ');
% text fields are quoted because test-case names may contain commas
fprintf(fid,'"%s","%s","%s","%s",%.6g,%.6g,%.6g,%.6g,%.3f,%.6f,%.6f,%.6f,%.3e,%.6f\n', ...
    step, controller, testcase, g, m.ITAE, m.IAE, m.ISE, m.ITSE, m.ts_df1, ...
    m.min_df1, m.min_df2, m.maxabs_ptie1, m.final_df1, m.max_u1);
fclose(fid);
end
