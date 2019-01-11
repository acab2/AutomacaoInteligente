clearvars
load('data.mat')
tempo = (0:1999)';

%% Descomente se quiser usar uma rede ja treinada

%load('RNA_iden')
%load('RNA_iden_resp')

%%
% Comente se nao quiser treinar a rede
entrada = data(:,[2,3,4]);
saida = data(:,[5,6,7]);
u = entrada';
y = saida';


numNeuronios = 100;
net = feedforwardnet(numNeuronios);
net.trainParam.goal = 1e-5; %Erro Mínimo Desejado
net.trainParam.epochs = 100; %Número Máximo de Épocas
net.trainParam.max_fail = 100; %Maximum Number of Validation Increases
net.trainParam.showWindow=0; %Para não mostrar o treinamento.
%Treinamento da Rede Neural
net = train(net,u,y);
%Resposta da Rede Treinada
resposta_net = net(u);

erro_abs = mae(net,y,resposta_net) %Erro Médio Absoluto da Rede Neural
des_erro = std(y - resposta_net) %Desvio padrão do erro
erro_mse = mse(net,resposta_net,y)

gensim(net)
save('RNA_iden', 'net');
save('RNA_iden_resp', 'resposta_net');
%}
%%
figure
plot(tempo,y,'red',tempo,resposta_net,'blue')
title('Resposta da Identificação usando RN','FontSize', 16)
xlabel('Tempo ','FontSize', 16)
ylabel('Saida','FontSize', 16)
legend('Real','Estimado')