function config = branin_mod_config()

config = struct();

config.pts_init = 20;
config.pts_x = 500;
config.pts_s = 100;

config.nVar = 11;
config.nTraj = 200;
config.lognugget = log(10^-6);

config.keep_x = 50;
config.keep_xs = 200;

config.keep = config.keep_x*config.pts_s;
config.keep2 = config.keep_xs;

config.critName = "m";

config.T = 30;
config.axT = 1;

end
