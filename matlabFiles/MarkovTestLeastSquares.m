function lnL = MarkovTestLeastSquares(Params, Model)
%Diffusion process: dXt = X0 - int(b(Xt)dt,0,t) + sigma*Bt
% b = @(x) -alpha*x.*(x.^2-1) und sigma sind Parameter

alpha = Params(1);
b = @(x) -alpha*x.*(x.^2-1);
data = Model.Data;
DataF = data(2:end);
DataL = data(1:end-1);
Nobs = length(data);
TimeStep = Model.TimeStep;

sum = 0;
for i = 1:Nobs-1
    sum = sum + (DataF(i) - (DataL(i)+ TimeStep*b(DataL(i)))).^2;
end
lnL = sum;