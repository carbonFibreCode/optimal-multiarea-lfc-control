function setup_paths()
% SETUP_PATHS  Add all project folders to the MATLAB path.
root = fileparts(mfilename('fullpath'));
addpath(fullfile(root,'models','params'));
addpath(fullfile(root,'models','core'));
addpath(fullfile(root,'models','analysis'));
addpath(fullfile(root,'models','optim'));
addpath(fullfile(root,'models','scripts'));
addpath(fullfile(root,'models','simulink'));
if ~exist(fullfile(root,'results','figures'),'dir'), mkdir(fullfile(root,'results','figures')); end
if ~exist(fullfile(root,'results','data'),'dir'),    mkdir(fullfile(root,'results','data'));    end
end
