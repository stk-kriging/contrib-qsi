% Copyright Notice
%
%    Copyright (C) 2024 CentraleSupelec
%
%    Author(s): Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr>
%               Julien Bect <julien.bect@centralesupelec.fr>

% Copying Permission Statement
%
%    This file is part of contrib-qsi (https://github.com/stk-kriging/contrib-qsi)
%
%    contrib-qsi is free software: you can redistribute it and/or modify it under
%    the terms of the GNU General Public License as published by the Free
%    Software Foundation,  either version 3  of the License, or  (at your
%    option) any later version.
%
%    contrib-qsi is distributed  in the hope that it will  be useful, but WITHOUT
%    ANY WARRANTY;  without even the implied  warranty of MERCHANTABILITY
%    or FITNESS  FOR A  PARTICULAR PURPOSE.  See  the GNU  General Public
%    License for more details.
%
%    You should  have received a copy  of the GNU  General Public License
%    along with contrib-qsi.  If not, see <http://www.gnu.org/licenses/>.



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
