% This scripts show how to create a QSI-SUR sequential design and use it
% for predicting the quantile set.

% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 
%  

it = -1;

here = fileparts (mfilename ('fullpath'));
data_dir = fullfile (here, '../data');

prm = branin_mod_struct();

% generate DoE init
disp("Generating initial DoE...")
generate_doe_init(@branin_mod_struct, @branin_mod_config, it)

% construct sequential design
disp("Constructing QSI-SUR sequential design...")
QSI_SUR(@branin_mod_struct, @branin_mod_config, it)

% retrieve design and evaluation results
file_name = sprintf("doe_QSI_m_branin_mod_%d.csv", it);
file_path = fullfile(data_dir, 'results/design', file_name);
dn = readmatrix(file_path);
zn = branin_mod(dn);

% retrieve covariance type
file_name = sprintf("cov_QSI_m_1_branin_mod_%d.csv", it);
file_path = fullfile(data_dir, 'results/param', file_name);
cov_number = readmatrix(file_path);
cov_number = cov_number(31);
cov = convertStringsToChars(prm.list_cov(cov_number));

% retrieve covariance parameters
file_name = sprintf("param_QSI_m_1_branin_mod_%d.csv", it);
file_path = fullfile(data_dir, 'results/param', file_name);
param = readmatrix(file_path);
param = param(31, :);

% construct model
Model = stk_model ();
Model(1) = stk_model(cov, prm.dim_x+prm.dim_s);
Model(1).param = param;

% create evaluation grid 
x_pred = stk_sampling_regulargrid(1000, prm.dim_x, prm.BOXx);
s_pred = stk_sampling_maximinlhs(1000, prm.dim_s, prm.BOXs);
s_pred = branin_mod_s_trnsf(s_pred);
grid = adapt_set(x_pred, s_pred);

% get predicted quantile set
disp("Predicting quantile set...")
pred_set = get_expected_quantile_set(Model, grid, 1000, 1000, dn, zn, prm.const, prm.alpha);
plot(double(x_pred), pred_set)
title("Indicator of the predicted set")
xlabel("X")
