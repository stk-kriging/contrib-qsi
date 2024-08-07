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



function y = double_camel(x)

%first term
xx = double(x(:,[1,3]));

x1 = xx(:,1);
x2 = xx(:,2);

term1 = (4-2.1*x1.^2+(x1.^4)/3) .* x1.^2;
term2 = x1.*x2;
term3 = (-4+4*x2.^2) .* x2.^2;

y1 = term1 + term2 + term3;

%second term
xx = double(x(:,[2,4]));

x1 = xx(:,1);
x2 = xx(:,2);

term1 = (4-2.1*x1.^2+(x1.^4)/3) .* x1.^2;
term2 = x1.*x2;
term3 = (-4+4*x2.^2) .* x2.^2;

y2 = term1 + term2 + term3;


y = (y1 + y2)/2;

end
