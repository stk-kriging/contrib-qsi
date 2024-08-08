% Copyright Notice
%
%

function proba = proba_xi(Model, dn, zn, dt, prm)

proba = 1;

for m = 1:prm.M
    pred = stk_predict(Model(m),dn,zn(:,m),dt);
    proba = proba .* (stk_distrib_normal_cdf(prm.const(2,m),pred.mean,sqrt(pred.var)) - stk_distrib_normal_cdf(prm.const(1,m),pred.mean,sqrt(pred.var)))';
end

end
