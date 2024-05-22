% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 
%             Julien Bect <julien.bect@centralesupelec.fr>


% Estimate matern param with constraint on regularity
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