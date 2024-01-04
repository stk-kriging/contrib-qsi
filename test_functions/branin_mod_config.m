function config = branin_mod_config()

config = example_config ();

config.pts_init = 20;
config.pts_x = 500;

config.keep = config.keep_x*config.pts_s;
config.keep2 = config.keep_xs;

config.T = 30;
config.axT = 1;

end
