%Usage: generate_grid(@funct_struct, @config, list_id)
% Generate initial design for experiments on a given function, for a list
% of identifiers.
%Initial designs are saved in /data/doe_init.

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



function generate_doe_init(funct_struct, config, list_id, data_dir)

[prm, ~, s_trnsf] = funct_struct();
config = config();

if nargin < 4
    here = fileparts (mfilename ('fullpath'));
    data_dir = fullfile (here, '..', 'data');
end

%loop on run ids
for it = list_id
    dim_tot = prm.dim_x+prm.dim_s;
    di = stk_sampling_maximinlhs(config.pts_init,dim_tot,prm.BOX);
    filename = sprintf ('doe_init_%s_%d_init.csv', prm.name, it);
    writematrix (double (di), fullfile (data_dir, 'doe_init', filename));
end

end
