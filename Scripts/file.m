for i = 1: 2000
    fprintf(id_arq, '%d %f %f %f %d %d %d \n', i, vetorPos(i, 1), vetorPos(i, 2), vetorPos(i, 3), servo2(i), servo3(i), servo4(i));
end