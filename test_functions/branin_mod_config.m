function config = branin_mod_config ()

% Set default parameters
config = example_config (1, 1);

% Number of iterations of the algorithm
config.T = 30;

% Number of iterations between two performance evaluations
config.axT = 1;

end
