% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 
%             Julien Bect <julien.bect@centralesupelec.fr>

function [s_trnsf, pdf] = branin_mod_s_trnsf(s)

alpha = 7.5;
beta = 1.9;

s = s/15;

s_trnsf = 15*betainv(double(s), alpha, beta);

if nargout > 1
    pdf = 1/15*betapdf(double(s), alpha, beta);
end

end
