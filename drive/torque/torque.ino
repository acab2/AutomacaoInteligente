#include <ax12.h>
#include <BioloidController.h>

int torqueval = -1;
int motorpos = -1;

// Levar de grau para posição
int degree2pos(int degree)
{
  if (degree<-150)
    degree = -150;
  if (degree>150)
    degree = 150;
    
  int pos = (int)(1023*(float(degree+150)/(300.0)));
  
  return pos;
}

void setup()
{
SetPosition(1,degree2pos(0));
SetPosition(2,degree2pos(0));
SetPosition(3,degree2pos(0));
SetPosition(4,degree2pos(0));
SetPosition(5,degree2pos(0));

Serial.begin(9600);
delay(3000);

ax12SetRegister(3,AX_TORQUE_ENABLE,0);
delay(25);
torqueval = ax12GetRegister(3,AX_TORQUE_ENABLE,1);
delay(25);

if (torqueval==0)
{
 ax12SetRegister(3,AX_LED,1);
 Serial.println("Led On");
}

}

void loop()
{
Serial.print("Position: ");
motorpos = ax12GetRegister(3,AX_PRESENT_POSITION_L,2);
Serial.println(motorpos);
delay(1500);
}
