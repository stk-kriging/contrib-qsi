% This scripts generate sequential designs using different strategies,
% compute the proportion of misclassfied points at each step, and plot the
% convergence results.
%
% This script may take some time to execute. To alleviate this, you can
% reduce the number of strategies use or modify the branin_mod_config.m
% file

% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 
%  

it = -1;

here = fileparts (mfilename ('fullpath'));
data_dir = fullfile (here, '../data');

% generate DoE init
generate_doe_init(@branin_mod_struct, @branin_mod_config, it)

% construct sequential designs
QSI_SUR(@branin_mod_struct, @branin_mod_config, it)
joint_SUR(@branin_mod_struct, @branin_mod_config, it)
Ranjan(@branin_mod_struct, @branin_mod_config, it)
misclassification(@branin_mod_struct, @branin_mod_config, it)
random(@branin_mod_struct, @branin_mod_config, it)

% extract convergence results
list_algo = ["QSI_m", "joint_m", "Ranjan", "misclassification", "random"];
for k = 1:5
    algo = list_algo(k);
    extract_deviation(@branin_mod_struct, @branin_mod_config, algo, it)
end

% plot results
figure()
for k = 1:5
    algo = list_algo(k);
    file_name = sprintf("dev_%s_%s_%d.csv", algo, prm.name, it);
    file_path = fullfile(data_dir, 'results/deviations', 'file_name');
    dev = readmatrix(file_path);
    plot(0:30, dev, "DisplayName", algo)
    hold on
end

legend()
