%Compute lesbegue measure of the NON SYMMETRIC difference between two
%quantile sets.

% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 

function dev = lebesgue_diff(set1,set2)

part1 = set1-set2;

dev = (1/size(set1,2))*(sum(part1>0));

end
