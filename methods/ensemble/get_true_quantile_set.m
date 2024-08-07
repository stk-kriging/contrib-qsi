% Copyright Notice
%
%    Copyright (C) 2024 CentraleSupelec
%
%    Author(s): Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr>

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

function [ze, proba] = get_true_quantile_set(z, xsize, usize, a, const)

eval = z;
bool = zeros(xsize, usize, 1);

for i = 1:size(eval,2)
    eval_i = eval(:,i);
    eval_i = reshape(eval_i,xsize,usize);
    bool = bool + ((eval_i >= const(1,i)) & (eval_i <= const(2,i)));
end
bool = fix(bool);
proba = mean((bool == size(eval,2)),2)';

ze = (proba <= a);

end
