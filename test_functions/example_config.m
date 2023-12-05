function config = example_config ()

config = struct(); %define structure

config.pts_init = 20; %number of points in the initial design

config.pts_x = 500; %number of points sampled in X
config.pts_s = 100; %number of points sampled in S

config.nVar = 20; %number of points of the Gaussian quadrature used to evaluate criteria
config.nTraj = 250; %number of trajectories for the evaluation of the QSI criteria (QSI only)

config.keep_x = 15; %number of points to keep in X (QSI only)
config.keep_xs = 200; %number of candidate points to keep (QSI only)

config.keep = config.keep_x*config.pts_s; %number of points to keep in X x S (joint SUR only)
config.keep2 = config.keep_xs; %number of candidate points to keep (joint SUR only)

config.critName = "m"; %variations of the criteria. "m" = misclass, "v" = variance, "e" = entropy

config.T = 30; %Number of steps of the algorithms
config.axT = 1; %Define size of the step for evaluation of the results.

end
