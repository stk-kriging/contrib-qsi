function [f1, f2] = make_graphs_(funct_struct, config_func, name_list, name_graphs, id_list, AX, SAVE)

[prm, f, s_trnsf] = funct_struct();
config = config_func();

if nargin < 7
    SAVE = 0;
end

if (SAVE ~= 0) && (SAVE ~=1)
    error("Invalid value for variable SAVE.")
end

here = fileparts(mfilename('fullpath'));
visi = 'on';
PTS_DIM = 250;

wid = int64(450);
hei = int64(0.76*wid);

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

            filename = fullfile(here, '../../data/results/design', sprintf('doe_%s_%s_%d.csv', name, prm.name, it));
            filename_para = fullfile(here, '../../data/results/param', sprintf('param_%s_1_%s_%d.csv', name, prm.name, it));
            filename_cov = fullfile(here, '../../data/results/param', sprintf('cov_%s_1_%s_%d.csv', name, prm.name, it));

            file = readmatrix(filename);
            file_para = readmatrix(filename_para);
            file_cov = readmatrix(filename_cov);

            cov = convertStringsToChars(prm.list_cov(file_cov(T+1,:)));

            Model = stk_model(cov,2);
            Model.param = file_para(T+1, :);
            Model.lognoisevariance = config.lognugget;
            set = get_expected_quantile_set(Model,df,PTS_DIM, PTS_DIM,file(1:config.pts_init+T,:),f(file(1:config.pts_init+T,:)),prm.const,prm.alpha);

            f1 = figure('Position', [10 10 wid hei], 'visible', visi, 'Renderer','painters');
            %set(gcf,'renderer','Painters')
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

            f2 = figure('Visible',visi,'Position', [10 10 wid hei], 'Renderer','painters');
            axis([double(prm.BOXx)', 0, 1])
            hold on
            stairs(double(xf),trueSet,'LineWidth',1,'DisplayName','$c(x)$','Color','black')
            hold on
            stairs(double(xf),(1/2)*set,'LineWidth',1,'DisplayName','$\frac{1}{2}\hat{c}(x)$','Color','red')
            hold on
            xlabel("\bfX")
            legend('Location','northwest','Interpreter','latex');
            title(name_graphs(m))

        end

    end
end