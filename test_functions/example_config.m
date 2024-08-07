% USAGE: In a funct_config.m file, setting config = example_config()
% permits to define a base/standard configuration for the different
% strategies.

% This file is also used to describes the meaning of all the parameters
% involved.

% Copyright Notice
%
%    Copyright (C) 2024 CentraleSupelec
%
%    Author(s): Julien Bect <julien.bect@centralesupelec.fr>
%               Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr>

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


function config = example_config (dim_x, dim_s)

config = struct(); %define structure

config.pts_init = 10 * (dim_x + dim_s); %number of points in the initial design (used by generate_doe_init.m and extract_deviation.m)

config.pts_x = 500 * dim_x; % number of points sampled in X, before importance sampling
config.pts_s = 100; % number of points sampled in S

config.nVar = 10; % number of points of the Gaussian quadrature used to evaluate some criteria

config.lognugget = log(10^-6); % log-variance of the nugget effect
config.estim_param_steps = 1; % number of steps between two estimation of the GP parameters.
                              % If == 1, parameters are estimated at every
                              % step

% QSI-SUR only:
config.keep_x = 40; % number of points to keep in X (using importance sampling)
config.keep_xs = 250; % number of candidate points to keep (using importance sampling)
config.nTraj = 100; % number of sample paths used to approximate the criterion

% Joint-SUR only:
config.keep = config.keep_x * config.pts_s; %number of integration points kept using importance sampling.
config.keep2 = config.keep_xs; % size of the subset of candidate points to keep

config.critName = "m"; % variations of the criteria (QSI-SUR and Joint-SUR). 
                       % "m" = misclass., "v" = variance, "e" = entropy

% extract_deviations.m only
config.pts_eval_x = 2^11; % Number of points in X for results computation
config.pts_eval_s = 2^8; % Number of points in S for results computation.
config.axT = 1; % Number of steps between two performance evaluations

end
