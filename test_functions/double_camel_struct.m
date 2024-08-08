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



function [prm, f, s_trnsf] = double_camel_struct()

f = @double_camel;

s_trnsf = @double_camel_s_trnsf;

prm = struct();

prm.M = 1;

prm.dim_x = 2;
prm.dim_s = 2;
input_domain = [[-2;2], [-2;2], [-1;1], [-1;1]];
prm.BOX = stk_hrect(input_domain);
prm.BOXx = stk_hrect([[-2;2],[-2;2]]);
prm.BOXs = stk_hrect([[-1;1],[-1;1]]);

prm.const = [-inf; 1.2];
prm.alpha = 0.15;

prm.name = "double_camel";
prm.name_sub = ["double_camel"];

prm.list_cov = ["stk_expcov_aniso"; "stk_materncov32_aniso"; "stk_materncov52_aniso"; "stk_gausscov_aniso"];
prm.eps = 1/200;

end
