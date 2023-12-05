function proba = proba_tau_trajs(bool, alpha)

bool = prod(bool, 2);
bool = (mean(bool,4) <= alpha);
proba = mean(bool, 5);

end
