% Script para identifica��o do modelo utilizando algoritmos gen�ticos
% utilizando Simulink

%OBS: sim, est� com muitas gambys e spaghetti. Quando funcionar, arrumarei.
%OBS2: load('data.mat') t� gerando estrutura errada. Carregar data
%diretamente dando 2 cliques no data.mat

% Limpar workspace
clc;
clear all;

% Carregar dados
%data = load('data.mat');
servo1 = data(:,1); servo2 = data(:,2); servo3 = data(:,3); servo4 = data(:,4);
saidaX = data(:,5);
saidaY = data(:,6);
saidaZ = data(:,7);

% Definir par�metros do algoritmo
nGeracoes = 10;
nIndividuos = 4; % Deve ser par!!!!
nTorneio = 2;
limErro = 1e-6;
taxaMutacao = 0.01;
probabilidadeCruzamento = 0.7;
Param.StopT = 0.0001; % Tempo de simula��o
tamanhoDenominador = 2; % Quantidade de coeficientes de cada denominador

seedRand = rng; 
save('script_GA_id_simulink', 'seedRand'); % Salvar seed
nExemplos = 10;%length(data);
limInf = -50000; % Limites do rand()
limSup = 50000;

% Inicialar sinais de entrada do Simulink
s1 = [1 1];
s2 = [1 2];
s3 = [1 3];
s4 = [1 4];

% Incializar denominadores das fun��es de transfer�ncia do Simulink
den1 = [1 1];
den2 = [1 1];
den3 = [1 1];
den4 = [1 1];

% Inicializar sinais de sa�da do Simulink
x = [1 1];
y = [1 1];
z = [1 1];

% Inicializar indiv�duos
individuosMatriz = ones(nIndividuos,4,tamanhoDenominador);
for i = 1:nIndividuos % Linhas (indiv�duos)
    for j = 1:4 % Colunas (fun��es de transfer�ncia)
        den = (limSup-limInf).*rand(1, tamanhoDenominador) + limInf; % Gerar coeficientes aleat�rios
        for k = 2:tamanhoDenominador % Profundidade (coeficientes da fun��o de transfer�ncia j)
            individuosMatriz(i,j,k) = den(k);
        end
    end
end

% Abrir simulink
open('simulink_GA_id');

% Realizar AG
aptidao = zeros(nIndividuos,1);
erro = ones(nIndividuos,1);
individuosMatrizSelecao = ones(nIndividuos,4,tamanhoDenominador);
individuosMatrizCruzamento = ones(nIndividuos,4,tamanhoDenominador);

% Avalia��o da aptid�o inicial
for i = 1:nIndividuos
    
    % Modificar os blocos com as fun��es de transfer�ncia do indiv�duo
    set_param('simulink_GA_id/Transfer_Fcn','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
    set_param('simulink_GA_id/Transfer_Fcn1','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
    set_param('simulink_GA_id/Transfer_Fcn2','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
    set_param('simulink_GA_id/Transfer_Fcn3','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
        
    % Resetar as vari�veis de erro
    erroX = 0;
    erroY = 0;
    erroZ = 0;
        
    % Simular cada uma das nExemplos entradas
    for ex = 1:nExemplos
            
        % Modificar os valores de entrada
        s1 = [1 servo1(ex)];
        s2 = [1 servo2(ex)];
        s3 = [1 servo3(ex)];
        s4 = [1 servo4(ex)];
            
        % Simular
        sim('simulink_GA_id',Param.StopT);
            
        % Calcular os erros
        erroX = erroX + (saidaX(ex)-x(50)).^2;
        erroY = erroY + (saidaY(ex)-y(50)).^2;
        erroZ = erroZ + (saidaZ(ex)-z(50)).^2;
            
    end
    
    % Determinar erro acumulado de cada indiv�duo e sua aptid�o
    erro(i) = erroX + erroY + erroZ;
    aptidao(i) = 1/erro(i);
end

while nGeracoes > 0 && min(erro) > limErro

    % Sele��o (torneio de nTorneio indiv�duos)
    for i = 1:nIndividuos
        
        % Escolher aleatoriamente nTorneio indiv�duos pra cada torneio
        indicesTorneio = randi([1 nIndividuos], 1, nTorneio);
        apt = 0;
        indice = 0;
        
        % Realizar torneio
        for j = 1:nTorneio
            
            % Escolher o individuo com maior aptidao (dentre o nTorneio individuos)
            if aptidao(indicesTorneio(j)) > apt
                apt = aptidao(indicesTorneio(j));
                indice = indicesTorneio(j);
            end
        end
        
        % Atualizar a matriz de indiv�duos com o vencedor do torneio
        individuosMatrizSelecao(i,:,:) = individuosMatriz(indice,:,:);
    end
        
    % Cruzamento
    i = nIndividuos;
    while i > 0
        
        indicesCruzamento = randi([1 nIndividuos], 1, 2); % Selecionar individuos para cruzamento
        pontoCruzamento = randi([1,3]); % Selecionar ponto de cruzamento
        randCross = rand(); % Chance de ocorrer cruzamento
        
        % Realizar cruzamento
        if randCross < probabilidadeCruzamento
            
            for j = 1:pontoCruzamento
                individuosMatrizCruzamento(i,j,:) = individuosMatrizSelecao(indicesCruzamento(1),j,:);
                individuosMatrizCruzamento(i-1,j,:) = individuosMatrizSelecao(indicesCruzamento(2),j,:);
            end
            
            for j = pontoCruzamento+1:4
                individuosMatrizCruzamento(i,j,:) = individuosMatrizSelecao(indicesCruzamento(2),j,:);
                individuosMatrizCruzamento(i-1,j,:) = individuosMatrizSelecao(indicesCruzamento(1),j,:);
            end
            
            i = i - 2;
        end
    end
    
    % Muta��o
    for i = 1:nIndividuos
        for j = 1:4
            for k = 1:tamanhoDenominador
                
                randMutacao = rand();               
                if randMutacao < taxaMutacao
                    individuosMatrizCruzamento(i,j,k) = (limSup-limInf).*rand() + limInf;
                end
            end
        end
    end
    
    individuosMatriz = individuosMatrizCruzamento; % Atualizar matriz de indiv�duos com nova popula��o
    
    % Avalia��o da aptid�o da nova popula��o
    for i = 1:nIndividuos
        
        % Modificar os blocos com as fun��es de transfer�ncia do indiv�duo
        set_param('simulink_GA_id/Transfer_Fcn','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
        set_param('simulink_GA_id/Transfer_Fcn1','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
        set_param('simulink_GA_id/Transfer_Fcn2','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
        set_param('simulink_GA_id/Transfer_Fcn3','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
        
        % Resetar as vari�veis de erro
        erroX = 0;
        erroY = 0;
        erroZ = 0;
        
        % Simular cada uma das nExemplos entradas
        for ex = 1:nExemplos
            
            % Modificar os valores de entrada
            s1 = [1 servo1(ex)];
            s2 = [1 servo2(ex)];
            s3 = [1 servo3(ex)];
            s4 = [1 servo4(ex)];
            
            % Simular
            sim('simulink_GA_id',Param.StopT);
                       
            % Calcular os erros
            erroX = erroX + (saidaX(ex)-x(50)).^2;
            erroY = erroY + (saidaY(ex)-y(50)).^2;
            erroZ = erroZ + (saidaZ(ex)-z(50)).^2;
            
        end
        
        % Determinar erro acumulado de cada indiv�duo e sua aptid�o
        erro(i) = sqrt(erroX + erroY + erroZ);
        aptidao(i) = 1/erro(i);
    end
    
    % Passar para pr�xima gera��o
    nGeracoes = nGeracoes - 1; 
end
 
% Exibir matriz dos melhores indiv�duos?