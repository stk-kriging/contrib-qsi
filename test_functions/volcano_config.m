function config = volcano_config()

config = struct();

config.pts_init = 70;
config.pts_x = 2500;
config.pts_s = 75;

config.nVar = 15;
config.nTraj = 250;

config.keep_x = 20;
config.keep_xs = 200;

config.keep = config.keep_x*config.pts_s;
config.keep2 = config.keep_xs;

config.critName = "m";

config.T = 150;
config.axT = 3;

end
