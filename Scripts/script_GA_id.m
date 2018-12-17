% Script para identifica��o do modelo utilizando algoritmos gen�ticos
% utilizando GA toolbox

% Iniciar paraleliza��o da CPU
%parpool(4);

% Limpar workspace
clc;
clear all;

global entrada saida tsaida ger

% Carregar dados
load('filteredData.txt');
data = filteredData;
nExemplos = length(data);
servo2 = data(1:nExemplos,4); servo3 = data(1:nExemplos,5); servo4 = data(1:nExemplos,6);
saidaX = data(1:nExemplos,1);
saidaY = data(1:nExemplos,2);
saidaZ = data(1:nExemplos,3);

tStop = nExemplos/10; % Tempo de simula��o
entrada = [servo2 servo3 servo4];
saida = [saidaX saidaY saidaZ];
tsaida = 0:0.1:tStop-0.1;
ger = 0;

% Configura��o do GA
nGeracoes = 400;
nIndividuos = 50;
limErro = 1e-6;
taxaCruzamento = 0.7;
lim_inf = [-1000 -1000 -1000 -1000 -1000 -1000 -1000 -1000 -1000 -1000 -1000 -1000 -1000 -1000 -1000]; %Limite inferior
lim_sup = [1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000]; %Limite superior
tam = length(lim_sup);
options = optimoptions('ga','CrossoverFraction', taxaCruzamento,'Display', 'off','FunctionTolerance', limErro,'MaxGenerations', nGeracoes*tam,'PopulationSize', nIndividuos);

% Executar AG usando GA Toolbox
[ind,erro,~,output] = ga(@identificacao,tam,[],[],[],[],lim_inf,lim_sup,[],options);


% Fun��es de transfer�ncia com individuo mais apto
G1 = tf(1, [1, ind(1), ind(2), ind(3), ind(4), ind(5)]);
G2 = tf(1, [1, ind(6), ind(7), ind(8), ind(9), ind(10)]);
G3 = tf(1, [1, ind(11), ind(12), ind(13), ind(14), ind(15)]);

% Defini��o do diagrama de blocos usando Control System Toolbox
Syst2 = [G2 G2;G2 G2];
Syst3 = [G3 G3;G3 G3];
YZ = lft(Syst2,Syst3,1,1);
XYZ = append(G1, YZ);
    
% Simular sistema com coeficientes do individuo mais apto
saidaSimulada = lsim(XYZ,entrada,tsaida);

% Plotar gr�ficos de erro
figure
plot(tsaida,saida(:,1),'black',tsaida,saidaSimulada(:,1),'red')
title('Identifica��o usando GA - Erro X','FontSize', 16)
xlabel('Tempo ','FontSize', 16)
ylabel('Saida','FontSize', 16)
legend('Real','Estimado')

figure
plot(tsaida,saida(:,2),'black',tsaida,saidaSimulada(:,2),'red')
title('Identifica��o usando GA - Erro Y','FontSize', 16)
xlabel('Tempo ','FontSize', 16)
ylabel('Saida','FontSize', 16)
legend('Real','Estimado')

figure
plot(tsaida,saida(:,3),'black',tsaida,saidaSimulada(:,3),'red')
title('Identifica��o usando GA - Erro Z','FontSize', 16)
xlabel('Tempo ','FontSize', 16)
ylabel('Saida','FontSize', 16)
legend('Real','Estimado')

% Salvar melhor individuo
save apto.mat ind

% Finalizar paraleliza��o
%delete(gcp('nocreate'));

% Fun��o de aptid�o
function erro = identificacao(ind)
    
    global entrada saida tsaida ger
    %ger
    
    % Declara��o das fun��es de tranfer�ncia
    G1 = tf(1, [1, ind(1), ind(2), ind(3), ind(4), ind(5)]);
    G2 = tf(1, [1, ind(6), ind(7), ind(8), ind(9), ind(10)]);
    G3 = tf(1, [1, ind(11), ind(12), ind(13), ind(14), ind(15)]);
    
    % Defini��o do diagrama de blocos usando Control System Toolbox
    Syst2 = [G2 G2;G2 G2];
    Syst3 = [G3 G3;G3 G3];
    YZ = lft(Syst2,Syst3,1,1);
    XYZ = append(G1, YZ);
	
    % Simular
    saidaSimulada = lsim(XYZ, entrada, tsaida); 
	
    % Computar erro
    sub = saidaSimulada-saida;
    pow = sub.^2;
    soma = sum(pow);
    raiz = soma.^(1/2);
    erro = sum(raiz);
   
    %ger = ger+1;
end