%Usage: random(@funct_struct, @config, list_id)
%Random DoE
%DoE and models parameters are save in /results

function random(funct_struct, config, id)

[prm, f, s_trnsf] = funct_struct();
config = config();
here = fileparts(mfilename('fullpath'));

dim_tot = prm.dim_x+prm.dim_s;

for it = id

    %Initial design
    file_grid = sprintf ('grid_%s_%d_init.csv', prm.name, it);
    di = readmatrix(fullfile(here, 'grid', file_grid));
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

        %sample random point in X x S
        newpt = double(stk_sampling_randunif(1,dim_tot,prm.BOX));
        newpt(:, prm.dim_x+1:prm.dim_x+prm.dim_s) = s_trnsf(newpt(:, prm.dim_x+1:prm.dim_x+prm.dim_s));

        time = [time, toc];

        dn = stk_dataframe([dn;newpt]);
        zn = stk_dataframe([zn;f(newpt)]);

    end

    % Save design and param
    for m = 1:prm.M
        [Model(m), ind_cov] = estim_matern ...
            (dn, zn(:,m), prm.list_cov, config.lognugget);
        save_cov(config.T+1,:,m) = ind_cov;
        save_param(config.T+1,:,m) = Model(m).param;
    end

    filename = sprintf ('doe_random_%s_%d.csv', prm.name, it);
    writematrix(double (dn), fullfile (here, 'results/design', filename));

    for m = 1:prm.M
        filename = sprintf ('param_random_%d_%s_%d.csv', m, prm.name, it);
        writematrix(save_param(:,:,m), fullfile (here, 'results/param', filename));

        filename = sprintf ('cov_random_%d_%s_%d.csv', m, prm.name, it);
        writematrix (save_cov(:,:,m), fullfile (here, 'results/param', filename));
    end

    filename = sprintf ('time_random_%s_%d.csv', prm.name, it);
    writematrix(time, fullfile (here, 'results/time', filename));

end

end
