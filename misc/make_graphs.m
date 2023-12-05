% Allows to create sequential graphs representing the obtained DoEs for the different algorithms.
% In future version: simplification and syntax explanation.


[prm, f, s_trnsf] = branin_mod_struct();

name_list = ["QSI_m"];
name_graphs = ["QSI"];

it_list = 1:5;
SAVE = 1;
visi = 'on';
PTS_DIM = 500;
AX = [1, 5, 15, 20, 30];

wid = int64(450);
hei = int64(0.76*wid);

for m = 1:size(name_list,2)

    name = name_list(m);

    xf = stk_sampling_regulargrid(PTS_DIM, prm.dim_x, prm.BOXx);
    sf = stk_sampling_regulargrid(PTS_DIM, prm.dim_s, prm.BOXs);
    sf = s_trnsf(sf);
    df = adapt_set(xf,sf);
    zf = f(df);

    trueSet = ensemble.get_mean_set_multi(zf, PTS_DIM, PTS_DIM, prm.alpha, prm.const);

    for it = it_list
        disp(it)
        for T = AX


            warning('off','all')

            filename = "~/repos/experiments/results/design/doe_"+name+"_"+prm.name+"_"+int2str(it)+".csv";
            filename_para = "~/repos/experiments/results/param/param_"+name+"_1_"+prm.name+"_"+int2str(it)+".csv";
            filename_cov = "~/repos/experiments/results/param/cov_"+name+"_1_"+prm.name+"_"+int2str(it)+".csv";
            file = readmatrix(filename);
            file_para = readmatrix(filename_para);
            file_cov = readmatrix(filename_cov);

            cov = convertStringsToChars(prm.list_cov(file_cov(T+1,:)));

            Model = stk_model(cov,2);
            Model.param = file_para(T+1, :);
            set = ensemble.get_approx_set_multi(Model,df,PTS_DIM, PTS_DIM,file(1:prm.pts_init+T,:),f(file(1:prm.pts_init+T,:)),prm.const,prm.alpha);

            figure('Position', [10 10 wid hei], 'visible', visi, 'Renderer','painters')
            %set(gcf,'renderer','Painters')
            p = pcolor(double(xf), double(sf)', reshape(f(df), PTS_DIM, PTS_DIM)');
            p.EdgeColor = 'none';

            hold on
            contour(double(xf), double(sf)' ,reshape((f(df)>prm.const(1,1)), PTS_DIM, PTS_DIM)',[1],'black','LineWidth',1);
            hold on
            contour(double(xf), double(sf)' ,reshape(((stk_predict(Model,file(1:prm.pts_init+T,:),f(file(1:prm.pts_init+T,:)),df).mean)>prm.const(1,1)), PTS_DIM, PTS_DIM)',[1],'red','LineWidth',1);
            hold on
            scatter(file(1:20,1),file(1:20,2),15,'black','filled')
            hold on
            scatter(file(prm.pts_init+1:prm.pts_init+T,1),file(prm.pts_init+1:prm.pts_init+T,2),15,'red','filled')
            hold on
            %text(file(prm.pts_init+1:prm.pts_init+T,1)+0.1,file(prm.pts_init+1:prm.pts_init+T,2)+0.1,string(1:T))
            hold on
            colorbar
            xlabel("\bfX")
            ylabel("\bfS")
            hold on
            title(name_graphs(m))
            saveas(gcf,"~/repos/experiments/results/graphs_gen/design_"+prm.name+"_"+name+"_"+int2str(it), 'epsc')

            figure('Visible',visi,'Position', [10 10 wid hei], 'Renderer','painters')
            axis([double(prm.BOXx)', 0, 1])
            hold on
            stairs(double(xf),trueSet,'LineWidth',1,'DisplayName','$c(x)$','Color','black')
            hold on
            stairs(double(xf),(1/2)*set,'LineWidth',1,'DisplayName','$\frac{1}{2}\hat{c}(x)$','Color','red')
            hold on
            xlabel("\bfX")
            legend('Location','northwest','Interpreter','latex');
            title(name)
            saveas(gcf,"~/repos/experiments/results/graphs/set_"+prm.name+"_"+name+"_"+int2str(it), 'epsc')

        end

    end
end