%Link: https://la.mathworks.com/help/supportpkg/arduinoio/getting-started-with-matlab-support-package-for-arduino-hardware.html

%Step 1: Instalar Support Package for Arduino Hardware
%HOME > Add-Ons > Get Hardware Support Packages
%Procurar e instalar "Support Package for Arduino Hardware"

%Step 2: Conectar o arduino e descobrir a porta em que esta conectado
%Meu Computador > right click > Gerenciar > Gerenciador de Dispositivos 
%> Portas
%Verificar a porta com o dispositivo equivalente

%Step 3: Encontrar o tipo de placa 
%Desnecess�rio j� que estamos utilizando um arduino oficial.
%Currently the MATLAB� Support Package for Arduino� Hardware supports 
%Arduino Uno, Mega2560, and Due boards. 
%If you are using unofficial clone boards, refer to the product documentation 
%for the board name you can use. For example, you can specify Uno for a SparkFun Redboard.

%Step 4: Seguir para o codigo abaixo

%Connect to an official Arduino hardware.
%a = 
%
% arduino with properties:
%
%                    Port: 'COM25'
%                   Board: 'Uno'
%     AvailableAnalogPins: [0 1 2 3 4 5]
%    AvailableDigitalPins: [2 3 4 5 6 7 8 9 10 11 12 13]
%               Libraries: {'I2C'  'SPI'  'Servo'}
               
%If you are using an unofficial (clone) Arduino hardware, specify port and board name to establish connection.
%a = arduino('COM3','Uno')

 %If you have more than one Arduino board connected, specify the port and board type.
 %  Port: 'COM3'
 %
 %  clear a;
 %  a = arduino('COM4', 'Uno');
 %
 
 %servo                     Connection to servo motor on Arduino hardware
 %readPosition              Read servo motor position
 %writePosition             Write position of servo motor

a = arduino();

%clear a;
%a = arduino('COM4', 'Uno', 'Libraries', 'Servo');

%Create a Servo object.
%s = 
%  Servo with properties:
%                Pins: D4
%    MinPulseDuration: 5.44e-04 (s)
%    MaxPulseDuration: 2.40e-03 (s)

s = servo(a, 'D4')

%Check your servo motor's data sheet pulse width range values to calibrate 
%the motor to rotate in expected range. This example uses 700*10^-6 and 2300*10^-6 
%for the motor to move from 0 to 180 degrees.
%s = 
%  Servo with properties
%                Pins: D4
%    MinPulseDuration: 7.00e-04 (s)
%    MaxPulseDuration: 2.30e-03 (s)

%clear s;
%s = servo(a, 'D4', 'MinPulseDuration', 700*10^-6, 'MaxPulseDuration', 2300*10^-6)

angle = 0;
writePosition(s, angle);
current_pos = readPosition(s);
current_pos = current_pos*180;
fprintf('Current motor position is %d degrees\n', current_pos);
pause(2);

clear s a
