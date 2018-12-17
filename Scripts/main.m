clc
clear
warning ('off','all');
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

fuz = FuzzyController();
load("apto.mat");

OPEN_CLAW = 512;
CLOSE_CLAW = 200;
"Starto"
while pdist2(posicao_robo - posicao_bloco) > 1e-4
    erro = (posicao_bloco - posicao_robo);%+ erro;
%     entrada = fuzzification(erro);
    
    s2, s3, s4 = evalfis(Fuzzy, erro);
    
    "robo"
    positionSet(serial_port,s4);
    positionSet(serial_port,s3);
    positionSet(serial_port,s2);
    positionSet(serial_port,OPEN_CLAW);
    
%     G1 = tf(1, [1, ind(1), ind(2), ind(3), ind(4), ind(5)]);
%     G2 = tf(1, [1, ind(6), ind(7), ind(8), ind(9), ind(10)]);
%     G3 = tf(1, [1, ind(11), ind(12), ind(13), ind(14), ind(15)]);
%     
%     % Definição do diagrama de blocos usando Control System Toolbox
%     XYZ = append(G1, G2, G3);
% 	
%     % Simular
%     saidaSimulada = lsim(XYZ,  [s2 s3 s4], [0.1]); 
%     
%     erro =   abs(posicao_robo - saidaSimulada);
    
    pause(9)
    "camera"
    posicao_robo = posicaoCor(cam1, cam2, robo);
    %erro = posicao_bloco - posicao_robo;
    "erro"
end



function [] = calibrate(cam1, cam2)
    stereoParams = quickStereoCalibration(cam1, cam2);
end

function pos = posicaoCor(cam1, cam2, LAB)
   success=0;
   load('sterioParams')
   while success==0
        stat1 = detectLABColor(cam1, LAB);
        stat2 = detectLABColor(cam2, LAB);
        [pos,success] = triangular(stat1, stat2, stereoParams);  
   end
end