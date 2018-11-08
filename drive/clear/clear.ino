#include <ax12.h>
#include <BioloidController.h>

void setup()
{
  
SetPosition(1,512);
SetPosition(2,512);
SetPosition(3,512);
SetPosition(4,512);
SetPosition(5,512);

delay(5000);

ax12SetRegister(1,AX_TORQUE_ENABLE,0);
ax12SetRegister(2,AX_TORQUE_ENABLE,0);
ax12SetRegister(3,AX_TORQUE_ENABLE,0);
ax12SetRegister(4,AX_TORQUE_ENABLE,0);
ax12SetRegister(5,AX_TORQUE_ENABLE,0);

ax12SetRegister(1,AX_LED,0);
ax12SetRegister(2,AX_LED,0);
ax12SetRegister(3,AX_LED,0);
ax12SetRegister(4,AX_LED,0);
ax12SetRegister(5,AX_LED,0);

}

void loop(){}
