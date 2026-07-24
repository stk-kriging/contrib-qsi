% Visualize the "brann_mod" test case

close all;  figure1_timer = tic ();

here = fileparts (mfilename ('fullpath'));

[prm, f, s_trnsf] = branin_mod_struct();

pts_x = 500;
pts_s = 500;

xf = stk_sampling_regulargrid(pts_x, 1, prm.BOXx);
x = double(xf);
x = x(:);

fig = figure ();
set(fig, 'paperpositionmode', 'auto');
set(fig, 'position', [100, 100, 1200, 420]);

% Left panel: density of the uncertain input.
subplot (4, 7, [1 8 15]);
hold on;
a = (0:0.01:15)';
[~, pdf_s] = branin_mod_s_trnsf (a);
pdf_s = pdf_s(:);
patch ([zeros(size(pdf_s)); flipud(pdf_s)], [a; flipud(a)], ...
    [0.7 0.85 0.95], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
plot(pdf_s, a, 'black', 'LineWidth', 1);
xlabel ('density');
xlim ([0, 1.05 * max(pdf_s)]);
ylim ([0, 15]);
xticks ([0 0.1 0.2]);
yticks (0:2:14);
hold off;

% Right panel: indicator of Gamma(f), probability curve and alpha.
sf = stk_sampling_sobol(pts_s, prm.dim_s, prm.BOXs);
sf = s_trnsf(sf);
sf = sort(sf);
df = double(adapt_set(xf, sf));
zf = f(df);

subplot(4, 7, [5 6 7 12 13 14 19 20 21]);
[qsi_set, proba] = get_true_quantile_set ...
    (zf, pts_x, pts_s, prm.alpha, prm.const);

stairs(x, double(qsi_set(:)), ...
    'LineWidth', 4, 'color', 'green', 'DisplayName', '  indicator');
hold on;
plot(x, double(proba(:)), ...
    'LineWidth', 4, 'color', 'black', 'DisplayName', '  proba');
plot(x, prm.alpha * ones(size(x)), ...
    'LineWidth', 3, 'color', 'blue', 'DisplayName', '  alpha');
xlabel('X');
legend('Location', 'northwest');
hold off;

% Middle panel: function, boundary of f^{-1}(C), and Gamma(f).
ax_middle = subplot(4, 7, [2 3 4 9 10 11 16 17 18]);
sf_regular = stk_sampling_regulargrid(pts_s, prm.dim_s, prm.BOXs);
s_regular = double(sf_regular);
s_regular = s_regular(:);
df_regular = adapt_set(xf, sf_regular);
zf_regular = f(df_regular);
z_grid = reshape(zf_regular, pts_x, pts_s)';
c_grid = double(reshape((zf_regular <= prm.const(2, 1)), pts_x, pts_s)');

hold on;
contour(x, s_regular, c_grid, [1 1], ...
    'black', 'LineWidth', 2, 'DisplayName', '  boundaryboundaryboundary');
xlabel('X');
ylabel('S');

p = pcolor(x, s_regular, z_grid);
set(p, 'EdgeColor', 'none');
contour(x, s_regular, c_grid, [1 1], ...
    'black', 'LineWidth', 4);

h_colorbar = colorbar('eastoutside');
ax_pos = get(ax_middle, 'position');
cb_pos = get(h_colorbar, 'position');
cb_pos(1) = ax_pos(1) + ax_pos(3) + 0.005;
cb_pos(3) = min(cb_pos(3), 0.015);
set(h_colorbar, 'position', cb_pos);
axes(ax_middle);

sf = stk_sampling_sobol(pts_s, prm.dim_s, prm.BOXs);
sf = s_trnsf(sf);
sf = sort(sf);
df = double(adapt_set(xf, sf));
[qsi_set, ~] = get_true_quantile_set ...
    (f(df), pts_x, pts_s, prm.alpha, prm.const);
abs_quantile = nan(size(x));
abs_quantile(qsi_set(:) == 1) = 0;
plot(x, abs_quantile, ...
    'Color', 'green', 'LineWidth', 4, 'DisplayName', '  Gamma');
h_boundary = plot(nan, nan, 'black', 'LineWidth', 4);
h_gamma = plot(nan, nan, 'green', 'LineWidth', 4);
legend([h_boundary, h_gamma], ...
    {'  boundaryboundaryboundary', '  Gamma'}, 'Location', 'southwest');
hold off;

fprintf ('Generation of Figure 1: Done in %.2f s\n', toc (figure1_timer));

print (fig, '-dpng', '-r180', fullfile (here, 'branin_mod.png'));
print (fig, '-depsc2', fullfile (here, 'branin_mod.eps'));
