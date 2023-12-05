function y = branin_mod(x)

y = 3*sin(x(:,1).^1.25) + sin(x(:,2).^1.25);
y = 1/12*stk_testfun_braninhoo(x) + y;

end
