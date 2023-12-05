function [prm, f, s_trnsf] = hart4_struct()

f = @hart4;
s_trnsf = @hart4_s_trnsf;

prm = struct();

prm.M = 1;

prm.dim_x = 2;
prm.dim_s = 2;
input_domain = [[0;1], [0;1], [0;1], [0;1]];
prm.BOX = stk_hrect(input_domain);
prm.BOXx = stk_hrect([[0;1],[0;1]]);
prm.BOXs = stk_hrect([[0;1],[0;1]]);

prm.const = [-inf ; 1.1];
prm.alpha = 0.6;

prm.name = "hart4";
prm.name_sub = ["hart4"];

prm.list_cov = ["stk_expcov_aniso"; "stk_materncov32_aniso"; "stk_materncov52_aniso"; "stk_gausscov_aniso"];

end
