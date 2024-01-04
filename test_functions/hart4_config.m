function config = hart4_config ()

% Set default parameters
config = example_config (2, 2);

% Number of iterations of the algorithm
config.T = 100;

% Number of iterations between two performance evaluations
config.axT = 2;

end
