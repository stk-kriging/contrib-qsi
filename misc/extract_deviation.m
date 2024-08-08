% Allow to extract and save statistics on the algorithms given a list_id of
% runs.
%
% it designates the numerical id of the run.
% 
% Name should be the identifier of the method in the corresponding file
% names. The identifiers are as follows:
%
% QSI-SUR: "QSI_m", "QSI_v", "QSI_e" (depending on the version of the
% criterion).
% Joint-SUR: "joint_m", "joint_v", "joint_e" (depending on the version of
% the criterion).
% Ranjan: "Ranjan".
% Max. misclassification: "misclassification".
% Random: "random".

% Copyright Notice
%
%    Copyright (C) 2024 CentraleSupelec
%
%    Author(s): Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr>
%               Julien Bect <julien.bect@centralesupelec.fr>

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



function extract_deviation(funct_struct, config, name, it, data_dir)

disp("Run number "+int2str(it))

if nargin < 5
    here = fileparts (mfilename ('fullpath'));
    data_dir = fullfile (here, '..', 'data');
end


[prm, f, s_trnsf] = funct_struct();
config = config();

PTS_X = config.pts_eval_x;
PTS_S = config.pts_eval_s;

dim_tot = prm.dim_x + prm.dim_s;

xf = stk_sampling_sobol(PTS_X, prm.dim_x, prm.BOXx);
sf = stk_sampling_sobol(PTS_S, prm.dim_s, prm.BOXs);
sf = s_trnsf(sf);
df = adapt_set (xf, sf);

file = sprintf ('results_grid_%s.csv', prm.name);
file = fullfile (data_dir, 'grid', file);
if ~ exist (file, "file")
    zf = f(df);
    csvwrite (file, zf);
else
    zf = csvread(file);
end
zf = double(zf);

trueSet = get_true_quantile_set(zf, PTS_X, PTS_S, prm.alpha, prm.const);

file_design = sprintf('doe_%s_%s_%d.csv', name, prm.name, it);
design = readmatrix(fullfile(data_dir, 'results/design', file_design));

para = zeros(config.T+1, dim_tot+1, prm.M);
file_cov = zeros(config.T+1,1,prm.M);

for m =1:prm.M
    filename_para = sprintf('param_%s_%d_%s_%d.csv', name, m, prm.name, it);
    para(:,:,m) = readmatrix(fullfile(data_dir, 'results/param/', filename_para));
    filename_cov = sprintf('cov_%s_%d_%s_%d.csv', name, m, prm.name, it);
    file_cov(:,:,m) = readmatrix(fullfile(data_dir, 'results/param/', filename_cov));
end

dev = [];

for j = 1:config.axT:config.T+1
    dt = design(1:config.pts_init+j-1,:);
    zt = f(dt);
    Model = stk_model ();

    for m = 1:prm.M
        cov = convertStringsToChars(prm.list_cov(file_cov(j,:,m)));
        Model(m) = stk_model(cov, dim_tot);
        Model(m).param = para(j,:,m);
    end

    approxSet = get_expected_quantile_set(Model,df,PTS_X, PTS_S,dt,zt,prm.const,prm.alpha);
    dev = [dev, lebesgue_deviation(trueSet,approxSet)];

end

filename_dev = sprintf('dev_%s_%s_%d.csv', name, prm.name, it);
writematrix(dev,fullfile(data_dir, 'results/deviations', filename_dev));

end
