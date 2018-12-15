% Script para identificação do modelo utilizando algoritmos genéticos
% utilizando Simulink

%OBS: sim, está com muitas gambys e spaghetti. Quando funcionar, arrumarei.
%OBS2: load('data.mat') tá gerando estrutura errada. Carregar data
%diretamente dando 2 cliques no data.mat

% Limpar workspace
clc;
clear all;

% Carregar dados
load('trainSet.txt');
data = trainSet;
nExemplos = length(data);
servo2 = data(1:nExemplos,4); servo3 = data(1:nExemplos,5); servo4 = data(1:nExemplos,6);
saidaX = data(1:nExemplos,1);
saidaY = data(1:nExemplos,2);
saidaZ = data(1:nExemplos,3);

tStop = nExemplos/10; % Tempo de simulação
entrada = [servo2 servo3 servo4];
saida = [saidaX saidaY saidaZ];
tsaida = 0:0.1:tStop-0.1; 

% Definir parâmetros do algoritmo
nGeracoes = 100;
nIndividuos = 20; % Deve ser par!!!!
nTorneio = 2;
limErro = 1e-6;
taxaMutacao = 0.01;
probabilidadeCruzamento = 0.7;
%Param.StopT = 0.0001; % Tempo de simulação
tamanhoDenominador = 2; % Quantidade de coeficientes de cada denominador

seedRand = rng; 
save('script_GA_id_simulink', 'seedRand'); % Salvar seed
limInf = -1000; % Limites do rand()
limSup = 1000;

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

% Inicializar indivíduos
individuosMatriz = ones(nIndividuos,4,tamanhoDenominador);
for i = 1:nIndividuos % Linhas (indivíduos)
    for j = 1:3 % Colunas (funções de transferência)
        den = (limSup-limInf).*rand(1, tamanhoDenominador) + limInf; % Gerar coeficientes aleatórios
        for k = 2:tamanhoDenominador % Profundidade (coeficientes da função de transferência j)
            individuosMatriz(i,j,k) = den(k);
        end
    end
end

% Realizar AG
ind = individuosMatriz;
aptidao = zeros(nIndividuos,1);
erro = ones(nIndividuos,1);
individuosMatrizSelecao = ones(nIndividuos,4,tamanhoDenominador);
individuosMatrizCruzamento = ones(nIndividuos,4,tamanhoDenominador);

% Avaliação da aptidão inicial
for i = 1:nIndividuos
    
    G1 = tf(1, [1, individuosMatriz(i,1,2)]);
    G2 = tf(1, [1, individuosMatriz(i,2,2)]);
    G3 = tf(1, [1, individuosMatriz(i,3,2)]);
    
    % Definição do diagrama de blocos usando Control System Toolbox
    XYZ = append(G1, G2, G3);
	
    % Simular
    saidaSimulada = lsim(XYZ, entrada, tsaida); 
	
    sub = saidaSimulada-saida;
    pow = sub.^2;
    soma = sum(pow);
    raiz = soma.^(1/2);
    erro(i) = sum(raiz);
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
        
        G1 = tf(1, [1, ind(i,1,2)]);
        G2 = tf(1, [1, ind(i,2,2)]);
        G3 = tf(1, [1, ind(i,2,2)]);

        % Definição do diagrama de blocos usando Control System Toolbox
        XYZ = append(G1, G2, G3);

        % Simular
        saidaSimulada = lsim(XYZ, entrada, tsaida); 

        sub = saidaSimulada-saida;
        pow = sub.^2;
        soma = sum(pow);
        raiz = soma.^(1/2);
        erro(i) = sum(raiz);
        aptidao(i) = 1/erro(i);
        
    end
    
    % Passar para próxima geração
    nGeracoes = nGeracoes - 1; 
end
 
% Exibir matriz dos melhores indivíduos?