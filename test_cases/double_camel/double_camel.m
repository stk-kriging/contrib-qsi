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

function y = double_camel (x)

xx = double (x);

% First term

x1 = xx(:, 1);
x2 = xx(:, 3);

y1 = (4 - 2.1*x1.^2 + (x1.^4)/3) .* x1.^2 ...
     + x1.*x2 + (-4 + 4*x2.^2) .* x2.^2;

% Second term

x1 = xx(:, 2);
x2 = xx(:, 4);

y2 = (4 - 2.1*x1.^2 + (x1.^4)/3) .* x1.^2 ...
     + x1.*x2 + (-4 + 4*x2.^2) .* x2.^2;

% Output

y = (y1 + y2) * 0.5;

end
