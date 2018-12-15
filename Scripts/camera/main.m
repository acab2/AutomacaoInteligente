%%
%fclose(s);

%%
% Salvar arquivos da posição
adress = '';
nome_arq = strcat(adress, 'dados.txt');
id_arq = fopen(nome_arq, 'wt');


%%
% PASSO B: remover codigo antigo, preferencialmente desconecte as cameras
%   clear all no terminal;

%
% As cameras são sensíveis, não se desconectam facilmente.
%
%%
% PASSO O: Conectar as câmeras e ver seu estado.
[cam1, cam2] = connectStereoCams;

%
% Recebe os parâmetros da Câmera que serão utilizados em função que irá
% retornar a distância da câmera para a da cor-objetivo na tela.
%

%%
% PASSO P: Calibrar a câmera que pode estar em posição alterada.
%stereoParams = quickStereoCalibration(cam1, cam2);

%
% Recebe os parâmetros da Câmera que serão utilizados em função que irá
% retornar a distância da câmera para a da cor-objetivo na tela.
%

%%
% PASSO N: Use getHSVColor(path) para estimar a média do valor de HSV.
%LAB = getLABColor(cam1, 81);

%
% Recebe uma imagem ao qual o usuário fará a seleção manual da cor, por
% meio de cliques no monitor, de modo a detectar cor e faixa de tolerância.
% Recebe a área em pixels² a ser considerada reduzindo ruído e imprecisão
% do clique. No fim, haverá uma matriz com M linhas (quantidade de cores a
% serem detectadas) e N colunas (cada cor detectada em cada clique).
%

%comunicação inicial
s = serial('COM3', 'BaudRate', 9600);
fopen(s);

%as famigeradas 2000 posições
%%
%%servo2 = randi([195, 820],[2000,1]);
%%servo3 = randi([512, 930],[2000,1]);
%%servo4 = randi([512, 885],[2000,1]);
%servo2 = randi([135, 870],[2000,1]);
%servo3 = randi([512, 830],[2000,1]);
%servo4 = randi([180, 850],[2000,1]); 
servo2 = randi([135, 870],[2000,1]);
servo3 = randi([512, 925],[2000,1]);
servo4 = randi([180, 880],[2000,1]); 

servo5 = 50;
movimentos = 1500;
vetorPos = zeros(movimentos, 3);

for i = 1: movimentos
    [i, servo4(i), servo3(i),  servo2(i)]
    if servo3(i) > 850 && servo4(i) < 512
        servo4(i) = 512;
        positionSet(s, servo4(i));
        positionSet(s, servo3(i));
    else
         positionSet(s, servo4(i));
         positionSet(s, servo3(i));
    end
    positionSet(s, servo2(i));
    positionSet(s, servo5);
    pause(9);
    %%
    % PASSO M: Use a média de cada cor para detecção na imagem passada e passe
    % para função colorDetectHSV(imagem, corLab)
    stat1 = detectLABColor(cam1, LAB);
    stat2 = detectLABColor(cam2, LAB);
    %
    % Ao fim, será repassada a posição relativa de cada cor em uma matriz, onde
    % linha M é cada uma das posições da cor, em ordem de área, e cada coluna N
    % é uma posição no plano cartesiano X, Y, Z, no quarto quadrante, apenas Z
    % positivo.
    %

    %%
    % PASSO K: Verificar consistência e só depois disso, triangular.

    vetorPos(i, :) = triangular(stat1, stat2, stereoParams);

    debug('b', vetorPos(i, :));       %apenas debug.REMOVER
    debug('w', vetorPos(i, :));       %apenas debug.REMOVER
    
    %
    % Faz algumas checagens para ver se tá tudo ok, para então retornar uma
    % posição X, Y e Z válida.
    %

    %%
    % PASSO V: Guardar em arquivo que será enviado a Arduíno
    fprintf(id_arq, '%d %f %f %f %d %d %d \n', i, vetorPos(i, 1), vetorPos(i, 2), vetorPos(i, 3), servo2(i), servo3(i), servo4(i));
    [vetorPos(i, 1), vetorPos(i, 2), vetorPos(i, 3)]
end

fclose(id_arq);

