% Copyright Notice
%
% Copyright (C)2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 


function prob = proba_joint_cond(const,mu_dn,lambda_pt,var,sigma)

mu = mu_dn + var*lambda_pt;
prob = stk_distrib_normal_cdf(const(2),mu,sigma)-stk_distrib_normal_cdf(const(1),mu,sigma);

end
