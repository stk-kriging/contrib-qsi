% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 



function set = adapt_set(xt,st)

set = cell(1,2);
set{1} = (1:size(xt,1))';
set{2} = (1:size(st,1))';

order = double(stk_factorialdesign(set));

set = [xt(order(:,1),:),st(order(:,2),:)];

end
