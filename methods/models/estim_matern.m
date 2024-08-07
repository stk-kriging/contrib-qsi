% Estimate matern param with constraint on regularity

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



function [model_opt, idx_cov_opt] = ...
    estim_matern (xi, zi, list_cov, lognugget)

model_opt = [];
lhood_opt = +inf;

for j = 1:(size (list_cov, 1))

    model = stk_model (char (list_cov(j)), size (xi, 2));
    model.lognoisevariance = lognugget;
    [model.param, ~, info] = stk_param_estim (model, xi, zi);

    if info.crit_opt < lhood_opt
        lhood_opt = info.crit_opt;
        model_opt = model;
        idx_cov_opt = j;
    end
end

end