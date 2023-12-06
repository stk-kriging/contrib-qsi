prm = branin_mod_struct();
config = branin_mod_config();

methods = ["RSI_IS_m", "localjoint_IS_m"];

name = ["QSI-SUR", "local-joint"];

%methods = ["RSI_SMC_m", "RSI_m"];
%name = ["approx. SMC-RSI", "RSI-SUR"];

nb_run = 100;

wid = int64(450);
hei = int64(0.76*wid);

here = fileparts(mfilename('fullpath'));
AX = 0:config.axT:config.T;
AXfile = 1:1:config.T/config.axT+1;

%%Plot all trajs.
max_plot = 0;
med_dev = [];
med_dev_75 = [];
med_dev_95 = [];

max_plot = 0;

for j = 1:size(methods,2)
    dev = [];
    algo = methods(j);

    for it = 1:nb_run

        filename = sprintf("dev_%s_%s_%d.csv", algo, prm.name, it);
        file = readmatrix(fullfile(here, '../results/deviations', filename));
        file = file(:,AXfile);

        dev = [dev; file];
        max_plot = max([max_plot, max(dev,[],"all")],[], "all");
    end
end

for j = 1:size(methods,2)
    dev = [];
    algo = methods(j);

    for it = 1:nb_run

        filename = sprintf("dev_%s_%s_%d.csv", algo, prm.name, it);
        file = readmatrix(fullfile(here, '../results/deviations', filename));
        file = file(:,AXfile);

        dev = [dev; file];
        %max_plot = max([max_plot, max(dev,[],"all")],[], "all");
    end

    figure('Visible','off','Position', [10 10 wid hei], 'Renderer','painters')
    for it = 1:nb_run
        plot(AX, dev(it,:))
        yticks(linspace(0, max_plot*1.05, 10))
        hold on
    end
    yticks(0:0.025:max_plot)
    grid on
    %legend('Interpreter','none')
    xlabel("\bf iterations")
    ylabel("\bf prop")
    hold on
    title(name(j),"Interpreter","none")
    saveas(gcf,"~/repos/experiments/results/graphs_gen/trajs_"+prm.name+"_"+algo, 'epsc')

end

for j = 1:size(methods,2)

    algo = methods(j);

    dev = [];
    false_neg = [];
    false_pos = [];

    for it = 1:nb_run

        filename = sprintf("dev_%s_%s_%d.csv", algo, prm.name, it);
        file = readmatrix(fullfile(here, '../results/deviations', filename));
        file = file(:,AXfile);

        dev = [dev; file];

    end
    dev_0 = min(dev,[],1);
    dev_010 = quantile(dev,0.05,1);
    dev_025 = quantile(dev,0.25,1);
    dev_05 = quantile(dev,0.5,1);
    dev_075 = quantile(dev,0.75,1);
    dev_090 = quantile(dev,0.95,1);
    dev_1 = max(dev,[],1);


    figure('Visible','off','Position', [10 10 wid hei], 'Renderer','painters')
    %ylim([0 max(dev_1)])
    %hold on

    %{
    for j = 1:50
        plot(0:T,dev(j,:))
        hold on
    end
    %}
    %patch([AX, fliplr(AX)],[dev_0, fliplr(dev_1)], ...
    %'black','FaceAlpha',0.2, 'EdgeColor','none','DisplayName','min-max');
    %hold on
    patch([AX, fliplr(AX)],[dev_010, fliplr(dev_090)], ...
        'black','FaceAlpha',0.3, 'EdgeColor','none','DisplayName','5%-95%');
    hold on
    patch([AX, fliplr(AX)],[dev_025, fliplr(dev_075)], ...
        'black','FaceAlpha',0.4, 'EdgeColor','none','DisplayName',"25%-75%");
    hold on
    plot(AX,dev_05,'-*', 'LineWidth',1.5,'Color','red','DisplayName',"median")
    hold on
    grid on
    ylim([0 max_plot])
    yticks(0:0.025:max_plot)
    legend('Interpreter','none','FontSize',7)
    xlabel("\bf iterations")
    ylabel("\bf prop")
    hold on
    title(name(j),"Interpreter","none")
    saveas(gcf,"~/repos/experiments/results/graphs_gen/metric_"+prm.name+"_"+algo, 'epsc')



    med_dev = [med_dev; dev_05];
    med_dev_75 = [med_dev_75; dev_075];
    med_dev_95 = [med_dev_95; dev_090];

end

%Compare median
figure('Visible','on','Position', [10 10 wid hei], 'Renderer','painters')
for m = 1:size(methods,2)
    plot(AX,med_dev(m,:),'-*','DisplayName',name(m),'LineWidth',1.5)
    hold on
end

ylim([0 1.1*max(med_dev,[],"all")]);
%yticks(0:0.025:1.1*max(med_dev,[],"all"))
grid on
legend('Interpreter','none', 'Location','southwest','FontSize',7)
hold on
%title("Summary "+prm.name,'Interpreter','none')
xlabel("\bf steps")
ylabel("\bf prop. misclass.")
%saveas(gcf,"~/repos/experiments/results/graphs_gen/metric_"+prm.name, 'epsc')
saveas(gcf,"~/repos/experiments/results/graphs_gen/metric_"+prm.name+"_local", 'epsc')

%Compare 075
figure('Visible','off','Position', [10 10 wid hei], 'Renderer','painters')
for m = 1:size(methods,2)
    plot(AX,med_dev_75(m,:),'-*','DisplayName',name(m),'LineWidth',1.5)
    hold on
end
ylim([0 1.1*max(med_dev_75,[],"all")]);
yticks(0:0.025:1.1*max(med_dev_75,[],"all"))
grid on
legend('Interpreter','none', 'Location','best','FontSize',7)
hold on
%title("Summary "+prm.name,'Interpreter','none')
xlabel("\bf iterations")
ylabel("\bf prop. misclass.")
%saveas(gcf,"~/repos/experiments/results/graphs_gen/metric_75_"+prm.name, 'epsc')
saveas(gcf,"~/repos/experiments/results/graphs_gen/metric_75_"+prm.name+"_local", 'epsc')

%Compare 095
figure('Visible','off','Position', [10 10 wid hei], 'Renderer','painters')
for m = 1:size(methods,2)
    plot(AX,med_dev_95(m,:),'-*','DisplayName',name(m),'LineWidth',1.5)
    hold on
end
ylim([0 1.1*max(med_dev_95,[],"all")]);
yticks(0:0.025:1.1*max(med_dev_95,[],"all"))
grid on
legend('Interpreter','none', 'Location','best','FontSize',7)
hold on
%title("Summary "+prm.name,'Interpreter','none')
xlabel("\bf iterations")
ylabel("\bf prop. misclass.")
%saveas(gcf,"~/repos/experiments/results/graphs_gen/metric_95_"+prm.name, 'epsc')
saveas(gcf,"~/repos/experiments/results/graphs_gen/metric_95_"+prm.name+"_local", 'epsc')

%Compare log-median
figure('Visible','off','Position', [10 10 wid hei])
for m = 1:size(methods,2)
    plot(AX,log(med_dev(m,:)),'-o','DisplayName',methods(m),'LineWidth',1.5)
    hold on
end
%ylim([0 1.1*max(log(med_dev),[],"all")]);
%yticks(0:0.05:1.1*max(log(med_dev),[],"all"))
legend('Interpreter','none','Location','southwest')
hold on
title("Summary "+prm.name+" (log)",'Interpreter','none')
xlabel("iterations")
ylabel("log(prop)")
%saveas(gcf,"~/repos/experiments/results/graphs_gen/log_metric_"+prm.name, 'epsc')
%saveas(gcf,"~/repos/experiments/results/graphs_gen/log_metric_comp_"+prm.name, 'epsc')
