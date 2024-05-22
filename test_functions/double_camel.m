% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 
%             Julien Bect <julien.bect@centralesupelec.fr>

function y = double_camel(x)

%first term
xx = double(x(:,[1,3]));

x1 = xx(:,1);
x2 = xx(:,2);

term1 = (4-2.1*x1.^2+(x1.^4)/3) .* x1.^2;
term2 = x1.*x2;
term3 = (-4+4*x2.^2) .* x2.^2;

y1 = term1 + term2 + term3;

%second term
xx = double(x(:,[2,4]));

x1 = xx(:,1);
x2 = xx(:,2);

term1 = (4-2.1*x1.^2+(x1.^4)/3) .* x1.^2;
term2 = x1.*x2;
term3 = (-4+4*x2.^2) .* x2.^2;

y2 = term1 + term2 + term3;


y = (y1 + y2)/2;

end
