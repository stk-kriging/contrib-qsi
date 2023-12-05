function y = double_camel(x)

x1 = double(x(:,[1,3]));
x2 = double(x(:,[2,4]));

y = (1/2)*(funct.camel_back(x1) + funct.camel_back(x2));

end
