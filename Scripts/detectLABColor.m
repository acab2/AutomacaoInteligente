function stat = detectLABColor(cam, objLAB)

%
% function hsvAll = detectLABColor(imagem)
%
% Essa função é usada para procurar, quando modelo já treinado.
% ARGUMENTO: 
% variável cam e objLAB, parâmetros da cor, desvioP e posição/Area.
% ALGORITMO:
% Trabalhando no domínio HUE, extrai cor. Mais cliques, mais precisão.
% RETORNO:
% hsvAll: Vetor 3x3: 1ª linha: LAB médio, 2ª, desvio padrão, 3ª, posição.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hywre Cesar - Novembro 2018
% www.fb.com.br/hycesar
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
imagem = snapshot(cam);     %pegar a imagem

vLAB = rgb2lab(imagem);     %Converter rgb para Lab

%Encontrar diferença entre Hue da imagem a ser detectada e ao ser procurado
difA = abs(vLAB(:,:,2) - objLAB(1,2));
difB = abs(vLAB(:,:,3) - objLAB(1,3));

[M,N,~] = size(imagem);     %Altura, Largura e Profunidade da Imagem

%declarar a variável antes melhora performance.
A = zeros(M,N);
B = zeros(M,N);

%guarda em variável a tolerância de cor
TolA = objLAB(2,2);         %um desvio captura 67% das ocorrências
TolB = objLAB(2,3);         
if(TolA < 10 || TolB < 10)%tolerancia baixa atrapalha
    TolA = 20;             %esse valor fixo foi testado.
    TolB = 20;
elseif(TolA > 30 || TolB > 30)
    TolA = 20;             %esse valor fixo foi testado.
    TolB = 20;
end

%evidenciar posição onde candidata a cor está dentro da tolerância.
A(difA < TolA) = 1;
B(difB < TolB) = 1;

%remover pequenos objetos brancos, abaixo do limite na deteção
%pixelAreaLimit = round(abs(objLAB(3,3)));
pixelAreaLimit = 20;
%melhor remover
%{
if pixelAreaLimit < 100
    pixelAreaLimit = 100;
end
%}
A = bwareaopen(A, pixelAreaLimit);
B = bwareaopen(B, pixelAreaLimit);

%remover buracos pretos em qualquer área circundada por branco
if abs(objLAB(1,2)) > 5 || abs(objLAB(1,3)) > 5
    imgMerged = imfill(A & B, 8, 'holes'); %ideal para cores.
else
    imgMerged = imfill(A & B, 8);%ideal para preto.
end

%reduziu ruído juntando porções coerentes das imagens: erosão e dilatação
structShape = strel('disk', 10);      %5 pixels de erosão/dilatação
img = imclose(imgMerged, structShape); %

%Mais filtro, talvez desnecessário
%imgF = imfill(img, 'holes');
%%
% plotar: Comentar no fim
%imshow(img); title('Resultado');
%}
%%
% procurar objetos: noholes -> simples holes ->mapeia os objetos internos
% 3º Parametro: qntRegioes, 4º, dependencia
[posFronteira, imgEtiquetas, ~, ~] = bwboundaries(img,'noholes');

%estatística das posições
stat = regionprops(imgEtiquetas, 'Area', 'BoundingBox', 'Centroid', ...
    'EquivDiameter','Perimeter', 'FilledArea');
%%
% mostrar a matriz de etiquetas em cada limite: Comentar no fim!
%imshow(label2rgb(imgEtiquetas, @jet, [.5 .5 .5])) %jet:colormap, []:backgnd
imshow(imagem);
hold on
for k = 1:length(posFronteira)%qntRegioes
  boundary = posFronteira{k};
  plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)%realçar bordas
end
%}

%limite para se considerar um "círculo" e retornar 1º encontrado.
limiteCircunferencia = 0.10;
% loop sobre cada fronteira para construir imagem, Comentar no fim.
for k = 1:length(posFronteira)%qntRegioes
    %pega a posicão do blob
    boundary = posFronteira{k};
    % computar o grau de circunferência do objeto
    metric = 4*pi*stat(k).Area/stat(k).Perimeter^2;
    %%
    % mostrar resultados, Comentar no fim.
    metric_string = sprintf('%2.2f',metric);
    % marcar os objetos que satisfazem o mínimo de Circunferência.
    if metric > limiteCircunferencia && metric < 15 * limiteCircunferencia
        centroid = stat(k).Centroid;
        plot(centroid(1), centroid(2), 'r*', 'MarkerSize', 8, 'LineWidth', 1);
        %%
        %Formatação
        text(boundary(1,2) - 30 , boundary(1,1) + 30 , ...
            strcat('X:', num2str(round(centroid(1))),...
            'Y:', num2str(round(centroid(2)))),...
            'Color','r', 'FontSize',8,'FontWeight','bold');
        %parar procura pelo primeiro circulo achado.
            break;
    else
        %Formatação
        text(boundary(1,2) - 30 , boundary(1,1) + 30 ,...
            metric_string, 'Color','b', 'FontSize',8);
    end
    %}
end
%%    
%{
%outra forma de procurar, mais eficiente que bwlabel, noholes: dá mesmo
%resultado, holes: não.
[componentConectado] = bwconncomp(img);

%determinar o maior objeto
numPixels = cellfun(@numel, componentConectado.PixelIdxList);
[maiorObjeto, idX] = max(numPixels);

%transformá-lo?
%BW(CC.PixelIdxList{idX}) = 0;
%}
%%
%retorna apenas k de interesse
stat = stat(k);
hold off;                   %permite sobreposição do plot
warning on;                 %ativa warnings
end