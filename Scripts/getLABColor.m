
function labMean = getLABColor(cam, pixelArea)

%
% function labMean = getLABColor(imagem, pixelArea)
%
% Essa função é usada para treinamento no modelo de detecção de cor.
% ARGUMENTO: 
% variável cam e pixelArea, ao redor do pixel, a ser considerada.
% ALGORITMO:
% Trabalhando no domínio HUE, extrai cor. Mais cliques, mais precisão.
% RETORNO:
% labMean: Vetor 3x3: 1ª linha: HSV médio, 2ª, desvio padrão, 3ª, X,Y, Área
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hywre Cesar - Novembro 2018
% www.fb.com.br/hycesar
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
imagem = snapshot(cam);         %pegar a imagem
raizArea = sqrt(pixelArea);     %lado do quadrado.
labMean = [];                   %criar variável de retorno.
clf;                            %criar tela que receberá imagem.
warning off;                    %desligar avisos.
imshow(imagem);                 %mostrar imagem em tela.
hold on;                        %manter plots sobrepostos
vLab = rgb2lab(imagem);         %converter para domínio HSV
vLab2 = zeros(1,3);
selectedPixels = 0;             %numero de Pixels selecionados
posicao = zeros(1:2);           %guarda posições de cada ponto
%%
%loop capturará pixels clicados e adjacências 5x5 para reduzir ruído.
while true
    [X,Y,BUTTON] = ginput(1);   %recebe posição XY e posição botão do mouse
    if BUTTON == 3              %avaliar saída do loop
        imagem = snapshot(cam);     %pegar uma nova imagem
        imshow(imagem);             %mostrar imagem em tela.
        vLab = rgb2lab(imagem);     %converter para domínio HSV
        [X,Y,BUTTON] = ginput(1);   %recebe posição XY 
        if BUTTON == 3              %avaliar saída do loop
            break;                  %forçar interrupção do loop
        end
    end
    selectedPixels = selectedPixels + 1; %atualiza quantidade
    posicao(selectedPixels, :) = [X, Y]; %guarda casa posicao capturada
    
    %recebe hsv localizado
    recorte = vLab(Y-(raizArea-1)/2:Y+(raizArea-1)/2,X-(raizArea-1)/2:X+(raizArea-1)/2,:);
    
    %Matriz com zeros
    temp = zeros(3,1);
    for i = 1 : raizArea        %percorrer a imagem na linha
        for j = 1 : raizArea    %percorrer a imagem na coluna
            temp(1) = temp(1) + recorte(i,j,1); %somar cada canal
            temp(2) = temp(2) + recorte(i,j,2);
            temp(3) = temp(3) + recorte(i,j,3);
        end
    end
    temp = temp / pixelArea; %tirar a média de cada canal pela área
    vLab2(selectedPixels,:) = temp;%cria primeira linha da matriz com a media de cada canal
    
    %adicionar um quadrado representando área processada da figura
    line([X-(raizArea-1)/2 X+(raizArea-1)/2] , [Y-(raizArea-1)/2 Y-(raizArea-1)/2]);
    line([X+(raizArea-1)/2 X+(raizArea-1)/2] , [Y-(raizArea-1)/2 Y+(raizArea-1)/2]);
    line([X+(raizArea-1)/2 X-(raizArea-1)/2] , [Y+(raizArea-1)/2 Y+(raizArea-1)/2]);
    line([X-(raizArea-1)/2 X-(raizArea-1)/2] , [Y+(raizArea-1)/2 Y-(raizArea-1)/2]);
end
%%
labMean(1,:) = median(vLab2, 1);%media de cada canal, achatando em 1 linha
labMean(2,:) = std(vLab2, 0, 1);     %desvio padrao de cada canal
if selectedPixels < 3
    labMean(3,1) = mean(posicao(:,1)); %média da posição X
    labMean(3,2) = mean(posicao(:,2)); %média da posição Y
    labMean(3,3) = pixelArea*selectedPixels; %area de dois pontos é nula, logo usar area dos pixels
else
    polig = polyshape(posicao); %cria um polígono com os pontos clicados
    plot(polig);                %mostrar poligono em tela

    %centroide do polígono formado pelos pontos
    [x,y] = centroid(polig);    %posicao Centróide
    labMean(3,1) = x;           %posição X
    labMean(3,2) = y;           %posição Y
    labMean(3,3) = area(polig); %área formadas por esse polígono
end
%%
plot(labMean(3,1),labMean(3,2),'r*');%plotar centro do polígono
pause(1);                   %dois segundo para verificar posicao
%}
%%
hold off;                   %permite sobreposição do plot
warning on;                 %ativa warnings
%close all;                 %fechar janela: Abrir/Fechar -> (perform--)
end