clc
clear all
clear

load("filteredData.txt");

adress = ''; %setar um caminho de destino
nome_arquivo = strcat(adress, 'rules.txt');
id_arquivo = fopen(nome_arquivo, 'wt'); %abre o arquivo e executa a acao wt = write

for i = 1:length(filteredData)
    
    if filteredData(i,1) < -187.5
        erroX = 1;
    elseif filteredData(i,1) >= -187.5 && filteredData(i,1) < -112.5
        erroX = 2;
    elseif filteredData(i,1) >= -112.5 && filteredData(i,1) < -37.5
        erroX = 3;
    elseif filteredData(i,1) >= -37.5 && filteredData(i,1) < 37.5
        erroX = 4;
    elseif filteredData(i,1) >= 37.5 && filteredData(i,1) < 112.5
        erroX = 5;
    elseif filteredData(i,1) >= 112.5 && filteredData(i,1) < 187.5
        erroX = 6;
    else 
        erroX = 7;
    end
    
    if filteredData(i, 2) < -187.5
        erroY = 1;
    elseif filteredData(i, 2) >= -187.5 && filteredData(i, 2) < -112.5
        erroY = 2;
    elseif filteredData(i, 2) >= -112.5 && filteredData(i, 2) < -37.5
        erroY = 3;
    elseif filteredData(i, 2) >= -37.5 && filteredData(i, 2) < 37.5
        erroY = 4;
    elseif filteredData(i, 2) >= 37.5 && filteredData(i, 2) < 112.5
        erroY = 5;
    elseif filteredData(i, 2) >= 112.5 && filteredData(i, 2) < 187.5
        erroY = 6;
    else 
        erroY = 7;
    end
    
    if filteredData(i, 3) < 850
        erroZ = 1;
    elseif filteredData(i, 3) >= 850 && filteredData(i, 3) < 950
        erroZ = 2;
    elseif filteredData(i, 3) >= 950 && filteredData(i, 3) < 1050
        erroZ = 3;
    elseif filteredData(i, 3) >= 1050 && filteredData(i, 3) < 1150
        erroZ = 4;
    elseif filteredData(i, 3) >= 1150 && filteredData(i, 3) < 1250
        erroZ = 5;
    elseif filteredData(i, 3) >= 1250 && filteredData(i, 3) < 1350
        erroZ = 6;
    else 
        erroZ = 7;
    end
    
    if filteredData(i, 4) < 312
        S2 = 1;
    elseif filteredData(i, 4) < 390
        S2 = 2;
    elseif filteredData(i, 4) < 468
        S2 = 3;
    elseif filteredData(i, 4) < 546
        S2 = 4;
    elseif filteredData(i, 4) < 624
        S2 = 5;
    elseif filteredData(i, 4) < 702
        S2 = 6;
    else 
        S2 = 7;
    end
    
    if filteredData(i, 5) < 590
        S3 = 1;
    elseif filteredData(i, 5) < 642
        S3 = 2;
    elseif filteredData(i, 5) < 694
        S3 = 3;
    elseif filteredData(i, 5) < 746
        S3 = 4;
    elseif filteredData(i, 5) < 798
        S3 = 5;
    elseif filteredData(i, 5) < 850
        S3 = 6;
    else 
        S3 = 7;
    end
    
    if filteredData(i, 5) > 855
        S4 = 1;
    else
        
        if filteredData(i, 6) < 581
            S4 = 1;
        elseif filteredData(i, 6) < 627
            S4 = 2;
        elseif filteredData(i, 6) < 673
            S4 = 3;
        elseif filteredData(i, 6) < 719
            S4 = 4;
        elseif filteredData(i, 6) < 765
            S4 = 5;
        elseif filteredData(i, 6) < 811
            S4 = 6;
        else 
            S4 = 7;
        end
    end
    fprintf(id_arquivo, "%d %d %d %d %d %d\n", erroX, erroY, erroZ, S2, S3, S4);
    
end

fclose(id_arquivo); %fecha o arquivo
load("rules.txt");

rules = unique(rules,'rows');

nome_arquivo = strcat(adress, 'Rules.txt');
id_arquivo = fopen(nome_arquivo, 'wt'); %abre o arquivo e executa a acao wt = write
for i = 1:length(rules)
    fprintf(id_arquivo, "%d %d %d %d %d %d\n", rules(i,1), rules(i,2), rules(i,3), rules(i,4), rules(i,5), rules(i,6));
end

fclose(id_arquivo); %fecha o arquivo

disp("fim");
% min         maerroX
%erroX       -300        300
%erroY       -300        300
%erroZ       800         1500

%S2      150         850
%S3      512         1024
%S4      512         1024

%servo2 = randi([195, 820],[2000,1]);
%servo3 = randi([512, 930],[2000,1]);
%servo4 = randi([512, 885],[2000,1]);
%servo5 = 512;
% if servo3 > 855 then servo4 = 512;