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
Fuzzy = addInput(Fuzzy,[-300 300],'Name',"ErroX");
Fuzzy = addMF(Fuzzy,"ErroX","trapmf",[-300 -300 -225 -150],'Name',"NB");
Fuzzy = addMF(Fuzzy,"ErroX","trimf",[-225 -150 -75],'Name',"NM");
Fuzzy = addMF(Fuzzy,"ErroX","trimf",[-150 -75 0],'Name',"NS");
Fuzzy = addMF(Fuzzy,"ErroX","trimf",[-75 0 75],'Name',"ZE");
Fuzzy = addMF(Fuzzy,"ErroX","trimf",[0 75 150],'Name',"PS");
Fuzzy = addMF(Fuzzy,"ErroX","trimf",[75 150 225],'Name',"PM");
Fuzzy = addMF(Fuzzy,"ErroX","trapmf",[150 225 300 300],'Name',"PB");

%Input 2 = erroY
Fuzzy = addInput(Fuzzy,[-300 300],'Name',"ErroY");
Fuzzy = addMF(Fuzzy,"ErroY","trapmf",[-300 -300 -225 -150],'Name',"NB");
Fuzzy = addMF(Fuzzy,"ErroY","trimf",[-225 -150 -75],'Name',"NM");
Fuzzy = addMF(Fuzzy,"ErroY","trimf",[-150 -75 0],'Name',"NS");
Fuzzy = addMF(Fuzzy,"ErroY","trimf",[-75 0 75],'Name',"ZE");
Fuzzy = addMF(Fuzzy,"ErroY","trimf",[0 75 150],'Name',"PS");
Fuzzy = addMF(Fuzzy,"ErroY","trimf",[75 150 225],'Name',"PM");
Fuzzy = addMF(Fuzzy,"ErroY","trapmf",[150 225 300 300],'Name',"PB");

%Input 3 = erroZ
Fuzzy = addInput(Fuzzy,[0 2000],'Name',"ErroZ");
Fuzzy = addMF(Fuzzy,"ErroZ","trapmf",[0 0 800 900],'Name',"NB");
Fuzzy = addMF(Fuzzy,"ErroZ","trimf",[800 900 1000],'Name',"NM");
Fuzzy = addMF(Fuzzy,"ErroZ","trimf",[900 1000 1100],'Name',"NS");
Fuzzy = addMF(Fuzzy,"ErroZ","trimf",[1000 1100 1200],'Name',"ZE");
Fuzzy = addMF(Fuzzy,"ErroZ","trimf",[1100 1200 1300],'Name',"PS");
Fuzzy = addMF(Fuzzy,"ErroZ","trimf",[1200 1300 1400],'Name',"PM");
Fuzzy = addMF(Fuzzy,"ErroZ","trapmf",[1300 1400 2000 2000],'Name',"PB");

%Output 1 = Servo 2
Fuzzy = addOutput(Fuzzy,[195 820],'Name',"Servo2");
Fuzzy = addMF(Fuzzy,"Servo2","trapmf",[195 195 273 351],'Name',"NB");
Fuzzy = addMF(Fuzzy,"Servo2","trimf",[273 351 429],'Name',"NM");
Fuzzy = addMF(Fuzzy,"Servo2","trimf",[351 429 507],'Name',"NS");
Fuzzy = addMF(Fuzzy,"Servo2","trimf",[429 507 585],'Name',"ZE");
Fuzzy = addMF(Fuzzy,"Servo2","trimf",[507 585 663],'Name',"PS");
Fuzzy = addMF(Fuzzy,"Servo2","trimf",[585 663 741],'Name',"PM");
Fuzzy = addMF(Fuzzy,"Servo2","trapmf",[663 741 820 820],'Name',"PB");

%Output Y = Servo 3
Fuzzy = addOutput(Fuzzy,[512, 930],'Name',"Servo3");
Fuzzy = addMF(Fuzzy,"Servo3","trapmf",[512 512 564 616],'Name',"NB");
Fuzzy = addMF(Fuzzy,"Servo3","trimf",[564 616 668],'Name',"NM");
Fuzzy = addMF(Fuzzy,"Servo3","trimf",[616 668 720],'Name',"NS");
Fuzzy = addMF(Fuzzy,"Servo3","trimf",[668 720 772],'Name',"ZE");
Fuzzy = addMF(Fuzzy,"Servo3","trimf",[720 772 824],'Name',"PS");
Fuzzy = addMF(Fuzzy,"Servo3","trimf",[772 824 876],'Name',"PM");
Fuzzy = addMF(Fuzzy,"Servo3","trapmf",[824 876 930 930],'Name',"PB");

%Output Z = Servo 4
Fuzzy = addOutput(Fuzzy,[512 885],'Name',"Servo4");
Fuzzy = addMF(Fuzzy,"Servo4","trapmf",[512 512 558 604],'Name',"NB");
Fuzzy = addMF(Fuzzy,"Servo4","trimf",[558 604 650],'Name',"NM");
Fuzzy = addMF(Fuzzy,"Servo4","trimf",[604 650 696],'Name',"NS");
Fuzzy = addMF(Fuzzy,"Servo4","trimf",[650 696 742],'Name',"ZE");
Fuzzy = addMF(Fuzzy,"Servo4","trimf",[696 742 788],'Name',"PS");
Fuzzy = addMF(Fuzzy,"Servo4","trimf",[742 788 834],'Name',"PM");
Fuzzy = addMF(Fuzzy,"Servo4","trapmf",[788 834 885 885],'Name',"PB");

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

save Fuzzy;

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



