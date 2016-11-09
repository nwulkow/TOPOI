function X = EMstep(X0, deltaT, b,sigma)

    X = X0 + deltaT*b(X0) + sqrt(deltaT)*sigma(X0)*randn(1,1);
    
    end
