function [position] = positionSet(s, goalPos)

    %criar uma comunicação Serial
    %s = serial('COM3', 'BaudRate', 9600);
    %fopen(s);
    %informações da porta na tela
    %get(s);
    % operação que cinde informação em dois bytes
    low = mod (goalPos, 256);
    high = floor(goalPos/256);

    % ordem deve ser mantida, pois há uma 'fila' no Arduíno.
    % lendo posicao, argumento: qnt de bytes a serem lidos.
    % sempre na ordem de low, depois high.
    fwrite(s, low);
    fwrite(s, high);
    %Eu acredito que deva ter um tempo de escrita para o arduino, fechando a porta.
    %É uma Suposição: Faltam MAIS testes.
    %fclose(s);
    %fopen(s);
    %receber a posição em ordem, sempre.
    %position = fread(s, 1);
    %position = position + fread(s, 1)*256;
    %nada mais vai ser feito até então.
    %fclose(s);
end