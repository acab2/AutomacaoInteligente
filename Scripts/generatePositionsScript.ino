#include <ax12.h>
#include <BioloidController.h>
#include <time.h>
#include <stdlib.h>

void setup(){
  FILE *pont_arq;
  pont_arq = fopen("arquivo.txt", "a");
  
  if(pont_arq == NULL){
    printf("Erro na abertura do arquivo!");
  }
  
  Serial.begin(9600);
  delay(5000);
  
  srand(time(NULL));
  
  int i, n, pos, posicoes[5];
  for(i = 0; i<2000; i++){
    for(n = 1; n<=5; n++){
      pos = rand()%1023;
      SetPosition(n, pos);
      posicoes[n-1] = pos;
    }
    fprintf(pont_arq, "(%d, %d, %d, %d, %d)\n", posicoes[0],posicoes[1],posicoes[2],posicoes[3],posicoes[4]);
    delay(2500);
  }
  
  
  fclose(pont_arq);
}

void loop(){

}
