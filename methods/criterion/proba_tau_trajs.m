function proba = proba_tau_trajs(bool, alpha)

[config_nVar, prm_M] = size (bool);
config_keep_x = size (bool{1,1}, 1);

proba = zeros (config_keep_x, config_nVar);

for k = 1:config_nVar

    % Product of indicator functions (intersection)
    b = bool{k, 1};
    for m = 2:prm_M
        b = b & bool{k,m};
    end

    % Test for each x if the probability is less than alpha
    b = (mean (b, 2) <= alpha);

    % Average with respect to the trajectories
    proba(:, k) = mean (b, 3);

end

end
