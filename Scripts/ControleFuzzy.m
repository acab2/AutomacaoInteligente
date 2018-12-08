% Script fuzzy para controle

% Limpar workspace
clc
clear all
clear

% Criar novo sistema fuzzy
SistFuzzy = newfis('Robo');

% Funções de pertinência servo 1
SistFuzzy = addvar(SistFuzzy,'input','servo1',[0 1023]);

SistFuzzy = addmf(SistFuzzy,'input',1,'Pequeno','trapmf',[0 0 102 204]);
SistFuzzy = addmf(SistFuzzy,'input',1,'MPequeno','trimf',[102 306 512]);
SistFuzzy = addmf(SistFuzzy,'input',1,'Medio','trimf',[306 512 718]);
SistFuzzy = addmf(SistFuzzy,'input',1,'MAlto','trimf',[512 718 922]);
SistFuzzy = addmf(SistFuzzy,'input',1,'Alto','trapmf',[820 922 1023 1023]);

% Funções de pertinência servo 2
SistFuzzy = addvar(SistFuzzy,'input','servo2',[0 1023]);

SistFuzzy = addmf(SistFuzzy,'input',2,'Pequeno','trapmf',[0 0 102 204]);
SistFuzzy = addmf(SistFuzzy,'input',2,'MPequeno','trimf',[102 306 512]);
SistFuzzy = addmf(SistFuzzy,'input',2,'Medio','trimf',[306 512 718]);
SistFuzzy = addmf(SistFuzzy,'input',2,'MAlto','trimf',[512 718 922]);
SistFuzzy = addmf(SistFuzzy,'input',2,'Alto','trapmf',[820 922 1023 1023]);

% Funções de pertinência servo 3
SistFuzzy = addvar(SistFuzzy,'input','servo3',[0 1023]);

SistFuzzy = addmf(SistFuzzy,'input',3,'Pequeno','trapmf',[0 0 102 204]);
SistFuzzy = addmf(SistFuzzy,'input',3,'MPequeno','trimf',[102 306 512]);
SistFuzzy = addmf(SistFuzzy,'input',3,'Medio','trimf',[306 512 718]);
SistFuzzy = addmf(SistFuzzy,'input',3,'MAlto','trimf',[512 718 922]);
SistFuzzy = addmf(SistFuzzy,'input',3,'Alto','trapmf',[820 922 1023 1023]);

% Funções de pertinência posição X
SistFuzzy = addvar(SistFuzzy,'output','posicaoX',[-300 300]);

SistFuzzy = addmf(SistFuzzy,'output',1,'NGrande','trimf',[-300 -300 -150]);
SistFuzzy = addmf(SistFuzzy,'output',1,'NPequeno','trimf',[-300 -150 0]);
SistFuzzy = addmf(SistFuzzy,'output',1,'Zero','trimf',[-150 0 150]);
SistFuzzy = addmf(SistFuzzy,'output',1,'PPequeno','trimf',[0 150 300]);
SistFuzzy = addmf(SistFuzzy,'output',1,'PGrande','trimf',[150 300 300]);

% Funções de pertinência posição Y
SistFuzzy = addvar(SistFuzzy,'output','posicaoY',[-300 300]);

SistFuzzy = addmf(SistFuzzy,'output',2,'NGrande','trimf',[-300 -300 -150]);
SistFuzzy = addmf(SistFuzzy,'output',2,'NPequeno','trimf',[-300 -150 0]);
SistFuzzy = addmf(SistFuzzy,'output',2,'Zero','trimf',[-150 0 150]);
SistFuzzy = addmf(SistFuzzy,'output',2,'PPequeno','trimf',[0 150 300]);
SistFuzzy = addmf(SistFuzzy,'output',2,'PGrande','trimf',[150 300 300]);

% Funções de pertinência posição Z
SistFuzzy = addvar(SistFuzzy,'output','posicaoZ',[0 2000]);

SistFuzzy = addmf(SistFuzzy,'output',3,'Pequeno','trimf',[0 0 500]);
SistFuzzy = addmf(SistFuzzy,'output',3,'MPequeno','trimf',[0 500 1000]);
SistFuzzy = addmf(SistFuzzy,'output',3,'Medio','trimf',[500 1000 1500]);
SistFuzzy = addmf(SistFuzzy,'output',3,'MAlto','trimf',[1000 1500 2000]);
SistFuzzy = addmf(SistFuzzy,'output',3,'Alto','trimf',[1500 2000 2000]);


%figure(1)
%subplot(3,1,1),plotmf(SistFuzzy,'output',1);
%subplot(3,1,2),plotmf(SistFuzzy,'output',2);
%subplot(3,1,3),plotmf(SistFuzzy,'output',3);

%figure(2)
%subplot(4,1,1),plotmf(SistFuzzy,'input',1);
%subplot(4,1,2),plotmf(SistFuzzy,'input',2);
%subplot(4,1,3),plotmf(SistFuzzy,'input',3);
%subplot(4,1,4),plotmf(SistFuzzy,'input',4);


% Construção das regras
regras = zeros(35,6)

% Determinar antecedentes

for i = 1:35
	for j = 1:3
			regras(i,j) = k;
	end
end


% Adicionando regras ao sistema

SistFuzzy = addrule(SistFuzzy,regras);       

% Avaliação com entradas

posicao = evalfis([0 0 0 0],SistFuzzy)

% Salvar o sistema

save ControleRobo

