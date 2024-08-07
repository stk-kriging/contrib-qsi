% Copyright Notice
%
%    Copyright (C) 2024 CentraleSupelec
%
%    Author(s): Julien Bect <julien.bect@centralesupelec.fr>

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


function p = hermipol(n)
% create hermite polynomial

p(1,1)=1;
p(2,1:2)=[2 0];
for k=2:n
    p(k+1,1:k+1)=2*[p(k,1:k) 0]-2*(k-1)*[0 0 p(k-1,1:k-1)];
end

end
