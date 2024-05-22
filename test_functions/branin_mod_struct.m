% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 
%             Julien Bect <julien.bect@centralesupelec.fr>

function [prm, f, s_trnsf] = branin_mod_struct()

f = @branin_mod;

s_trnsf = @branin_mod_s_trnsf;

prm = struct();

prm.M = 1;

prm.dim_x = 1;
prm.dim_s = 1;

prm.BOX = stk_hrect([[0;10],[0;15]]);
prm.BOXx = stk_hrect(repmat([0;10],1,prm.dim_x));
prm.BOXs = stk_hrect(repmat([0;15],1,prm.dim_s));

prm.const = [-inf ; 7.5];
prm.alpha = 0.05;

prm.name = "branin_mod";
prm.name_sub = ["branin_mod"];

prm.list_cov = ["stk_expcov_aniso"; "stk_materncov32_aniso"; "stk_materncov52_aniso"; "stk_gausscov_aniso"];

end
