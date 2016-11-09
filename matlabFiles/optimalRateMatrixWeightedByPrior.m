% Daten
X(1,:) = [1,2,10];
X(2,:) = [2,5,15];
X(3,:) = [3,10,19];
X(4,:) = [7,22,28];

% Prior ueber den ersten Bestand X(1,:)
prior_bestand = @(x) (x == [1,2,10]) .* mvepdf(x, [1,2,10]);
bestand_range = vectorsToMatrix({1:0.5:2, 2:0.5:3, 10:1:12});
M_final = zeros(3);
for k = 1:length(bestand_range)
    %W'keit dafuer, dass am ersten Zeitpunkt tatsaechlich so ein Bestand vorlag
    X(1,:) = bestand_range(k,:);
    prob(k) = prod(prior_bestand(bestand_range(k,:)));
    % Optimale Ratenmatrix ermitteln
    M_opt{k} = fminsearch(@(M)reconstructTransitionProcess(M,X), ones(3));
    % Gewichtung des Resultats mit W'keit des Bestandes
    M_final = M_final + M_opt{k}*prob(k);
end
M_final = M_final / sum(prob)