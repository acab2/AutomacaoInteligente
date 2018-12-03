% Script para identificação do modelo utilizando algoritmos genéticos
% utilizando Simulink

%OBS: sim, está com muitas gambys e spaghetti. Quando funcionar, arrumarei.
%OBS2: load('data.mat') tá gerando estrutura errada. Carregar data
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

% Definir parâmetros do algoritmo
nGeracoes = 10;
nIndividuos = 4; % Deve ser par!!!!
nTorneio = 2;
limErro = 1e-6;
taxaMutacao = 0.01;
probabilidadeCruzamento = 0.7;
Param.StopT = 0.0001; % Tempo de simulação
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

% Incializar denominadores das funções de transferência do Simulink
den1 = [1 1];
den2 = [1 1];
den3 = [1 1];
den4 = [1 1];

% Inicializar sinais de saída do Simulink
x = [1 1];
y = [1 1];
z = [1 1];

% Inicializar indivíduos
individuosMatriz = ones(nIndividuos,4,tamanhoDenominador);
for i = 1:nIndividuos % Linhas (indivíduos)
    for j = 1:4 % Colunas (funções de transferência)
        den = (limSup-limInf).*rand(1, tamanhoDenominador) + limInf; % Gerar coeficientes aleatórios
        for k = 2:tamanhoDenominador % Profundidade (coeficientes da função de transferência j)
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

% Avaliação da aptidão inicial
for i = 1:nIndividuos
    
    % Modificar os blocos com as funções de transferência do indivíduo
    set_param('simulink_GA_id/Transfer_Fcn','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
    set_param('simulink_GA_id/Transfer_Fcn1','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
    set_param('simulink_GA_id/Transfer_Fcn2','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
    set_param('simulink_GA_id/Transfer_Fcn3','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
        
    % Resetar as variáveis de erro
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
    
    % Determinar erro acumulado de cada indivíduo e sua aptidão
    erro(i) = erroX + erroY + erroZ;
    aptidao(i) = 1/erro(i);
end

while nGeracoes > 0 && min(erro) > limErro

    % Seleção (torneio de nTorneio indivíduos)
    for i = 1:nIndividuos
        
        % Escolher aleatoriamente nTorneio indivíduos pra cada torneio
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
        
        % Atualizar a matriz de indivíduos com o vencedor do torneio
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
    
    % Mutação
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
    
    individuosMatriz = individuosMatrizCruzamento; % Atualizar matriz de indivíduos com nova população
    
    % Avaliação da aptidão da nova população
    for i = 1:nIndividuos
        
        % Modificar os blocos com as funções de transferência do indivíduo
        set_param('simulink_GA_id/Transfer_Fcn','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
        set_param('simulink_GA_id/Transfer_Fcn1','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
        set_param('simulink_GA_id/Transfer_Fcn2','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
        set_param('simulink_GA_id/Transfer_Fcn3','Denominator',strcat(strcat('[', num2str(individuosMatriz(i,1,:))), ']')   )
        
        % Resetar as variáveis de erro
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
        
        % Determinar erro acumulado de cada indivíduo e sua aptidão
        erro(i) = sqrt(erroX + erroY + erroZ);
        aptidao(i) = 1/erro(i);
    end
    
    % Passar para próxima geração
    nGeracoes = nGeracoes - 1; 
end
 
% Exibir matriz dos melhores indivíduos?