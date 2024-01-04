function config = hart4_config()

config = example_config ();

config.pts_init = 40;
config.pts_x = 1000;

config.keep = config.keep_x*config.pts_s;
config.keep2 = config.keep_xs;

config.T = 100;
config.axT = 2;

end
