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



function [ze, proba] = get_expected_quantile_set(model, df, xsize, usize,dn,zn,const,a)
eval = 1 +zeros(xsize*usize,1);

for m = 1:size(model,2) %assume outputs independant
    pred = stk_predict(model(m),dn,zn(:,m),df);
    mu = pred.mean;
    var = pred.var;
    eval_temp = stk_distrib_normal_cdf(const(2,m),mu,sqrt(var))-stk_distrib_normal_cdf(const(1,m),mu,sqrt(var));
    eval = eval.*eval_temp;
end

eval = reshape(eval,xsize,usize);

proba = sum(eval,2)/usize;
ze = (proba <= a)';

end
