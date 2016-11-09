function lnL = MarkovTestML(Params, Model, prior)
%Diffusion process: dXt = X0 - int(b(Xt)dt,0,t) + sigma*Bt
% b = @(x) -alpha*x.*(x.^2-1) und sigma sind Parameter

alpha = Params(1);
sigma = Params(2);
b = @(x) -alpha*x.*(x.^2-1);
data = Model.Data;
DataF = data(2:end);
DataL = data(1:end-1);
Nobs = length(data);
TimeStep = Model.TimeStep;

probs = 1;
for i = 1:Nobs-1
    probs = probs * ( prod(prior(Params)) * normpdf(DataF(i), (DataL(i)+ TimeStep*b(DataL(i))), sqrt(TimeStep)*sigma*rand(1,1)) );
end
lnL = -probs;
