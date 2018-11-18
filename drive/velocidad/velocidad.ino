#include <ax12.h>
#include <BioloidController.h>

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
delay(3000);

ax12SetRegister2(2,AX_TORQUE_LIMIT_L,500);
delay(1000);
ax12SetRegister2(2,32,50);
delay(1000);

SetPosition(2,300);
delay(4000);
SetPosition(2,512);

}

void loop()
{

}
