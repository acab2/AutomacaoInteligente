clc
%clear
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

%% Abre simulink
%sistema_final

%% Adquirindo sinal de controle

% Carregando dados do controle
ind = [8.7597;-1.2064;-1.583;0.6434;0.3925;-9.2056;0.5882;0.2923;0.7282];
%load('ind.mat')
pid_x = pid(ind(1),ind(2),ind(3));
pid_y = pid(ind(4),ind(5),ind(6));
pid_z = pid(ind(7),ind(8),ind(9));
%{
set_param('sistema_final/PID_x', 'P', num2str(ind(1)));
set_param('sistema_final/PID_x', 'I', num2str(ind(2)));
set_param('sistema_final/PID_x', 'D', num2str(ind(3)));
set_param('sistema_final/PID_y', 'P', num2str(ind(4)));
set_param('sistema_final/PID_y', 'I', num2str(ind(5)));
set_param('sistema_final/PID_y', 'D', num2str(ind(6)));
set_param('sistema_final/PID_z', 'P', num2str(ind(7)));
set_param('sistema_final/PID_z', 'I', num2str(ind(8)));
set_param('sistema_final/PID_z', 'D', num2str(ind(9)));
sim('sistema_final')
%}
OPEN_CLAW = 512;
CLOSE_CLAW = 200;
"comecar"
diff_x=abs(posicao_bloco(1)-posicao_robo(1));
diff_y=abs(posicao_bloco(2)-posicao_robo(2));
diff_z=posicao_bloco(3)-posicao_robo(3);

while (diff_x>25||diff_y>3||diffz>0) > 1e-4
    entrada = (posicao_bloco - posicao_robo);
    s2 = evalfr(tf(pid_x),entrada(1));
    s3 = evalfr(tf(pid_y),entrada(2));
    s4 = evalfr(tf(pid_z),entrada(3));
    
    if(s2<135)
        s2=135;
    end
    if(s2>870)
        s2=870;
    end
    if(s3<512)
        s3=512;
    end
    if(s3>925)
        s3=925;
    end
    if(s4<180)
        s4=180;
    end
    if(s4>880)
        s4=880;
    end
    "robo"
    %goalPos=""+s2+s3+s4+OPEN_CLAW;
    positionSet(serial_port,s2);
    positionSet(serial_port,s3);
    positionSet(serial_port,s4);
    positionSet(serial_port,OPEN_CLAW);
    "camera"
    posicao_robo = posicaoCor(cam1, cam2, robo);
    diff_x=abs(posicao_bloco(1)-posicao_robo(1));
    diff_y=abs(posicao_bloco(2)-posicao_robo(2));
    diff_z=posicao_bloco(3)-posicao_robo(3);
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
