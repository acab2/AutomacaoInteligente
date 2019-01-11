
function [] = positionSet(serial_port,goalPos)
warning ('off','all');
    goalPos = int2str(cast(goalPos,'uint16'));
    fprintf(serial_port, '%s', goalPos);
    pause(1)
    
end