function [erroX,erroY,erroZ] = fuzzification(X,Y,Z)

    if X < -187.5
        erroX = 1;
    elseif X >= -187.5 && X < -112.5
        erroX = 2;
    elseif X >= -112.5 && X < -37.5
        erroX = 3;
    elseif X >= -37.5 && X < 37.5
        erroX = 4;
    elseif X >= 37.5 && X < 112.5
        erroX = 5;
    elseif X >= 112.5 && X < 187.5
        erroX = 6;
    else 
        erroX = 7;
    end
    
    if Y < -187.5
        erroY = 1;
    elseif Y >= -187.5 && Y < -112.5
        erroY = 2;
    elseif Y >= -112.5 && Y < -37.5
        erroY = 3;
    elseif Y >= -37.5 && Y < 37.5
        erroY = 4;
    elseif Y >= 37.5 && Y < 112.5
        erroY = 5;
    elseif Y >= 112.5 && Y < 187.5
        erroY = 6;
    else 
        erroY = 7;
    end
    
    if Z < 850
        erroZ = 1;
    elseif Z >= 850 && Z < 950
        erroZ = 2;
    elseif Z >= 950 && Z < 1050
        erroZ = 3;
    elseif Z >= 1050 && Z < 1150
        erroZ = 4;
    elseif Z >= 1150 && Z < 1250
        erroZ = 5;
    elseif Z >= 1250 && Z < 1350
        erroZ = 6;
    else 
        erroZ = 7;
    end
    
end