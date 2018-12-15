% Script para identifica��o do modelo utilizando algoritmos gen�ticos
% utilizando GA toolbox

%OBS: load('data.mat') t� gerando estrutura errada. Carregar data
%diretamente dando 2 cliques no data.mat

% Limpar workspace
%clc;
%clear all;

global entrada saida tsaida ger

% Carregar dados
%data = load('data.mat');
nExemplos = 100;%length(data);
servo1 = data(1:nExemplos,1); servo2 = data(1:nExemplos,2); servo3 = data(1:nExemplos,3);
saidaX = data(1:nExemplos,5);
saidaY = data(1:nExemplos,6);
saidaZ = data(1:nExemplos,7);

tStop = nExemplos/10; % Tempo de simula��o
entrada = [servo1 servo2 servo3];
saida = [saidaX saidaY saidaZ];
tsaida = 0:0.1:tStop-0.1; 

% Configura��o do GA
nGeracoes = 100;
nIndividuos = 20;
limErro = 1e-6;
taxaMutacao = 0.07;
lim_inf = [-1000 -1000 -1000]; %Limite inferior
lim_sup = [1000 1000 1000]; %Limite superior
tam = length(lim_sup);
options = optimoptions('ga','CrossoverFraction', taxaMutacao,'Display', 'off','FunctionTolerance', limErro,'MaxGenerations', nGeracoes*tam,'PopulationSize', nIndividuos);

ger = 0;

% Utilizando GA Toolbox
[ind,erro,~,output] = ga(@identificacao,tam,[],[],[],[],lim_inf,lim_sup,[],options);

% Fun��es de transfer�ncia com individuo mais apto
G1 = tf(1, [1, ind(1)]);
G2 = tf(1, [1, ind(2)]);
G3 = tf(1, [1, ind(3)]);
XY = lft(G1,G2);
XYZ = lft(XY,G3);

% Simular sistema com coeficientes do individuo mais apto
saidaSimulada = lsim(XYZ,entrada,tsaida);

% Plotar
figure
plot(tsaida,saida,'black',tsaida,saidaSimulada,'red')
title('Identifica��o usando GA','FontSize', 16)
xlabel('Tempo ','FontSize', 16)
ylabel('Saida','FontSize', 16)
legend('Real','Estimado')

% Salvar melhor individuo

% Fun��o de aptid�o
function erro = identificacao(ind)
    
    global entrada saida tsaida ger
    ger
    
    % Declara��o das fun��es de tranfer�ncia
    G1 = tf(1, [1, ind(1)]);
    G2 = tf(1, [1, ind(2)]);
    G3 = tf(1, [1, ind(3)]);
    
    % Defini��o do diagrama de blocos usando Control System Toolbox
    YZ = lft(G2,G3);
	XYZ = append(G1, G2, G3);
	
    % Simular
    saidaSimulada = lsim(XYZ, entrada, tsaida); 
	
    sub = saidaSimulada-saida;
    pow = sub.^2;
    soma = sum(pow);
    raiz = soma.^(1/2);
    erro = sum(raiz);
    
    % Computar erro
    %erro = (sum((saidaSimulada-saida).^2))^(1/2);
    ger = ger+1;
end