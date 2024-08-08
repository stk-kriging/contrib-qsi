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



function [prm, f, s_trnsf] = hart4_struct()

f = @hart4;
s_trnsf = @hart4_s_trnsf;

prm = struct();

prm.M = 1;

prm.dim_x = 2;
prm.dim_s = 2;
input_domain = [[0;1], [0;1], [0;1], [0;1]];
prm.BOX = stk_hrect(input_domain);
prm.BOXx = stk_hrect([[0;1],[0;1]]);
prm.BOXs = stk_hrect([[0;1],[0;1]]);

prm.const = [-1.1 ; inf];
prm.alpha = 0.6;

prm.name = "hart4";
prm.name_sub = ["hart4"];

prm.list_cov = ["stk_expcov_aniso"; "stk_materncov32_aniso"; "stk_materncov52_aniso"; "stk_gausscov_aniso"];

end
