%Usage: generate_grid(@funct_struct, @config, list_id)
% Generate initial design for experiments on a given function, for a list
% of identifiers.
%Initial designs are saved in /data/doe_init.

% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr>

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
