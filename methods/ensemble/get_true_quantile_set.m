% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 

function [ze, proba] = get_true_quantile_set(z, xsize, usize, a, const)

eval = z;
bool = zeros(xsize, usize, 1);

for i = 1:size(eval,2)
    eval_i = eval(:,i);
    eval_i = reshape(eval_i,xsize,usize);
    bool = bool + ((eval_i >= const(1,i)) & (eval_i <= const(2,i)));
end
bool = fix(bool);
proba = mean((bool == size(eval,2)),2)';

ze = (proba <= a);

end
