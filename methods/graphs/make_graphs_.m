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

function make_graphs_ (figs,                  ...
    data_dir, funct_struct, config_func,      ...
    name_list, name_graphs, id_list, AX, SAVE )

[prm, f, s_trnsf] = funct_struct();
config = config_func();

if nargin < 7
    SAVE = 0;
end

if (SAVE ~= 0) && (SAVE ~=1)
    error("Invalid value for variable SAVE.")
end

PTS_DIM = 250;

for m = 1:size(name_list,2)

    name = name_list(m);

    xf = stk_sampling_regulargrid(PTS_DIM, prm.dim_x, prm.BOXx);
    sf = stk_sampling_regulargrid(PTS_DIM, prm.dim_s, prm.BOXs);
    sf = s_trnsf(sf);
    df = adapt_set(xf,sf);
    zf = f(df);

    trueSet = get_true_quantile_set(zf, PTS_DIM, PTS_DIM, prm.alpha, prm.const);

    for it = id_list

        for T = AX

            warning('off','all')

            filename = fullfile (data_dir, 'results', 'design', ...
                sprintf ('doe_%s_%s_%d.csv', name, prm.name, it));
            filename_para = fullfile (data_dir, 'results', 'param', ...
                sprintf ('param_%s_1_%s_%d.csv', name, prm.name, it));
            filename_cov = fullfile (data_dir, 'results', 'param', ...
                sprintf ('cov_%s_1_%s_%d.csv', name, prm.name, it));

            file = readmatrix(filename);
            file_para = readmatrix(filename_para);
            file_cov = readmatrix(filename_cov);

            cov = convertStringsToChars(prm.list_cov(file_cov(T+1,:)));

            Model = stk_model(cov,2);
            Model.param = file_para(T+1, :);
            Model.lognoisevariance = config.lognugget;
            set = get_expected_quantile_set(Model,df,PTS_DIM, PTS_DIM,file(1:config.pts_init+T,:),f(file(1:config.pts_init+T,:)),prm.const,prm.alpha);

            figure (figs(1));

            figure (figs(2));  clf (figs(2));
            hold on
            p = pcolor(double(xf), double(sf)', reshape(f(df), PTS_DIM, PTS_DIM)');
            p.EdgeColor = 'none';

            hold on
            contour(double(xf), double(sf)' ,reshape((f(df)<=prm.const(2,1)), PTS_DIM, PTS_DIM)',[1],'black','LineWidth',1);
            hold on
            contour(double(xf), double(sf)' ,reshape(((stk_predict(Model,file(1:config.pts_init+T,:),f(file(1:config.pts_init+T,:)),df).mean)<=prm.const(2,1)), PTS_DIM, PTS_DIM)',[1],'red','LineWidth',1);
            hold on
            scatter(file(1:20,1),file(1:20,2),15,'black','filled')
            hold on
            scatter(file(config.pts_init+1:config.pts_init+T,1),file(config.pts_init+1:config.pts_init+T,2),15,'red','filled')
            hold on
            %text(file(prm.pts_init+1:prm.pts_init+T,1)+0.1,file(prm.pts_init+1:prm.pts_init+T,2)+0.1,string(1:T))
            hold on
            colorbar
            xlabel("\bfX")
            ylabel("\bfS")
            hold on
            title(name_graphs(m))

            figure (figs(3));  clf (figs(3));
            axis([double(prm.BOXx)', 0, 1])
            hold on
            stairs(double(xf),trueSet,'LineWidth',1,'DisplayName','$c(x)$','Color','black')
            hold on
            stairs(double(xf),(1/2)*set,'LineWidth',1,'DisplayName','$\frac{1}{2}\hat{c}(x)$','Color','red')
            hold on
            xlabel("\bfX")
            legend('Location','northwest','Interpreter','latex');
            title(name_graphs(m))

            drawnow ();
        end

    end
end