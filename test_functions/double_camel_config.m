function [prm, f, s_trnsf] = double_camel_config()

config = struct();

config.pts_init = 40;
config.pts_x = 1000;
config.pts_s = 25;

config.nVar = 15;
config.nTraj = 250;

config.keep_x = 60;
config.keep_xs = 200;

config.keep = config.keep_x*config.pts_s;
config.keep2 = config.keep_xs;

config.critName = "m";

config.T = 300;
config.axT = 5;

end
