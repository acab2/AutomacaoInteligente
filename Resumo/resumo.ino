#include <ax12.h>
#include <BioloidController.h>

  /* Modificar o ID do servomotor
  ax12SetRegister(IDAtual, registradorEspecificoDoHardware, novoID)
  ax12SetRegister(10, 3, 1);
    Retorna o ID do servomotor
  ax12GetRegister(IDAtual, registradorEspecificoDoHardware, byteSize)
  int newID = -1;
  newID = ax12GetRegister(1, 3, 1);
  
  Inicializar o Serial
  Serial.begin(9600);
  delay(5000);
  Serial.println(newID);
  
  Mover a garra
  ax12SetRegister(5,30,0);
  delay(2000);
  ax12SetRegister(5,30,512);
  delay(2000);
  ax12SetRegister(5,30,1023);
  delay(2000);
  
  Setar uma posição para o servomotor especifico
  SetPosition(ID, position);
  SetPosition(2, 512);
  
  Setar o BroadcastingID... modifica todos os servomotores de uma vez
  SetPosition(254, 0);
  
  int torqueVal = -1;
  int motorPos = -1;
  
  turn off torque
  // AX_TORQUE_ENABLE = 24  
  ax12SetRegister(1, AX_TORQUE_ENABLE, 0);
  delay(25);
  
  return torqueData
  ax12GetRegister(ID, AX_TORQUE_ENABLE, byteSize);
  
  torqueVal = ax12GetRegister(1, AX_TORQUE_ENABLE, 1);
  delay(25);
  
  turn on LED if torque is off
  if(torqueVal == 0){
    // AX_LED = 25
    ax12SetRegister(1,AX_LED, 1);
    Serial.println("The LED should be ON");
  }else{
      ax12SetRegister(1,AX_LED, 0);
      Serial.println("The LED should be OFF");
  }
  
  get the motor position
  // AX_PRESENT_POSITION_L = 36
  motorPos = ax12GetRegister(1, AX_PRESENT_POSITION_L, 2);
  delay(1500);
  
  set torque
  //AX_TORQUE_LIMIT_L = 34 | Value = 0~1023
  ax12SetRegister2 (ID, AX_TORQUE_LIMIT_L, value);
  ax12SetRegister2 (2, AX_TORQUE_LIMIT_L, 50);
  delay(25);
  
  WheelMode
  //AX_CCW_ANGLE_LIMIT_L = 3
  ax12SetRegister2(ID, AX_CCW_ANGLE_LIMIT_L, 0);  
  */

void setup(){
            //entradas = id, position(0-1023), 
  Setposition (1,0);
  Setposition (2,0);
  Setposition (3,0);
  Setposition (4,0);
  Setposition (5,0);
  
}

voi loop(){
  
  delay(2500);
  
  
}
