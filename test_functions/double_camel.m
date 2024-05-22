% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 
%             Julien Bect <julien.bect@centralesupelec.fr>

function y = double_camel (x)

xx = double (x);

% First term

x1 = xx(:, 1);
x2 = xx(:, 3);

y1 = (4 - 2.1*x1.^2 + (x1.^4)/3) .* x1.^2 ...
     + x1.*x2 + (-4 + 4*x2.^2) .* x2.^2;

% Second term

x1 = xx(:, 2);
x2 = xx(:, 4);

y2 = (4 - 2.1*x1.^2 + (x1.^4)/3) .* x1.^2 ...
     + x1.*x2 + (-4 + 4*x2.^2) .* x2.^2;

% Output

y = (y1 + y2) * 0.5;

end
