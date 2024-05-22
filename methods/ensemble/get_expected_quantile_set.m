%Compute the expected set given a DoE

% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 



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
