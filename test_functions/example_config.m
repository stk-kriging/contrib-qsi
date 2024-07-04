% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 
%             Julien Bect <julien.bect@centralesupelec.fr>

function config = example_config (dim_x, dim_s)

config = struct(); %define structure

config.pts_init = 10 * (dim_x + dim_s); %number of points in the initial design

config.pts_x = 500 * dim_x; %number of points sampled in X
config.pts_s = 100; %number of points sampled in S

config.nVar = 10; %number of points of the Gaussian quadrature used to evaluate criteria
config.lognugget = log(10^-6); %log-variance of the nugget effect
config.estim_param_steps = 1; 

% QSI-SUR only:
config.keep_x = 40; %number of points to keep in X
config.keep_xs = 250; %number of candidate points to keep
config.nTraj = 100; %number of trajectories

% "Joint SUR" only:
config.keep = config.keep_x * config.pts_s; %number of points to sample in X x S
config.keep2 = config.keep_xs; %number of candidate points to keep

config.critName = "m"; %variations of the criteria. "m" = misclass, "v" = variance, "e" = entropy

config.pts_eval_x = 2^12; % Number of points in X for results computation
config.pts_eval_s = 2^10; % Number of points in S for results computation.
config.axT = 1; % Number of iterations between two performance evaluations

end
