% Usage: random (@funct_struct, @config, list_id, data_dir)
% Random DoE
% DoE and models parameters are save in data/results

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



function random (funct_struct, config, it, data_dir)

disp("Run number "+int2str(it))

if nargin < 4
    here = fileparts (mfilename ('fullpath'));
    data_dir = fullfile (here, 'data');
end

[prm, f, s_trnsf] = funct_struct();
config = config();
here = fileparts(mfilename('fullpath'));

dim_tot = prm.dim_x+prm.dim_s;

    %Initial design
    file_grid = sprintf ('doe_init_%s_%d_init.csv', prm.name, it);
    di = readmatrix(fullfile(data_dir, 'doe_init', file_grid));
    zi = f(di);

    % Create dataframes
    dn = stk_dataframe(di);
    zn = stk_dataframe(zi);
    save_param = zeros(config.T+1,dim_tot+1,prm.M);
    save_cov = zeros(config.T+1, 1, prm.M);

    time = [];

    %loop on steps
    for t = 1:config.T
        tic

        % Estimate and save parameters
        % (not used in the following script)
        Model = stk_model ();
        for m = 1:prm.M
            [Model(m), ind_cov] = estim_matern ...
                (dn, zn(:,m), prm.list_cov, config.lognugget);
            save_cov(t,:,m) = ind_cov;
            save_param(t,:,m) = Model(m).param;
        end

        % Sample one random point, uniformly distributed in X x S
        newpt = double (stk_sampling_randunif (1, dim_tot, prm.BOX));

        time = [time, toc];

        dn = stk_dataframe([dn;newpt]);
        zn = stk_dataframe([zn;f(newpt)]);

    end

    % Save design and param
    for m = 1:prm.M
        if mod(t, config.estim_param_steps) == 0
        [Model(m), ind_cov] = estim_matern ...
            (dn, zn(:,m), prm.list_cov, config.lognugget);
        end
        save_cov(config.T+1,:,m) = ind_cov;
        save_param(config.T+1,:,m) = Model(m).param;
    end

    filename = sprintf ('doe_random_%s_%d.csv', prm.name, it);
    writematrix(double (dn), fullfile (data_dir, 'results/design', filename));

    for m = 1:prm.M
        filename = sprintf ('param_random_%d_%s_%d.csv', m, prm.name, it);
        writematrix(save_param(:,:,m), fullfile (data_dir, 'results/param', filename));

        filename = sprintf ('cov_random_%d_%s_%d.csv', m, prm.name, it);
        writematrix (save_cov(:,:,m), fullfile (data_dir, 'results/param', filename));
    end

    filename = sprintf ('time_random_%s_%d.csv', prm.name, it);
    writematrix(time, fullfile (data_dir, 'results/time', filename));

end
