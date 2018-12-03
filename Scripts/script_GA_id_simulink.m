% Script para identifica��o do modelo utilizando algoritmos gen�ticos
% utilizando Simulink

%OBS: sim, est� com muitas gambys e spaghetti. Quando funcionar, arrumarei.

% Limpar workspace
clc;
%clear all;

% Carregar dados
%data = load('data.mat');
servo1 = data(:,1); servo2 = data(:,2); servo3 = data(:,3); servo4 = data(:,4);
saidaX = data(:,5);
saidaY = data(:,6);
saidaZ = data(:,7);

% Definir par�metros do algoritmo
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
        den = rand(1, tamanhoDenominador); % Gerar coeficientes aleat�rios
        for k = 2:tamanhoDenominador % Profundidade (coeficientes da fun��o de transfer�ncia j)
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
    
    % Avalia��o da aptid�o
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
            
            %Mudar Aqui: o que fazer com a sa�da em time series?
            
            % Calcular os erros
            erroX = erroX + (saidaX(ex)-x(50)).^2;
            erroY = erroY + (saidaY(ex)-y(50)).^2;
            erroZ = erroZ + (saidaZ(ex)-z(50)).^2;
            
        end
        erro(i) = erroX + erroY + erroZ;
        aptidao(i) = 1/erro(i);
    end

    % Sele��o (torneio de nTorneio indiv�duos)
    for i = 1:nIndividuos
        
        % Escolher aleatoriamente nTorneio indiv�duos pra cada torneio
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