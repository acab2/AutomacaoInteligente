function vetorPos = triangular(stat1, stat2, stereoParams)

%
% function stat = minhaTriangulacao(stat1, stat2)
%
% Essa funcao recebe dois stats e tenta determinar a posição.
% ARGUMENTO: 
% duas estruturas stat com a posicao, area, centroid,... de cada blob 
% detectado em cada camera.
% ALGORITMO:
% Verifica a validade dos dois stats e, se forem coerentes, triangula.
% RETORNO:
% vetorPos: Vetor 3x1: Posição X, Y, Z.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hywre Cesar - Novembro 2018
% www.fb.com.br/hycesar
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
vetorPos = zeros(1,3);
% As duas câmeras detectaram o ponto?
if ~isempty(stat1) && ~isempty(stat2) && ~isempty(stereoParams)
    tol = max(stat1.EquivDiameter, stat2.EquivDiameter);
    % É uma distância válida?
    if stat1.Centroid - stat2.Centroid < tol
        %triangulação: descobrir a distancia com a calibração anterior.
            vetorPos = triangulate(stat1.Centroid, stat2.Centroid, stereoParams);
    else
        warning("Não foi possivel triangular com segurança: " + ...
        "Possivelmente não são o mesmo ponto! Verifique seus parâmetros");
    end
else
    warning("Uma das câmeras não retornou um ponto válido, neste momento!");
end
end