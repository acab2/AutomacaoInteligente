%% Controlador Fuzzy usando Fuzzy Logic Toolbox

clc
clear all
clear
warning ('off','all');
%% Definição dos conjuntos Fuzzy de entrada e saída

Fuzzy = mamfis('Name','FuzzyController');

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
Fuzzy = addvar(Fuzzy,'input','ErroZ',[0 2000]);
Fuzzy = addmf(Fuzzy,'input',3,'NB','trapmf',[0 0 800 900]);
Fuzzy = addmf(Fuzzy,'input',3,'NM','trimf',[800 900 1000]);
Fuzzy = addmf(Fuzzy,'input',3,'NS','trimf',[900 1000 1100]);
Fuzzy = addmf(Fuzzy,'input',3,'ZE','trimf',[1000 1100 1200]);
Fuzzy = addmf(Fuzzy,'input',3,'PS','trimf',[1100 1200 1300]);
Fuzzy = addmf(Fuzzy,'input',3,'PM','trimf',[1200 1300 1400]);
Fuzzy = addmf(Fuzzy,'input',3,'PB','trapmf',[1300 1400 2000 2000]);

%Output 1 = Servo 2
Fuzzy = addvar(Fuzzy,'output','Servo2',[195 820]);
Fuzzy = addmf(Fuzzy,'output',1,'NB','trapmf',[195 195 273 351]);
Fuzzy = addmf(Fuzzy,'output',1,'NM','trimf',[273 351 429]);
Fuzzy = addmf(Fuzzy,'output',1,'NS','trimf',[351 429 507]);
Fuzzy = addmf(Fuzzy,'output',1,'ZE','trimf',[429 507 585]);
Fuzzy = addmf(Fuzzy,'output',1,'PS','trimf',[507 585 663]);
Fuzzy = addmf(Fuzzy,'output',1,'PM','trimf',[585 663 741]);
Fuzzy = addmf(Fuzzy,'output',1,'PB','trapmf',[663 741 820 820]);

%Output Y = Servo 3
Fuzzy = addvar(Fuzzy,'output','Servo3',[512, 930]);
Fuzzy = addmf(Fuzzy,'output',2,'NB','trapmf',[512 512 564 616]);
Fuzzy = addmf(Fuzzy,'output',2,'NM','trimf',[564 616 668]);
Fuzzy = addmf(Fuzzy,'output',2,'NS','trimf',[616 668 720]);
Fuzzy = addmf(Fuzzy,'output',2,'ZE','trimf',[668 720 772]);
Fuzzy = addmf(Fuzzy,'output',2,'PS','trimf',[720 772 824]);
Fuzzy = addmf(Fuzzy,'output',2,'PM','trimf',[772 824 876]);
Fuzzy = addmf(Fuzzy,'output',2,'PB','trapmf',[824 876 930 930]);

%Output Z = Servo 4
Fuzzy = addvar(Fuzzy,'output','Servo4',[512 885]);
Fuzzy = addmf(Fuzzy,'output',3,'NB','trapmf',[512 512 558 604]);
Fuzzy = addmf(Fuzzy,'output',3,'NM','trimf',[558 604 650]);
Fuzzy = addmf(Fuzzy,'output',3,'NS','trimf',[604 650 696]);
Fuzzy = addmf(Fuzzy,'output',3,'ZE','trimf',[650 696 742]);
Fuzzy = addmf(Fuzzy,'output',3,'PS','trimf',[696 742 788]);
Fuzzy = addmf(Fuzzy,'output',3,'PM','trimf',[742 788 834]);
Fuzzy = addmf(Fuzzy,'output',3,'PB','trapmf',[788 834 885 885]);

figure(1)
subplot(3,1,1),plotmf(Fuzzy,'output',1);
subplot(3,1,2),plotmf(Fuzzy,'output',2);
subplot(3,1,3),plotmf(Fuzzy,'output',3);

figure(2)
subplot(6,1,1),plotmf(Fuzzy,'input',1);
subplot(6,1,2),plotmf(Fuzzy,'input',2);
subplot(6,1,3),plotmf(Fuzzy,'input',3);

%Formato da regra
% Antecedent1 Antecedent2 Antecedent3 Consequent1 Consequent2 Consequent3
% Wheight (0~1) Operator(1 = And | 2 = Or)
load("uniqueRules.txt");
Fuzzy = addRule(Fuzzy,uniqueRules);
%plotfis(Fuzzy)

%save Fuzzy;

%evalfis = params SistemaFuzzy e vetor com os Antecedentes
%Retorna os Consequentes.
evalfis(Fuzzy, [1,3,2;1,3,3;1,4,2;1,4,3;1,5,2;1,5,3;1,6,2;1,6,3;1,6,4;1,7,3;1,7,4;2,3,2;2,3,3;2,4,2;2,4,3;2,5,2;2,5,3;2,6,2;2,6,3;2,7,2;3,3,2;3,3,3;3,4,2;3,5,2;3,6,2;3,6,3;3,7,2;3,7,3;4,3,2;4,3,3;4,4,2;4,4,3;4,5,2;4,5,3;4,6,2;4,6,3;4,6,4;4,7,2;4,7,3;4,7,4;5,3,2;5,3,3;5,4,2;5,4,3;5,5,2;5,5,3;5,5,4;5,6,2;5,6,3;5,6,4;5,7,2;5,7,3;5,7,4;6,4,3;6,5,3;6,5,4;6,6,3;6,6,4])

%step=2e-4;
%Ref =1;
%gu= 100;
%ge = 50;
%gde = 20;
%D=20;
%tsim = 6;

%Simulação do Controlador Fuzzy e comparação com o PID
%delta = 3;
%vari = 0.00001;
%sim('modeloFuzzy',tsim);
%figure
%plot(t,ref,'k',t,y1,t,y,'r'),
%legend('Set-Point','PID response','Fuzzy controler');
%xlabel('tempo (s)');
%axis([0 tsim 0 3])
%title(['delta=',num2str(delta),'    variância=',num2str(vari)])
%grid



