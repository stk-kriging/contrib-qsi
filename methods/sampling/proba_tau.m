% Copyright Notice
%
%    Copyright (C) 2024 CentraleSupelec
%
%    Author(s): Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr>

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
