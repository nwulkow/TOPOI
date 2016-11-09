function lnL = MarkovML(Params, Model)

gamma = Params(1);
sigma = Params(2);

data = Model.Data;
dx = diff(data);
DataF = data(2:end);
DataL = data(1:end-1);
Nobs = length(data);
TimeStep = Model.TimeStep;

times = TimeStep:TimeStep:Nobs*TimeStep;
timeF = times(2:end);
timeL = times(1:end-1);

sigma_vec = sigma^2*(timeF - timeL);
mu_vec = log(DataL)'+ gamma*log(timeF./timeL) - (timeF.^(gamma+1)-timeL.^(gamma+1)) - sigma^2/2 * (timeF - timeL);
%probs = 1./(sqrt(2*pi).*sigma_vec) .* exp(-0.5*(DataF' - mu_vec).^2 / (sigma_vec.^2));
probs = 0;
for i = 1:Nobs-1
    probs = probs + normpdf(DataF(i), log(DataL(i))'+ gamma*log(timeF(i)./timeL(i)) - (timeF(i)^(gamma+1)-timeL(i)^(gamma+1)) - sigma^2/2 * (timeF(i) - timeL(i)), sigma^2*(timeF(i) - timeL(i)));
%probs = normpdf(DataF',log(DataL)'+ gamma*log(timeF./timeL) - (timeF.^(gamma+1)-timeL.^(gamma+1)) - sigma^2/2 * (timeF - timeL), diag(sigma^2*(timeF - timeL)));
lnL = sum(probs);
end