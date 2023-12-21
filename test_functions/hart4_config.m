function [prm, f, s_trnsf] = hart4_config()

config = struct();

config.pts_init = 40;
config.pts_x = 1000;
config.pts_s = 25;

config.nVar = 11;
config.nTraj = 200;
config.lognugget = log(10^-6);

config.keep_x = 60;
config.keep_xs = 200;

config.keep = config.keep_x*config.pts_s;
config.keep2 = config.keep_xs;

config.critName = "m";

config.T = 100;
config.axT = 2;

end
