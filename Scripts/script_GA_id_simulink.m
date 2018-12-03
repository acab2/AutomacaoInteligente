% Script para identificação do modelo utilizando algoritmos genéticos
% utilizando Simulink

%OBS: sim, está com muitas gambys e spaghetti. Quando funcionar, arrumarei.

% Limpar workspace
clc;
%clear all;

% Carregar dados
%data = load('data.mat');
servo1 = data(:,1); servo2 = data(:,2); servo3 = data(:,3); servo4 = data(:,4);
saidaX = data(:,5);
saidaY = data(:,6);
saidaZ = data(:,7);

% Definir parâmetros do algoritmo
nGeracoes = 10;
nIndividuos = 3;
nTorneio = 2;
limErro = 1e-6;
taxaMutacao = 0.7;
Param.StopT = 0.0001;
tamanhoDenominador = 2;

seedRand = rng;
save('script_GA_id_simulink', 'seedRand');
nExemplos = 10;%length(data);

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
        den = rand(1, tamanhoDenominador); % Gerar coeficientes aleatórios
        for k = 2:tamanhoDenominador % Profundidade (coeficientes da função de transferência j)
            individuosMatriz(i,j,k) = den(k);
        end
    end
end

% Abrir simulink
open('simulink_GA_id');

% Realizar AG
aptidao = zeros(20,1);
erro = ones(20,1);
individuosMatrizNovos = ones(nIndividuos,4,tamanhoDenominador);
while nGeracoes > 0 && min(erro) > limErro
    
    % Avaliação da aptidão
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
            
            %Mudar Aqui: o que fazer com a saída em time series?
            
            % Calcular os erros
            erroX = erroX + (saidaX(ex)-x(50)).^2;
            erroY = erroY + (saidaY(ex)-y(50)).^2;
            erroZ = erroZ + (saidaZ(ex)-z(50)).^2;
            
        end
        erro(i) = erroX + erroY + erroZ;
        aptidao(i) = 1/erro(i);
    end

    % Seleção (torneio de nTorneio indivíduos)
    for i = 1:nIndividuos
        
        % Escolher aleatoriamente nTorneio indivíduos pra cada torneio
        indicesTorneio = randi([1 nIndividuos], 1, nTorneio);
        apt = 0;
        indice = 0;
        
        % Realizar torneio
        for j = 1:nTorneio
            
            if aptidao(indicesTorneio(j)) > apt
                apt = aptidao(indicesTorneio(j));
                indice = indicesTorneio(j);
            end
        end
        
        individuosMatrizNovos(i,:,:) = individuosMatriz(indice,:,:);
    end
    
    % Cruzamento
    
    
    % Crossover
    
    nGeracoes = nGeracoes - 1;
end
 

% Simular modelo
%sim('simulink_GA_id'); 