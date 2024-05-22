% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 


function proba = proba_tau(Model, dn , zn, xt, st, prm, config)

proba = zeros(config.pts_x,1);

for i = 1:config.pts_x
    traj = zeros(size(st,1), config.nTraj, prm.M);
    bool = zeros(size(traj));

    for m = 1:prm.M
        traj(:,:,m) = stk_generate_samplepaths(Model(m), dn, zn(:,m), adapt_set([xt(i,:)],st), config.nTraj);
        bool(:,:,m) = ( (traj(:,:,m) >= prm.const(1,m)) & (traj(:,:,m) <= prm.const(2,m)) );
    end

    bool = prod(bool,3);
    bool = (mean(bool,1) <= prm.alpha);
    proba(i) = mean(bool,"all");

end
