% Usage: joint_SUR (@funct_struct, @config, list_id, data_dir)
% Compute sequential DoE using joint SUR criterion
% DoE and models parameters are save in data/results

% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr>

function joint_SUR (funct_struct, config, it, data_dir)

disp("Run number "+int2str(it))

if nargin < 4
    here = fileparts (mfilename ('fullpath'));
    data_dir = fullfile (here, 'data');
end

[prm, f, s_trnsf] = funct_struct();
config = config();
here = fileparts(mfilename('fullpath'));

dim_tot = prm.dim_x+prm.dim_s;

    %If size output = 1, initizalize Gaussian quadrature + define threshold
    if prm.M == 1
        quantOpt.nbLevels = config.nVar;
        quantOpt.useGaussHermite = 1;

        if abs(prm.const(1)) ~= inf
            crit_U = prm.const(1);
        else
            crit_U = prm.const(2);
        end
    end

    %Initial design
    file_grid = sprintf ('doe_init_%s_%d_init.csv', prm.name, it);
    di = readmatrix(fullfile(data_dir, 'doe_init', file_grid));
    zi = f(di);

    % Create dataframes
    dn = stk_dataframe(di);
    zn = stk_dataframe(zi);

    %stocking parameters
    save_param = zeros(config.T+1,dim_tot+1,prm.M);
    save_cov = zeros(config.T+1, 1, prm.M);

    time = [];

    for t = 1:config.T
        tic

        dt = stk_sampling_randunif(config.pts_x*config.pts_s,dim_tot,prm.BOX);
        %dt(:, prm.dim_x+1:prm.dim_x+prm.dim_s) = s_trnsf(dt(:, prm.dim_x+1:prm.dim_x+prm.dim_s));

        % Estimate and save parameters
        Model = stk_model ();
        for m = 1:prm.M
            [Model(m), ind_cov] = estim_matern ...
                (dn, zn(:,m), prm.list_cov, config.lognugget);
            save_cov(t,:,m) = ind_cov;
            save_param(t,:,m) = Model(m).param;
        end

        %Compute misclassification probability in the joint space
        proba_xs = proba_xi(Model, dn, zn, dt, prm);

        misclass_xs = min(proba_xs,1-proba_xs)';

        [~, sort_misclass_xs] = sort(misclass_xs,'descend');
        ranking_x = [sort_misclass_xs(1)]; %keep most misclassified point

        %Sample accord to misclassification probability
        if sum((misclass_xs > 0))<=config.keep
            ranking_x = sort_misclass_xs(1:config.keep);
        else
            candidate_set = setdiff(find(misclass_xs > 0), ranking_x);

            while size(ranking_x,1) < config.keep

                candidate = randsample(candidate_set,1, true, misclass_xs(candidate_set));
                ranking_x = [ranking_x; candidate];
                candidate_set = setdiff(candidate_set, candidate);
            end
        end

        dt = dt(ranking_x,:);

        %Compute IS weight
        IS = zeros(config.nVar,1,config.keep);
        for j = 1:config.nVar
            IS(j,1,:) = 1/misclass_xs(ranking_x);
        end

        ranking_xs = 1:config.keep2;

        n_cond = size(dn,1);
        pts_dt = config.keep;


        crit_tab = inf + zeros(1,config.keep2); 

        % Start boucle on dt.

        if prm.M == 1 
            [z_pred, ignore_lambda, ignore_mu, Kpost_all] = ...
            stk_predict (Model(1), dn, zn, dt);
            for i = 1:config.keep2
                K12 = Kpost_all(:, i);  % Posterior covariance between locations x and x_new
                K22 = Kpost_all(i, i);  % Posterior variance at xnew

                crit_tab(i) = mean(stk_pmisclass (crit_U, z_pred, K12, K22));
            end

        else
            for i = 1:config.keep2
                pt = double(dt(i,:));
                crit = 0;

            var = [];

            for m = 1:prm.M
                p = stk_predict(Model(m),dn,zn(:,m),pt);
                if prm.M == 1
                    [var, weight] = quantization(p.mean, sqrt(p.var), quantOpt);
                else
                    var = [var; p.mean+sqrt(p.var)*randn(config.nVar,1)'];
                    weight = 1/prm.nVar*ones(size(var));
                end
            end

            xc = double([dn;pt]);
            xc_ind = size(xc,1)-1;

            proba = zeros(config.nVar, prm.M, size(dt,1));

            for m = 1:prm.M
                [pred, lambda]  = stk_predict(Model(m),[dn;pt],[],[dn;dt]);
                lambda_dn = lambda(1:size(lambda,1)-1,n_cond+1:n_cond+pts_dt); %cond to dn
                lambda_pt = lambda(size(lambda,1),n_cond+1:n_cond+pts_dt);

                mu_dn  = zn(:,m)' * lambda_dn;
                sigma = sqrt(pred.var(n_cond+1:n_cond+pts_dt,:))';

                %Compute criterion for every variables
                for k=1:config.nVar
                    proba(k, m, :) = proba_joint_cond(prm.const(:,m),mu_dn,lambda_pt,var(k),sigma);

                end

            end
            proba = prod(proba,2);

            switch config.critName
                case "m"
                    s = min (proba, 1 - proba);
                case "v"
                    s = proba .* (1 - proba);
                case "e"
                    qroba = 1 - proba;
                    s = tools.nan2zero (-proba .* log2(proba)) ...
                        + tools.nan2zero (-qroba .* log2(qroba));
                otherwise
                    error("Invalid criterion name")
            end

            crit_tab(i) = weight * (mean (IS .* s, 3));
            end

        end

        % Update design

        [~, indmin] = min(crit_tab);
        newpt = dt(indmin,:);

        time = [time, toc];

        dn = stk_dataframe([dn;newpt]);
        zn = stk_dataframe([zn;f(newpt)]);

    end

    % Save design and params
    for m = 1:prm.M
        if mod(t, config.estim_param_steps) == 0
        [Model(m), ind_cov] = estim_matern ...
            (dn, zn(:,m), prm.list_cov, config.lognugget);
        end
        save_cov(config.T+1,:,m) = ind_cov;
        save_param(config.T+1,:,m) = Model(m).param;
    end

    filename = sprintf ('doe_joint_%s_%s_%d.csv',config.critName, prm.name, it);
    writematrix (double (dn), fullfile (data_dir, 'results/design', filename));

    for m = 1:prm.M
        filename = sprintf ('param_joint_%s_%d_%s_%d.csv', config.critName, m, prm.name, it);
        writematrix (save_param(:,:,m), fullfile (data_dir, 'results/param', filename));

        filename = sprintf ('cov_joint_%s_%d_%s_%d.csv', config.critName, m, prm.name, it);
        writematrix (save_cov(:,:,m), fullfile (data_dir, 'results/param', filename));
    end

    filename = sprintf ('time_joint_%s_%s_%d.csv', config.critName, prm.name, it);
    writematrix (time, fullfile (data_dir, 'results/time', filename));

end

