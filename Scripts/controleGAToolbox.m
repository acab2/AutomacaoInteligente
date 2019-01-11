% Limpa o workspace
clc
clearvars

% Carregando os dados
load('data.mat');
global entrada saida tsaida

entrada = data(:,[2,3,4])';
saida = data(:,[5,6,7]);
tsaida = (0:1999);

% Parametros
nGeracoes = 10;
nIndividuos = 5;
limErro = 1e-6;
taxaMutacao = 0.07;
lim_inf = [-1000 -1000 -1000]; %Limite inferior
lim_sup = [1000 1000 1000]; %Limite superior
tam = length(lim_sup);
options = optimoptions('ga','CrossoverFraction', taxaMutacao,'Display', 'off','FunctionTolerance', limErro,'MaxGenerations', nGeracoes*tam,'PopulationSize', nIndividuos);

% Executando o GA toolbox
[ind,erro,~,output] = ga(@controle,tam,[],[],[],[],lim_inf,lim_sup,[],options);

% Funções de transferência com individuo mais apto
G1 = tf(1, [1, ind(1)]);
G2 = tf(1, [1, ind(2)]);
G3 = tf(1, [1, ind(3)]);
sys = append(G1, G2, G3);

% Simular sistema com coeficientes do individuo mais apto
saidaSimulada = lsim(sys,entrada,tsaida);

save('ind','ind');

% Plotar
figure
plot(tsaida,saida,'red',tsaida,saidaSimulada,'blue')
title('Controle usando GA','FontSize', 16)
xlabel('Tempo ','FontSize', 16)
ylabel('Saida','FontSize', 16)
legend('Real','Estimado')


% Função de aptidão
function erro = controle(ind)
    
    global entrada saida tsaida
    load('RNA_iden');
    % Declaração das funções de tranferência
    G1 = tf(1, [1, ind(1)]);
    G2 = tf(1, [1, ind(2)]);
    G3 = tf(1, [1, ind(3)]);
    
    G2G3 = lft(G2, G3);
    G1G2G3 = append(G1, G2G3);
    
    % Definição do diagrama de blocos usando Control System Toolbox
	sys_control = G1G2G3*net;
    
    sys = feedback(sys_control, 1)
    
    % Simular
	saidaSimulada = lsim(sys, entrada, tsaida); 
	
    saidaSimulada(isnan(saidaSimulada)) = inf;
    
    sub = (saidaSimulada-saida);
    sub2 = sub.^2;
    soma_sub = sum(sub2);
    raiz = soma_sub.^(1/2);
    erro = sum(raiz);
   
end