% CIR initial parameters estimation
x = Model.Data(1:end-1); % Time series of interest rates observations
dx = diff(Model.Data);
dx = dx./x.^0.5;
regressors = [Model.TimeStep./x.^0.5, Model.TimeStep*x.^0.5];
drift = regressors\dx; % OLS regressors coefficients estimates
res = regressors*drift - dx;
alpha = -drift(2);
mu = -drift(1)/drift(2);
sigma = sqrt(var(res, 1)/Model.TimeStep);
InitialParams = [alpha mu sigma]; % Vector of initial parameters