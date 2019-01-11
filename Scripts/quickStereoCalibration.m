function [params] = quickStereoCalibration(cam1, cam2)
%
% function [params] = quickStereoCalibration(cam1, cam2)
%
% Essa função é usada para rapidamente calibrar quando na primeira vez e 
% quando necessário.
% ARGUMENTO: 
% cam1 e cam2 a serem calibradas.
% ALGORITMO:
% Utiliza série de funções de calibração.
% RETORNO:
% params são parâmetros da camera para utilizar triangulação, depois.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hywre Cesar - Novembro 2018
% www.fb.com.br/hycesar
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%locais onde iram ser salvas as imagens
%Esses locais DEVEM existir, antes de executar o código.
path1 = strcat(pwd, '\cameraStereo1');
path2 = strcat(pwd, '\cameraStereo2');
%%
%laço
n = 0;
while n < 60            %~30 é qnt recomendada de imagens para calibração
    img1 = snapshot(cam1);
    img2 = snapshot(cam2);

    imshowpair(img1, img2, 'montage');
    
    %colocar nas pastas 
    filename1 = [strcat(path1, '\'), int2str(n), '.png'];
    filename2 = [strcat(path2, '\'), int2str(n), '.png'];
    
    %Guardar as fotos
    imwrite(img1, fullfile(filename1));
    imwrite(img2, fullfile(filename2));
    
    %Espera o usuário se posicionar para a próxima foto
    %Tempo baixo causa borrado nas fotos
    pause(3);

    %Controla laço e nome do arquivo
    n = n + 1;
end
%%
%pasta com imagens
leftImages = imageDatastore(path1);
rightImages = imageDatastore(path2);    

%detectar tabuleiro
[imagePoints,boardSize] = detectCheckerboardPoints(leftImages.Files, rightImages.Files);

%Especifica tamanho da célula em mm
squareSize = 15;                    %importante: depende do tabuleiro (mm)
worldPoints = generateCheckerboardPoints(boardSize,squareSize);

%Pegar o tamanho das imagens e calibrar
I = readimage(leftImages,1); 
imageSize = [size(I,1),size(I,2)];
params = estimateCameraParameters(imagePoints, worldPoints, 'ImageSize',imageSize);
%%
%Mostrar precisão da calibração
showReprojectionErrors(params);

%mostrar distribuição da câmera no espaço
figure;
showExtrinsics(params);
%}
end