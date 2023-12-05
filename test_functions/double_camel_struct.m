function [prm, f, s_trnsf] = double_camel_struct()

f = @double_camel;

s_trnsf = @double_camel_s_trnsf;

prm = struct();

prm.M = 1;

prm.dim_x = 2;
prm.dim_s = 2;
input_domain = [[-2;2], [-2;2], [-1;1], [-1;1]];
prm.BOX = stk_hrect(input_domain);
prm.BOXx = stk_hrect([[-2;2],[-2;2]]);
prm.BOXs = stk_hrect([[-1;1],[-1;1]]);

prm.const = [-inf; 1.2];
prm.alpha = 0.15;

prm.name = "double_camel";
prm.name_sub = ["double_camel"];

prm.list_cov = ["stk_expcov_aniso"; "stk_materncov32_aniso"; "stk_materncov52_aniso"; "stk_gausscov_aniso"];
prm.eps = 1/200;

end
