function [cam1, cam2] = connectStereoCams()
%
% function [cam1, cam2] = connectStereoCams()
%
% Essa função é usada para, verificar conexão com as câmeras e retorná-las
% em caso de sucesso.
% ARGUMENTO: 
% Nenhum.
% ALGORITMO:
% Testa conexão e mostra um preview.
% RETORNO:
% cam1 e cam2 para possível calibração.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hywre Cesar - Novembro 2018
% www.fb.com.br/hycesar
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%verifique se as cameras conectadas são as certas
webcamlist

%Foram colocadas juntas por algum motivo, 
%já que antes dava timeout
cam1 = webcam(1);
%Melhor definir resolução 4:3 que é mais 'alta' que o normal.
%Assim dá pra ver a altura do braço melhor.
cam1.Resolution='1280x960';
preview(cam1);
pause(5);
closePreview(cam1);

%Preferiu abrir a camera e fechar 
%e depois abrir a segunda, na abordagem anterior
%dava timeout, talvez por que dava deadlock.
%Não alterar
cam2 = webcam(2);
cam2.Resolution='1280x960';
preview(cam2);
pause(5);
closePreview(cam2);
if isempty(cam1) || isempty(cam2)
    error("Verifique sua câmeras!");
end
end