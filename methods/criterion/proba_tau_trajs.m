% Copyright Notice
%
%    Copyright (C) 2024 CentraleSupelec
%
%    Author(s): Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr>
%               Julien Bect <julien.bect@centralesupelec.fr>

% Copying Permission Statement
%
%    This file is part of contrib-qsi (https://github.com/stk-kriging/contrib-qsi)
%
%    contrib-qsi is free software: you can redistribute it and/or modify it under
%    the terms of the GNU General Public License as published by the Free
%    Software Foundation,  either version 3  of the License, or  (at your
%    option) any later version.
%
%    contrib-qsi is distributed  in the hope that it will  be useful, but WITHOUT
%    ANY WARRANTY;  without even the implied  warranty of MERCHANTABILITY
%    or FITNESS  FOR A  PARTICULAR PURPOSE.  See  the GNU  General Public
%    License for more details.
%
%    You should  have received a copy  of the GNU  General Public License
%    along with contrib-qsi.  If not, see <http://www.gnu.org/licenses/>.


function proba = proba_tau_trajs(bool, alpha)

[config_nVar, prm_M] = size (bool);
config_keep_x = size (bool{1,1}, 1);

proba = zeros (config_keep_x, config_nVar);

for k = 1:config_nVar

    % Product of indicator functions (intersection)
    b = bool{k, 1};
    for m = 2:prm_M
        b = b & bool{k,m};
    end

    % Test for each x if the probability is less than alpha
    b = (mean (b, 2) <= alpha);

    % Average with respect to the trajectories
    proba(:, k) = mean (b, 3);

end

end
