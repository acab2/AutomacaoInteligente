#include <ax12.h>
#include <BioloidController.h>

void setup(){
  //Inicializando o Serial
  Serial.begin(9600);
  delay(5000);
  
  //desligando o torque de todos os servomotores de uma vez
  ax12SetRegister(254, AX_TORQUE_ENABLE, 0);
  delay(25);
  
  int n;
  for(n = 1; n <= 5; n++){
    if(ax12GetRegister(n, AX_TORQUE_ENABLE, 1) == 0){
      //ligando os LEDs
      ax12SetRegister(n,AX_LED, 1);
    }else{
      //desligando os LEDs
      ax12SetRegister(n,AX_LED, 0);
    }
  }  
}

void loop(){
  for(n = 1; n <= 5; n++){
    Serial.print("ID: %d Position: ", n)
    Serial.println(ax12GetRegister(n, AX_PRESENT_POSITION_L, 2));  
  }
  delay(2000);
  
  
}
