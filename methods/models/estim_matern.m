%estimate matern param with constraint on regularity
function [cov, param, ind_cov] = estim_matern(xi, zi, list_cov)

lhood = inf;
d = size(xi,2);

for j = 1:size(list_cov,1)
    cov_temp = convertStringsToChars(list_cov(j));
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