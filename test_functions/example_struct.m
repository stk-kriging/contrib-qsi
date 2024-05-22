% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 
%             Julien Bect <julien.bect@centralesupelec.fr>

function [prm, f, s_trnsf] = example_struct()

f = @fnct; %function of interest

s_trnsf = @function_s_trnsf; %inverse transformation of P_s

prm = struct();

prm.M = 1; %dim of the outputs

prm.dim_x = 1; %dim of X
prm.dim_s = 1;%dim of S

prm.BOX = stk_hrect([[0;10],[0;15]]); %stk objects for X, S and XxS
prm.BOXx = stk_hrect(repmat([0;10],1,prm.dim_x));
prm.BOXs = stk_hrect(repmat([0;15],1,prm.dim_s));

prm.const = [-inf ; 7.5]; %Critical region of the form C = [const(1, 1) ; const(2,1)] x ... x [const(1, prm.M) ; const(2,prm.M)]
prm.alpha = 0.05; %threshold \alpha

prm.name = "branin_mod"; %name of the function for saving results
prm.name_sub = ["branin_mod"]; %name of the sub-functions

prm.list_cov = ["stk_expcov_aniso"; "stk_materncov32_aniso"; "stk_materncov52_aniso"; "stk_gausscov_aniso"]; %list of possible covariances models.

end
