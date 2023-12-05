% syntax 1: [z,w] = quantization( m, s, Q )
% syntax 2: [z,w] = quantization( m, s, opts )
%
% inputs
% ======
%
% m = mean
% s = standard deviation
%
% syntax 1:
%
%     Q = number of quantization levels
%
% syntax 2:
%
%     opts.useGaussHermite = 0 --> constant weights (same as syntax 1)
%     opts.useGaussHermite = 1 --> Gauss-Hermite quadrature
%     opts.nbLevels            --> number of quantization levels
%
%
% output
% ======
%
% z = vector of evaluation points
% w = vector of weights
%
% Both z and w are of size 1 x opts.nbLevels
%

function [z,w] = quantization( m, s, tmp )

if isnumeric(tmp), % syntax 1
    Q = tmp;
    useGH = 0;
elseif isstruct(tmp) % syntax 2
    Q = tmp.nbLevels;
    useGH = tmp.useGaussHermite;
else
    error('Incorrect type for argument #3');
end

switch useGH,
    case 0,
        [z,w] = get_EquiProb_quantization( m, s, Q );
    case 1,
        [z,w] = get_GaussHermite_quantization( m, s, Q );
    otherwise,
        error('Incorrect value for opts.useGaussHermite');
end

end


%% get_EquiProb_quantization

function [zOut,wOut] = get_EquiProb_quantization( m, s, Q )

persistent w z Qprev

if isempty(Qprev) || (Qprev~=Q)
    w = 1/Q * ones(1,Q);
    z = norminv( (2*(1:Q)-1)/(2*Q)  );
    Qprev = Q;
end

zOut = m + s*z;
wOut = w;

end


%% get_GaussHermite_quantization

function [zOut,wOut] = get_GaussHermite_quantization( m, s, Q )

persistent w z Qprev

if isempty(Qprev) || (Qprev~=Q)
    x = hermipol(Q);
    %Roots
    z = roots(x(Q+1,:));

    %Coeficients
    for i=1:Q
        w(i)=(2.^(Q-1)*(factorial(Q)).*sqrt(pi))./(Q.^2.*(polyval(x(Q,1:Q),z(i))).^2);
    end

    Qprev = Q;
end

zOut = m + s*z*sqrt(2);
wOut = w./sqrt(pi);

end
