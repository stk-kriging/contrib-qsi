% This scripts generate sequential designs using different strategies,
% compute the proportion of misclassfied points at each step, and plot the
% convergence results.
%
% This script may take some time to execute. To alleviate this, you can
% reduce the number of strategies use or modify the branin_mod_config.m
% file

% Copyright Notice
%
%    Copyright (C) 2024 CentraleSupelec
%
%    Author(s): Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr>

% Copying Permission Statement
%
%    This file is part of contrib-qsi (https://github.com/stk-kriging/contrib-qsi)
%
%    contrib-qsi is free software: you can redistribute it and/or modify it under
%    the terms of the GNU General Public License as published by the Free
%    Software Foundation,  either version 3  of the License, or  (at your
%    option) any later version.
%
%    contrib-qsi is distributed  in the hope that it will  be useful, but WITHOUT
%    ANY WARRANTY;  without even the implied  warranty of MERCHANTABILITY
%    or FITNESS  FOR A  PARTICULAR PURPOSE.  See  the GNU  General Public
%    License for more details.
%
%    You should  have received a copy  of the GNU  General Public License
%    along with contrib-qsi.  If not, see <http://www.gnu.org/licenses/>.



it = -1;

here = fileparts (mfilename ('fullpath'));
data_dir = fullfile (here, '../data');

% generate DoE init
disp("Generating initial DoE...")
generate_doe_init(@branin_mod_struct, @branin_mod_config, it)

% construct sequential designs
disp("Constructing QSI-SUR sequential design...")
QSI_SUR(@branin_mod_struct, @branin_mod_config, it)
disp("Constructing Joint-SUR sequential design...")
joint_SUR(@branin_mod_struct, @branin_mod_config, it)
disp("Constructing Ranjan criterion sequential design...")
Ranjan(@branin_mod_struct, @branin_mod_config, it)
disp("Constructing max. misclassification sequential design...")
misclassification(@branin_mod_struct, @branin_mod_config, it)
disp("Constructing random design...")
random(@branin_mod_struct, @branin_mod_config, it)

% extract convergence results
disp("Calculating proportion of misclassified points for the different strategies at each step...")
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
    file_path = fullfile(data_dir, 'results/deviations', file_name);
    dev = readmatrix(file_path);
    plot(0:30, dev, "DisplayName", algo)
    hold on
end

legend()
