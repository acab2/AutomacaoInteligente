%% Controlador Fuzzy usando Fuzzy Logic Toolbox

clc
clear all
clear

%% Definição dos conjuntos fuzzy de entrada e saída

Fuzzy = newfis('FuzzyController');

%        Name = FuzzyController
%        Type = mamdani
%        NumInputs = 6
%        InLabels =
%        NumOutputs = 3
%        OutLabels =
%        NumRules   ?
%        AndMethod   min
%        OrMethod   max
%        ImpMethod   min
%        AggMethod   max
%        DefuzzMethod   centroid

%Necessario obter as possiveis opcoes dos IMPUTS de X,Y,Z,erroX,erroY,erroZ
%para adicionar as distribuições ao controlador

%Input 1 = erroX 
Fuzzy = addvar(Fuzzy,'input','ErroX',[-300 300]);
Fuzzy = addmf(Fuzzy,'input',1,'NB','trapmf',[-300 -300 -225 -150]);
Fuzzy = addmf(Fuzzy,'input',1,'NM','trimf',[-225 -150 -75]);
Fuzzy = addmf(Fuzzy,'input',1,'NS','trimf',[-150 -75 0]);
Fuzzy = addmf(Fuzzy,'input',1,'ZE','trimf',[-75 0 75]);
Fuzzy = addmf(Fuzzy,'input',1,'PS','trimf',[0 75 150]);
Fuzzy = addmf(Fuzzy,'input',1,'PM','trimf',[75 150 225]);
Fuzzy = addmf(Fuzzy,'input',1,'PB','trapmf',[150 225 300 300]);

%Input 2 = erroY
Fuzzy = addvar(Fuzzy,'input','ErroY',[-300 300]);
Fuzzy = addmf(Fuzzy,'input',2,'NB','trapmf',[-300 -300 -225 -150]);
Fuzzy = addmf(Fuzzy,'input',2,'NM','trimf',[-225 -150 -75]);
Fuzzy = addmf(Fuzzy,'input',2,'NS','trimf',[-150 -75 0]);
Fuzzy = addmf(Fuzzy,'input',2,'ZE','trimf',[-75 0 75]);
Fuzzy = addmf(Fuzzy,'input',2,'PS','trimf',[0 75 150]);
Fuzzy = addmf(Fuzzy,'input',2,'PM','trimf',[75 150 225]);
Fuzzy = addmf(Fuzzy,'input',2,'PB','trapmf',[150 225 300 300]);

%Input 3 = erroZ
Fuzzy = addvar(Fuzzy,'input','ErroZ',[800 1500]);
Fuzzy = addmf(Fuzzy,'input',3,'NB','trapmf',[0 0 800 900]);
Fuzzy = addmf(Fuzzy,'input',3,'NM','trimf',[800 900 1000]);
Fuzzy = addmf(Fuzzy,'input',3,'NS','trimf',[900 1000 1100]);
Fuzzy = addmf(Fuzzy,'input',3,'ZE','trimf',[1000 1100 1200]);
Fuzzy = addmf(Fuzzy,'input',3,'PS','trimf',[1100 1200 1300]);
Fuzzy = addmf(Fuzzy,'input',3,'PM','trimf',[1200 1300 1400]);
Fuzzy = addmf(Fuzzy,'input',3,'PB','trapmf',[1300 1400 1500 1500]);

%Output 1 = Servo 1
Fuzzy = addvar(Fuzzy,'output','Servo1',[0 1023]);
Fuzzy = addmf(Fuzzy,'output',1,'NB','trapmf',[0 0 128 256]);
Fuzzy = addmf(Fuzzy,'output',1,'NM','trimf',[128 256 384]);
Fuzzy = addmf(Fuzzy,'output',1,'NS','trimf',[256 384 512]);
Fuzzy = addmf(Fuzzy,'output',1,'ZE','trimf',[384 512 640]);
Fuzzy = addmf(Fuzzy,'output',1,'PS','trimf',[512 640 768]);
Fuzzy = addmf(Fuzzy,'output',1,'PM','trimf',[640 768 896]);
Fuzzy = addmf(Fuzzy,'output',1,'PB','trapmf',[768 896 1023 1023]);

%Output Y = Servo 2
Fuzzy = addvar(Fuzzy,'output','Servo2',[0 1023]);
Fuzzy = addmf(Fuzzy,'output',2,'NB','trapmf',[0 0 128 256]);
Fuzzy = addmf(Fuzzy,'output',2,'NM','trimf',[128 256 384]);
Fuzzy = addmf(Fuzzy,'output',2,'NS','trimf',[256 384 512]);
Fuzzy = addmf(Fuzzy,'output',2,'ZE','trimf',[384 512 640]);
Fuzzy = addmf(Fuzzy,'output',2,'PS','trimf',[512 640 768]);
Fuzzy = addmf(Fuzzy,'output',2,'PM','trimf',[640 768 896]);
Fuzzy = addmf(Fuzzy,'output',2,'PB','trapmf',[768 896 1023 1023]);

%Output Z = Servo 3
Fuzzy = addvar(Fuzzy,'output','Servo3',[0 1023]);
Fuzzy = addmf(Fuzzy,'output',3,'NB','trapmf',[0 0 128 256]);
Fuzzy = addmf(Fuzzy,'output',3,'NM','trimf',[128 256 384]);
Fuzzy = addmf(Fuzzy,'output',3,'NS','trimf',[256 384 512]);
Fuzzy = addmf(Fuzzy,'output',3,'ZE','trimf',[384 512 640]);
Fuzzy = addmf(Fuzzy,'output',3,'PS','trimf',[512 640 768]);
Fuzzy = addmf(Fuzzy,'output',3,'PM','trimf',[640 768 896]);
Fuzzy = addmf(Fuzzy,'output',3,'PB','trapmf',[768 896 1023 1023]);

figure(1)
subplot(3,1,1),plotmf(Fuzzy,'output',1);
subplot(3,1,2),plotmf(Fuzzy,'output',2);
subplot(3,1,3),plotmf(Fuzzy,'output',3);

figure(2)
subplot(6,1,1),plotmf(Fuzzy,'input',1);
subplot(6,1,2),plotmf(Fuzzy,'input',2);
subplot(6,1,3),plotmf(Fuzzy,'input',3);
subplot(6,1,4),plotmf(Fuzzy,'input',4);
subplot(6,1,5),plotmf(Fuzzy,'input',5);
subplot(6,1,6),plotmf(Fuzzy,'input',6);

%?????? Não sei o formato esta correto, pois n entendi pra que servem as
%duas ultimas colunas, além de ser necessario atribuir valores a S1 S2 e S3
load("uniqueRules.txt");
Fuzzy = addrule(Fuzzy,uniqueRules);

save Fuzzy;


