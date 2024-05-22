%Usage: generate_grid(@funct_struct, @config, list_id)
% Generate initial design for experiments on a given function, for a list
% of identifiers.
%Initial designs are saved in /grid.

function generate_grid(funct_struct, config, list_id)

[prm, ~, s_trnsf] = funct_struct();
config = config();
here = fileparts(mfilename('fullpath'));

%loop on run ids
for it = list_id
    dim_tot = prm.dim_x+prm.dim_s;
    di = stk_sampling_maximinlhs(config.pts_init,dim_tot,prm.BOX);
    filename = sprintf ('grid_%s_%d_init.csv', prm.name, it);
    writematrix (double (di), fullfile (here, 'grid', filename));
end

end
