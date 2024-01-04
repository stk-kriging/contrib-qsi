function config = example_config (dim_x, dim_s)

config = struct(); %define structure

config.pts_init = 10 * (dim_x + dim_s); %number of points in the initial design

config.pts_x = 500 * dim_x; %number of points sampled in X
config.pts_s = 100; %number of points sampled in S

config.nVar = 11; %number of points of the Gaussian quadrature used to evaluate criteria
config.lognugget = log(10^-6); %log-variance of the nugget effect

% QSI-SUR only:
config.keep_x = 50; %number of points to keep in X
config.keep_xs = 250; %number of candidate points to keep
config.nTraj = 200; %number of trajectories

% "Joint SUR" only:
config.keep = config.keep_x * config.pts_s; %number of points to sample in X x S
config.keep2 = config.keep_xs; %number of candidate points to keep

config.critName = "m"; %variations of the criteria. "m" = misclass, "v" = variance, "e" = entropy

config.T = 30; % Number of iterations of the algorithm
config.axT = 1; % Number of iterations between two performance evaluations

end
