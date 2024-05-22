%Allow to extract and save statistics on the algorithms given a list_id of
%runs.

% Copyright Notice
%
% Copyright (C) 2024 CentraleSupelec
%
%    Authors: Romain Ait Abdelmalek-Lomenech <romain.ait@centralesupelec.fr> 
%             Julien Bect <julien.bect@centralesupelec.fr>


function extract_deviation(funct_struct, config, name, it, filePath)

disp("Run number "+int2str(it))

if nargin < 5
    filePath = 'data';
end

PTS_X = 2^12;
PTS_S = 2^10;

[prm, f, s_trnsf] = funct_struct();
config = config();

here = fileparts(mfilename('fullpath'));

dim_tot = prm.dim_x+prm.dim_s;

xf = stk_sampling_sobol(PTS_X, prm.dim_x, prm.BOXx);
sf = stk_sampling_sobol(PTS_S, prm.dim_s, prm.BOXs);
sf = s_trnsf(sf);
df = adapt_set(xf,sf);

zf = f(df);

trueSet = get_true_quantile_set(zf, PTS_X, PTS_S, prm.alpha, prm.const);


    file_design = sprintf('doe_%s_%s_%d.csv', name, prm.name, it);
    design = readmatrix(fullfile(here, filePath, 'results/design', file_design));

    para = zeros(config.T+1, dim_tot+1, prm.M);
    file_cov = zeros(config.T+1,1,prm.M);

    for m =1:prm.M
        filename_para = sprintf('param_%s_%d_%s_%d.csv', name, m, prm.name, it);
        para(:,:,m) = readmatrix(fullfile(here, filePath, 'results/param/', filename_para));
        filename_cov = sprintf('cov_%s_%d_%s_%d.csv', name, m, prm.name, it);
        file_cov(:,:,m) = readmatrix(fullfile(here, filePath, 'results/param/', filename_cov));
    end

    dev = [];

    for j = 1:config.axT:config.T+1
        dt = design(1:config.pts_init+j-1,:);
        zt = f(dt);
        Model = stk_model ();

        for m = 1:prm.M
            cov = convertStringsToChars(prm.list_cov(file_cov(j,:,m)));
            Model(m) = stk_model(cov, dim_tot);
            Model(m).param = para(j,:,m);
        end

        approxSet = get_expected_quantile_set(Model,df,PTS_X, PTS_S,dt,zt,prm.const,prm.alpha);
        dev = [dev, lebesgue_deviation(trueSet,approxSet)];

    end

    filename_dev = sprintf('dev_%s_%s_%d.csv', name, prm.name, it);
    writematrix(dev,fullfile(here, filePath, 'results/deviations', filename_dev));

end

