% Limpa o workspace
clc
clearvars

global ref_x ref_y ref_z raioMaximo net
"Load"
%% Carrega dados e seta parametros
trainSet=load('trainSet.txt');
netData = load('RNA_iden');
net = netData.net;
raioMaximo = [402, 345, 276];
ref_x = trainSet(:,1);
ref_y = trainSet(:,2);
ref_z = trainSet(:,3);
nGeracoes = 50;
nGeracaoAtual = 1;
nInd = 20; %numero de individuos
lim_inf = [-100 -100 -1 -100 -1 -100 -100 -100 -1]; %Limite inferior
lim_sup = [100 100 1 100 100 1 100 100 1]; %Limite superior
"Populate"
%% Gera populacao
populacao = bsxfun(@plus,lim_inf,bsxfun(@times,lim_sup-lim_inf,rand(nInd-1,length(lim_sup))));

% Pega o melhor individuo da execução passada e coloca ele na população
"Previous Best"
load('ind');
ind_fit=avaliateInd(ind);
save('fit','ind_fit');
populacao(nInd,:)=ind;

%% Abre modelo no Simulink
%controle 

%% Avaliacao dos individuos
fitness = zeros(nInd,1);
for i=1:nInd
    "I"+i
    fitness(i,1) = avaliateInd(populacao(i,:));
end
"terminou a avaliacao inicial"
%% Rodando AG
while nGeracaoAtual<nGeracoes && min(fitness)<1e-5
    "Geração "+nGeracaoAtual
    nGeracoes = nGeracoes-1;
    
    % Seleção dos pais por roleta
    pais = sortearPais(populacao);
    
    % Geracao dos filhos
    filhos = gerarFilhos(pais, lim_inf, lim_sup);
    nFilhos = size(filhos,1);
    % Colocando os filhos no mesmo vetor dos pais
    populacao(nInd+1:nInd+nFilhos,:) = filhos;
    j = nInd+1;
    "Avaliar Filhos"
    for i=1:nFilhos
        "G"+nGeracaoAtual+"F"+j+"/"+nFilhos
        % Colocando a fitness dos filhos no mesmo vetor de fitness dos pais
        fitness(j,1) = avaliateInd(filhos(i,:));
        j = j + 1;
    end
    "Seleciona a proxima geracao"
    % Ordena todas as fitness do menor pro maior, e seleciona as melhores 5
    for i=1:length(fitness)-1
        ordenado = 1;
        for j=1:length(fitness)-1
            if(fitness(j,:) > fitness(j+1,:))
                temp = fitness(j,:);
                fitness(j,:) = fitness(j+1,:);
                fitness(j+1,:) = temp;
                temp = populacao(j,:);
                populacao(j,:) = populacao(j+1,:);
                populacao(j+1,:) = temp;
                ordenado = 0;
            end
        end 
        if (ordenado == 1)
            break
        end
    end
    fitness = fitness(1:nInd,:);
    "Melhor fitness: "+fitness(1)
    populacao = populacao(1:nInd,:);
end

%% Pega melhor individuo
ind = populacao(1,:);

%% Testando o melhor individuo
fitness = avaliateInd(ind)
%% Salva o melhor individuo
ind_fit=fitness;
old_data=load('fit');
old_fit=old_data.ind_fit;
% Salva melhor indiviuo
if(ind_fit<old_fit)
    save('ind','ind');
    save('fit','ind_fit');
end

%% Funcao para avaliar um individuo
function[fitness] = avaliateInd(ind)
    global ref_x ref_y ref_z raioMaximo net

    pid_x = pid(ind(1),ind(2),ind(3));
    pid_y = pid(ind(4),ind(5),ind(6));
    pid_z = pid(ind(7),ind(8),ind(9));
    erroTotal = zeros(length(ref_x),1);
    for i=1:length(ref_x)
        for j=1:20
            entrada = [ref_x(i),ref_y(i),ref_z(i)];
            s2 = abs(evalfr(tf(pid_x),entrada(1)));
            s3 = abs(evalfr(tf(pid_y),entrada(2)));
            s4 = abs(evalfr(tf(pid_z),entrada(3)));
            saida = net([s2;s3;s4])';
            erro = entrada - saida;
            if(s2<135||s2>870)
               erro(1) = raioMaximo(1);
            end
            if(s3<512||s3>925)
               erro(2) = raioMaximo(2);
            end
            if(s4<180||s4>880)
               erro(3) = raioMaximo(3);
            end        
        end
        erroTotal(i,:) = sum(erro.^2);
    end
    % Avalia
    fitness = sum(erroTotal)/(length(ref_x)*3);
    
    %% With simulink
    %{
        set_param('controle/PID_x', 'P', num2str(ind(1)));
        set_param('controle/PID_x', 'I', num2str(ind(2)));
        set_param('controle/PID_x', 'D', num2str(ind(3)));
        set_param('controle/PID_y', 'P', num2str(ind(4)));
        set_param('controle/PID_y', 'I', num2str(ind(5)));
        set_param('controle/PID_y', 'D', num2str(ind(6)));
        set_param('controle/PID_z', 'P', num2str(ind(7)));
        set_param('controle/PID_z', 'I', num2str(ind(8)));
        set_param('controle/PID_z', 'D', num2str(ind(9)));
     %Simula
        sim('controle')
        s2 = output(1);
        s3 = output(2);
        s4 = output(3);

        erro_x = getOptimalErro(erro_x);
        erro_y = getOptimalErro(erro_y);
        erro_z = getOptimalErro(erro_z);
        erros = [sum(erro_x.^2), sum(erro_y.^2), sum(erro_z.^2)];
        erro = sum(erros);
    %}
end

% Funcao para pegar os melhores erros
%{
function optimal_erro = getOptimalErro(erro)
    optimal_erro = zeros(floor(length(erro)/100),1);
    i = 1;
    while i<length(erro)/100
        optimal_erro(i,:) = erro(i*100,:);
        i = i+1;
    end
end
%}

%% Funcao que gera os filhos
function filhos = gerarFilhos(pais, lim_inf, lim_sup)
    taxaMutacao = 0.8;
    taxaCruzamento = 0.2;
    total = size(pais,1);
    pais_1 = pais(1:total/2,:);
    pais_2 = pais((total/2)+1:end,:);
    j = 1;
    noFilhos = 1;
    for i=1:total/2
       cruzar = rand;
       if(cruzar >= taxaCruzamento)
            noFilhos = 0;
            [filho1, filho2] = cruzamento(pais_1(i,:), pais_2(i,:));
            mutarFilho1 = rand;
            mutarFilho2 = rand;
            if(mutarFilho1 >= taxaMutacao)
                filho1 = mutacao(filho1, lim_inf, lim_sup);
            end
            if(mutarFilho2 >= taxaMutacao)
                filho2 = mutacao(filho2, lim_inf, lim_sup);
            end
            filhos(j,:) = filho1;
            j = j + 1;
            filhos(j,:) = filho2;
            j = j + 1;
       end
    end
    if(noFilhos == 1)
        filhos = pais(1,:);
    end
end

%% Funcao de mutacao
function filho = mutacao(filho, lim_inf, lim_sup)
    df = lim_sup - lim_inf; 	% Limite dos genes
    numVar = size(filho,2); 		% Numero de genes 

    mPoint = round(rand * (numVar-1)) + 1; % Escolhe um gene
    newValue = bounds(mPoint,1)+rand * df(mPoint); % Faz uma mutacao naquele gene
    filho(mPoint) = newValue; 		% Salva a mutacao
end

%% Funcao de crossover aritmetico
function [c1, c2] = cruzamento(p1, p2)
    % Pega um valor aleatorio
    a = rand;

    % Cria os filhos usando interpolacao
    c1 = p1*a     + p2*(1-a);
    c2 = p1*(1-a) + p2*a; 
end

function [pais] = sortearPais(populacao)
    nInd = size(populacao,1);
    roleta = randi(nInd,[1,2*nInd]);
    pais = populacao(roleta,:);
end