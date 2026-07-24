% Visualize the "branin_mod" test case

[prm, f, s_trnsf] = branin_mod_struct ();

PTS_X = 500;
PTS_S = 500;

fig = figure ();
set (fig, 'position', [100, 100, 1200, 420]);

label_opts = {'FontSize', 12};
Gamma_opts = {'LineWidth', 4, 'color', 'green'};


%% Left panel: density of the uncertain input

h1 = subplot (4, 7, [1 8 15]);

aa = (0:0.01:15)';
[~, pdf_s] = branin_mod_s_trnsf (aa);

patch ([zeros(size(pdf_s)); flipud(pdf_s)], [aa; flipud(aa)], ...
    [0.7 0.85 0.95], 'EdgeColor', 'none', 'FaceAlpha', 0.5);

hold on;  plot (pdf_s, aa, 'black', 'LineWidth', 1);

xlabel ('density', label_opts{:});
ylabel ('s', label_opts{:});
xlim ([0, 1.05 * max(pdf_s)]);
ylim ([0, 15]);
xticks ([0 0.1 0.2]);
yticks (0:2:14);
hold off;


%% Right panel: indicator of Gamma(f), probability curve and alpha

h3 = subplot (4, 7, [5 6 7 12 13 14 19 20 21]);

xf = double (stk_sampling_regulargrid (PTS_X, 1, prm.BOXx));
sf = stk_sampling_sobol (PTS_S, prm.dim_s, prm.BOXs);
sf = s_trnsf (sf);
sf = sort (sf);
df = double (adapt_set (xf, sf));
zf = f (df);

[qsi_set, proba] = get_true_quantile_set ...
    (zf, PTS_X, PTS_S, prm.alpha, prm.const);

stairs (xf, double (qsi_set(:)), Gamma_opts{:});
hold on
plot (xf, double (proba(:)), 'LineWidth', 4, 'color', 'black');
plot (xf, prm.alpha * ones (size (xf)), 'LineWidth', 3, 'color', 'blue');

xlabel ('x', label_opts{:});
legend (' 1(Gamma)', ' probability', ' alpha', 'Location', 'northwest');
hold off


%% Middle panel: function, boundary of f^{-1}(C), and Gamma(f)

h2 = subplot (4, 7, [2 3 4 9 10 11 16 17 18]);

sf = double (stk_sampling_regulargrid (PTS_S, prm.dim_s, prm.BOXs));
df = adapt_set (xf, sf);
zf = f (df);

z_grid = reshape (zf, PTS_X, PTS_S)';
c_grid = reshape (double (zf <= prm.const(2, 1)), PTS_X, PTS_S)';

p = pcolor (xf, sf, z_grid);
set (p, 'EdgeColor', 'none');
hold on

contour (xf, sf, c_grid, [1 1], 'black', 'LineWidth', 4);
h_boundary = plot (nan, nan, 'Color', 'black', 'LineWidth', 4); % trick (looks better in Octave?)
 
h_cb = colorbar ('eastoutside');
if exist ('OCTAVE_VERSION', 'builtin') == 5
    ax_pos = get (h2, 'position');
    cb_pos = get (h_cb, 'position');
    cb_pos(1) = ax_pos(1) + ax_pos(3) + 0.005;
    set (h_cb, 'position', cb_pos);
end

sf = double (stk_sampling_sobol (PTS_S, prm.dim_s, prm.BOXs));
sf = s_trnsf (sf);
sf = sort (sf);
df = double (adapt_set (xf, sf));
qsi_set = get_true_quantile_set (f(df), PTS_X, PTS_S, prm.alpha, prm.const);

abs_quantile = nan (size (xf));
abs_quantile(qsi_set(:) == 1) = 0;
h_gamma = plot (xf, abs_quantile, Gamma_opts{:});

legend ([h_boundary, h_gamma], ...
    {' boundary', ' Gamma'}, 'Location', 'southwest');

xlabel ('x', label_opts{:});  hold off


%% Save figure

here = fileparts (mfilename ('fullpath'));

% Printed/saved figure size should match the displayed figure size
set (fig, 'paperpositionmode', 'auto');

print (fig, '-dpng', '-r180', fullfile (here, 'branin_mod.png'));
print (fig, '-depsc2', fullfile (here, 'branin_mod.eps'));
