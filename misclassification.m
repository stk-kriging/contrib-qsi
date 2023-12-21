%Usage: misclassification(@funct_struct, @config, list_id)
%Compute sequential DoE using maximal uncertainty sampling based on
%misclassification probability (equivalent to variance or entropy).
%DoE and models parameters are save in /results

function misclassification(funct_struct, config, id)

[prm, f, s_trnsf] = funct_struct();
config = config();
here = fileparts(mfilename('fullpath'));

dim_tot = prm.dim_x+prm.dim_s;

for it = id
    %Initial design
    file_grid = sprintf ('grid_%s_%d_init.csv', prm.name, it);
    di = readmatrix(fullfile(here, 'grid', file_grid));
    zi = f(di);

    %Model (x,s)
    Model = [];

    % Create dataframes
    dn = stk_dataframe(di);
    zn = stk_dataframe(zi);

    %Prepare tab to save param
    save_param = zeros(config.T+1,dim_tot+1,prm.M);
    save_cov = zeros(config.T+1, 1, prm.M);

    time = [];
    pts_tot = config.pts_x*config.pts_s;

    %loop on steps
    for t = 1:config.T

        tic

        %sample points in X x S
        dt = stk_sampling_randunif(pts_tot,dim_tot,prm.BOX);
        dt(:, prm.dim_x+1:prm.dim_x+prm.dim_s) = s_trnsf(dt(:, prm.dim_x+1:prm.dim_x+prm.dim_s));

        % Estimate and save parameters
        Model = [];
        for m = 1:prm.M
            [Model(m), ind_cov] = estim_matern ...
                (dn, zn(:,m), prm.list_cov, config.lognugget);
            save_cov(t,:,m) = ind_cov;
            save_param(t,:,m) = Model(m).param;
        end

        %compute misclassification probability
        proba = proba_xi(Model, dn, zn, dt, prm);

        crit_tab = min(proba,1-proba);
        crit_tab = double(crit_tab);

        % Update design
        [~, indmax] = max(crit_tab);
        newpt = dt(indmax,:);

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

    filename = sprintf ('doe_misclassification_%s_%d.csv', prm.name, it);
    writematrix (double (dn), fullfile (here, 'results/design', filename));

    for m = 1:prm.M
        filename = sprintf ('param_misclassification_%d_%s_%d.csv', m, prm.name, it);
        writematrix(save_param(:,:,m), fullfile (here, 'results/param', filename));

        filename = sprintf ('cov_misclassification_%s_%d_%s_%d.csv', critName, m, prm.name, it);
        writematrix (save_cov(:,:,m), fullfile (here, 'results/param', filename));
    end

    filename = sprintf ('time_misclassification_%s_%d.csv', prm.name, it);
    writematrix(time, fullfile (here, 'results/time', filename));

end

end
