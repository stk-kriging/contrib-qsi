function config = volcano_config()

config = example_config ();

config.pts_init = 70;
config.pts_x = 2500;

config.keep = config.keep_x*config.pts_s;
config.keep2 = config.keep_xs;

config.T = 150;
config.axT = 3;

end
