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


function y = hart4 (x)

xx = double(x);

alpha = [1.0, 1.2, 3.0, 3.2]';
A = [10, 3, 17, 3.5, 1.7, 8;
    0.05, 10, 17, 0.1, 8, 14;
    3, 3.5, 1.7, 10, 17, 8;
    17, 8, 0.05, 10, 0.1, 14];
P = 10^(-4) * [1312, 1696, 5569, 124, 8283, 5886;
    2329, 4135, 8307, 3736, 1004, 9991;
    2348, 1451, 3522, 2883, 3047, 6650;
    4047, 8828, 8732, 5743, 1091, 381];

outer = 0;
for ii = 1:4
    inner = 0;
    for jj = 1:4
        xj = xx(:,jj);
        Aij = A(ii, jj);
        Pij = P(ii, jj);
        inner = inner + Aij*(xj-Pij).^2;
    end
    new = alpha(ii) * exp(-inner);
    outer = outer + new;
end

y = -(1.1 - outer) / 0.839;

end
