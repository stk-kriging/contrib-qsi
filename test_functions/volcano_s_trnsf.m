function s_transfo = volcano_s_trnsf(s)

alpha = 2;
beta = 2;

s_transfo = betainv(double(s), alpha, beta);

end
