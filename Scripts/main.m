clc
clear
warning ('off','all');
fuz = FuzzyController();
global serial_port stereoParams cam1 cam2
%% Adquire a instrucao Instrução:
% cor_do_bloco = load('instrucao.txt')

%% Adquire info da camera
stereoParams = load('sterioParams.mat', 'stereoParams');

%% main
delete(instrfindall);
serial_port = serial('COM3', 'BaudRate', 9600);   
[cam1, cam2] = connectStereoCams;
%LAB = getLABColor(cam1, 81);    
fopen(serial_port);

%calibrate(cam1, cam2);
data = load('rosa', 'LAB');
bloco = data.LAB;
data = load('amarelo', 'LAB');
robo = data.LAB;

posicao_bloco = posicaoCor(cam1, cam2, bloco);
posicao_robo = posicaoCor(cam1, cam2, robo);

%ref_x = posicao_bloco(1);
%ref_y = posicao_bloco(2);
%ref_z = posicao_bloco(3);

erro = [0,0,0];

%% Abre simulink
%sistema_final

%% Adquirindo sinal de controle

% Carregando dados do controle


load("apto.mat");
s2 = 0;
s3 = 0;
s4 = 0;

OPEN_CLAW = 512;
CLOSE_CLAW = 200;
"Starto"

erro = pdist2(posicao_robo, posicao_bloco);

while erro > 1e-4
    s = evalfis(fuz, erro);
    
    positionSet(serial_port,s(3));
    positionSet(serial_port,s(2));
    positionSet(serial_port,s(1));
    positionSet(serial_port,OPEN_CLAW);
    
    pause(9)
    posicao_bloco = posicaoCor(cam1, cam2, bloco)
    posicao_robo = posicaoCor(cam1, cam2, robo)
    
    erro = pdist2(posicao_robo, posicao_bloco);
    "erro" 
    
end



function [] = calibrate(cam1, cam2)
    stereoParams = quickStereoCalibration(cam1, cam2);
end

function pos = posicaoCor(cam1, cam2, LAB)
   success=0;
   load('sterioParams');
   while success==0
        stat1 = detectLABColor(cam1, LAB);
        stat2 = detectLABColor(cam2, LAB);
        [pos,success] = triangular(stat1, stat2, stereoParams);  
   end
end