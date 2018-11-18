#include <ax12.h>
#include <BioloidController.h>

// ID servos
#define garra 5
#define pulso 4
#define cotovelo 3
#define ombro2 2
#define ombro1 1

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

delay(1000);
ax12SetRegister2(3,32,50);
delay(1000);
ax12SetRegister2(2,32,50);
delay(1000);
ax12SetRegister2(4,32,50);
delay(1000);
ax12SetRegister2(1,32,50);
delay(1000);
}

void loop()
{

SetPosition(2,degree2pos(45));
SetPosition(3,degree2pos(-45));
SetPosition(4,degree2pos(90));

delay(4000);
SetPosition(1,degree2pos(-90));
delay(4000);
for(int i=0;i<2;i++){
SetPosition(garra,degree2pos(-100));
delay(1500);
SetPosition(garra,degree2pos(0));
delay(1500);
}
SetPosition(2,degree2pos(0));
SetPosition(3,degree2pos(0));
SetPosition(4,degree2pos(0));
SetPosition(1,degree2pos(0));
delay(4000);
}
