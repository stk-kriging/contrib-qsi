% Estimate Matern parametrs with constraint on regularity

function [cov, param, ind_cov] = estim_matern (xi, zi, prm, cov_idx)

% Default: use all covariance functions from prm.lis_cov
if nargin < 4
    cov_idx = 1:(size (prm.list_cov, 1));
end

lhood = inf;
d = size(xi,2);

for j = cov_idx
    cov_temp = convertStringsToChars (prm.list_cov(j));
    model = stk_model(cov_temp, d);
    param_temp = stk_param_estim(model, xi, zi);
    model.param = param_temp;
    lhood_temp = stk_param_relik(model,xi,zi);

    if lhood_temp < lhood
        lhood = lhood_temp;
        cov = cov_temp;
        ind_cov = j;
        param = param_temp;
    end
end

end