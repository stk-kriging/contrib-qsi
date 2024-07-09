% Usage: QSI_SUR(@funct_struct, @config, list_id, data_dir, DEMO)
% Compute sequential DoE using QSI criterion
% DoE and models parameters are save in data/results

% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr>
%             Julien Bect <julien.bect@centralesupelec.fr>

function QSI_SUR(funct_struct, config_func, it, data_dir, DEMO)

disp ("Run number " + int2str(it));

if nargin < 4
    here = fileparts (mfilename ('fullpath'));
    data_dir = fullfile (here, 'data');
end

if nargin < 5
    DEMO = 0;
end

[prm, f, s_trnsf] = funct_struct(); %loading function and parameters
config = config_func();
here = fileparts(mfilename('fullpath'));

if DEMO == 1
    if (prm.dim_x ~= 1) || (prm.dim_s ~= 1)
        error("Invalid problem dimension for demo")
    else
        f1 = figure();
        f2 = figure();
        wid = int64(450);
        hei = int64(0.76*wid);
    end
end

if (DEMO ~= 0) && (DEMO ~=1)
    error("Invalid value for variable DEMO.")
end


%loop on different runs

dim_tot = prm.dim_x+prm.dim_s;

%If size output = 1, initizalize Gaussian quadrature
if prm.M == 1
    quantOpt.nbLevels = config.nVar;
    quantOpt.useGaussHermite = 1;
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

% Estimate and save parameters
Model = stk_model ();
for m = 1:prm.M
    [Model(m), ind_cov] = estim_matern ...
        (dn, zn(:,m), prm.list_cov, config.lognugget);
    save_cov(1,:,m) = ind_cov;
    save_param(1,:,m) = Model(m).param;
end

for t = 1:config.T %loop on steps

    if DEMO == 1
        fprintf('Step %d: evaluating QSI-SUR criterion...\n', t);
    end

    tic

    %sampling points in X x S
    xt = stk_sampling_randomlhs(config.pts_x,prm.dim_x,prm.BOXx);
    st = stk_sampling_randomlhs(config.pts_s,prm.dim_s,prm.BOXs);
    st = s_trnsf(st);
    dt = adapt_set(xt,st);

    %evaluate misclassification probability of \tau(x)
    proba_x = proba_tau(Model, dn , zn, xt, st, prm, config);
    misclass_x = min(proba_x, 1-proba_x);


    [~, sort_misclass_x] = sort(misclass_x,'descend');
    ranking_x = [sort_misclass_x(1)]; %keeping most uncertain point

    %importance sampling on X
    if sum((misclass_x > 0))<=config.keep_x
        ranking_x = sort_misclass_x(1:config.keep_x);
    else
        candidate_set = setdiff(find(misclass_x > 0),ranking_x);
    end

    while size(ranking_x, 1) < config.keep_x

        candidate = randsample(candidate_set, 1, true, misclass_x(candidate_set));

        candidate_set = setdiff(candidate_set, candidate); %enforce without replacement constraint
        ranking_x = [ranking_x; candidate];
    end

    % Define IS weights
    IS = zeros (config.keep_x, config.nVar);
    for j = 1:config.nVar
        IS(:, j) = 1 / misclass_x(ranking_x);
    end

    %keeping useful parts of dataframe
    xt = xt(ranking_x,:);
    dt = adapt_set(xt,st);

    %evaluate misclassification probability of \xi(x,s)
    proba_xs = proba_xi(Model, dn, zn, dt, prm);

    misclass_xs = min(proba_xs,1-proba_xs)';

    [~, sort_misclass_xs] = sort(misclass_xs,'descend');
    ranking_xs = [sort_misclass_xs(1)];

    if sum((misclass_xs > 0))<=config.keep_xs
        ranking_xs = sort_misclass_xs(1:config.keep_xs);
    else

        candidate_set = setdiff(find(misclass_xs > 0), ranking_xs);

        while size(ranking_xs, 1) < config.keep_xs

            candidate = randsample(candidate_set, 1, true, misclass_xs(candidate_set));

            ranking_xs = [ranking_xs; candidate];
            candidate_set = setdiff(candidate_set, candidate);
        end

    end

    traj = zeros(size(dn,1)+size(dt,1), config.nTraj, prm.M);

    for m = 1:prm.M
        traj(:,:,m) = stk_generate_samplepaths(Model(m), [dn;dt], config.nTraj);
    end
    crit_tab = inf + zeros(1,config.keep_xs);

    %loop on candidate points
    for r = 1:config.keep_xs

        i = ranking_xs(r);

        pt = double(dt(i,:));
        crit = 0;


        %Draw variables, get kriging matrix
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

        bool = cell (config.nVar, prm.M);

        %Generate conditional sample paths
        for m = 1:prm.M
            [~, lambda]  = stk_predict (Model(m), [dn; pt], [], [dn; dt]);
            lambda_dn = lambda(1:size(lambda,1)-1,:); %cond to dn
            lambda_pt = lambda(size(lambda,1),xc_ind+1:size(traj,1)); %cond to pt restricted to dt

            trajCond_dn = stk_conditioning(lambda_dn,zn(:,m),traj(:,:,m),[1:xc_ind]); %Sample paths on dt condt to dn
            trajCond_dn = trajCond_dn(xc_ind+1:size(trajCond_dn,1),:); %Delete on dn

            %%% Prepare inputs for probability computation
            lambda_pt = reshape(lambda_pt,config.keep_x,config.pts_s);
            tensor_dn = reshape(trajCond_dn,config.keep_x, config.pts_s, config.nTraj);

            traj_dt = traj(xc_ind+1:size(traj,1),:,m); %Delete observations on dn
            traj_ind = reshape(traj_dt(i,:),1,1,config.nTraj);

            %Compute criterion for every variables
            for k=1:config.nVar
                bool{k,m} = check_constraints_trajs(tensor_dn,traj_ind,var(k),lambda_pt,prm.const(:,m));
            end

        end


        proba = proba_tau_trajs(bool, prm.alpha);

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

        crit_tab(r) = sum (weight .* (mean (IS .* s, 1)));

    end

    % Update design

    [~, indmin] = min(crit_tab);
    indmin = ranking_xs(indmin);
    newpt = dt(indmin,:);

    if DEMO == 1
        fprintf('Evaluating function at (%d , %d)\n', newpt(1), newpt(2));
    end

    time = [time, toc];

    dn = stk_dataframe([dn;newpt]);
    zn = stk_dataframe([zn;f(newpt)]);

    if DEMO == 1
        disp('Updating GP parameters...')
    end

    for m = 1:prm.M
        if mod(t, config.estim_param_steps) == 0
            [Model(m), ind_cov] = estim_matern ...
                (dn, zn(:,m), prm.list_cov, config.lognugget);
        end
        save_cov(t+1,:,m) = ind_cov;
        save_param(t+1,:,m) = Model(m).param;
    end


    filename = sprintf ('doe_QSI_%s_%s_%d.csv', config.critName, prm.name, it);
    writematrix (double (dn), fullfile (data_dir, 'results/design', filename));

    for m = 1:prm.M
        filename = sprintf ('param_QSI_%s_%d_%s_%d.csv', config.critName, m, prm.name, it);
        writematrix (save_param(:,:,m), fullfile (data_dir, 'results/param', filename));

        filename = sprintf ('cov_QSI_%s_%d_%s_%d.csv', config.critName, m, prm.name, it);
        writematrix (save_cov(:,:,m), fullfile (data_dir, 'results/param', filename));
    end

    filename = sprintf ('time_QSI_%s_%s_%d.csv', config.critName, prm.name, it);
    writematrix (time, fullfile (data_dir, 'results/time', filename));

    if DEMO == 1

        if (mod(t,3) == 0) && (t >= 3)
            fprintf("Generating graphs (%d points)...\n", t);

            if t == 3
            A = stk_sampling_regulargrid(1000, 1, prm.BOXs);
            A = sort(double(A));
            [~, pdf] = s_trnsf(A);    
            figure('Position', [10 10 1/4*wid hei], 'Renderer','painters')
            hold on
            area(A, pdf, 'FaceAlpha',0.2);
            ylabel("\bfDens. func.")
            xticks([])
            camroll(90);
            end

            [f1, f2] = make_graphs_ (data_dir, funct_struct, config_func, ...
                ["QSI_"+config.critName], [sprintf("%d steps", t)], it, t, 0);
            disp("PAUSED: press any key to continue.")
            pause()
        end

    end

end

end

