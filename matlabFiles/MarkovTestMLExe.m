Params = [2,1];
alpha = Params(1);
sigma = Params(1);
b = @(x) -alpha*x.*(x.^2-1); 
TimeStep = 0.0001;
X0 = 1;
numIter = 1;

Model.Data = modelMarkovProcessByEuler(X0,TimeStep,b,@(x)sigma,numIter);
Model.TimeStep = TimeStep;

prior = @(param) [normpdf(param(1),2,0.5), normpdf(param(2),1,0.5)];
MarkovTestML([Params],Model,prior)
Params_ML = fminsearch(@(Params) MarkovTestML(Params,Model,prior), Params)
MarkovTestML(Params_ML,Model,prior)