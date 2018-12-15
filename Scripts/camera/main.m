%%
%fclose(s);

%%
% Salvar arquivos da posi��o
adress = '';
nome_arq = strcat(adress, 'dados.txt');
id_arq = fopen(nome_arq, 'wt');


%%
% PASSO B: remover codigo antigo, preferencialmente desconecte as cameras
%   clear all no terminal;

%
% As cameras s�o sens�veis, n�o se desconectam facilmente.
%
%%
% PASSO O: Conectar as c�meras e ver seu estado.
[cam1, cam2] = connectStereoCams;

%
% Recebe os par�metros da C�mera que ser�o utilizados em fun��o que ir�
% retornar a dist�ncia da c�mera para a da cor-objetivo na tela.
%

%%
% PASSO P: Calibrar a c�mera que pode estar em posi��o alterada.
%stereoParams = quickStereoCalibration(cam1, cam2);

%
% Recebe os par�metros da C�mera que ser�o utilizados em fun��o que ir�
% retornar a dist�ncia da c�mera para a da cor-objetivo na tela.
%

%%
% PASSO N: Use getHSVColor(path) para estimar a m�dia do valor de HSV.
%LAB = getLABColor(cam1, 81);

%
% Recebe uma imagem ao qual o usu�rio far� a sele��o manual da cor, por
% meio de cliques no monitor, de modo a detectar cor e faixa de toler�ncia.
% Recebe a �rea em pixels� a ser considerada reduzindo ru�do e imprecis�o
% do clique. No fim, haver� uma matriz com M linhas (quantidade de cores a
% serem detectadas) e N colunas (cada cor detectada em cada clique).
%

%comunica��o inicial
s = serial('COM3', 'BaudRate', 9600);
fopen(s);

%as famigeradas 2000 posi��es
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
    % PASSO M: Use a m�dia de cada cor para detec��o na imagem passada e passe
    % para fun��o colorDetectHSV(imagem, corLab)
    stat1 = detectLABColor(cam1, LAB);
    stat2 = detectLABColor(cam2, LAB);
    %
    % Ao fim, ser� repassada a posi��o relativa de cada cor em uma matriz, onde
    % linha M � cada uma das posi��es da cor, em ordem de �rea, e cada coluna N
    % � uma posi��o no plano cartesiano X, Y, Z, no quarto quadrante, apenas Z
    % positivo.
    %

    %%
    % PASSO K: Verificar consist�ncia e s� depois disso, triangular.

    vetorPos(i, :) = triangular(stat1, stat2, stereoParams);

    debug('b', vetorPos(i, :));       %apenas debug.REMOVER
    debug('w', vetorPos(i, :));       %apenas debug.REMOVER
    
    %
    % Faz algumas checagens para ver se t� tudo ok, para ent�o retornar uma
    % posi��o X, Y e Z v�lida.
    %

    %%
    % PASSO V: Guardar em arquivo que ser� enviado a Ardu�no
    fprintf(id_arq, '%d %f %f %f %d %d %d \n', i, vetorPos(i, 1), vetorPos(i, 2), vetorPos(i, 3), servo2(i), servo3(i), servo4(i));
    [vetorPos(i, 1), vetorPos(i, 2), vetorPos(i, 3)]
end

fclose(id_arq);

