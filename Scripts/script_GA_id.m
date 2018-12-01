% Limpar workspace
clc;
clear all;

% Carregar dados
data = load('data.mat');
s1 = data[1]; s2 = data[2]; s3 = data[3]; s4 = data[4];
x = data[5];
y = data[6];
z = data[7];

% Configuração do GA
nGeracoes = 1000;
nIndividuos = 20;
limErro = 1e-6;
taxaMutacao = 0.7;

lim_inf = []; %Limite inferior
lim_sup = []; %Limite superior
tam = length(lim_sup);
options = optimoptions('ga','CrossoverFraction', taxaMutacao,'Display', 'off','FunctionTolerance', limErro,'MaxGenerations', nGeracoes*tam,'PopulationSize', nIndividuos);