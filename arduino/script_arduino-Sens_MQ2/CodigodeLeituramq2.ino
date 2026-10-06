const int PINO_SENSOR_MQ2 = A0;

const int VALOR_MINIMO = 100;
const int VALOR_MAXIMO = 1000;



void setup() {
  Serial.begin(9600);


}

void loop() {
  int valorSensor = analogRead(PINO_SENSOR_MQ2);

  //float ppm = 574.25 * pow((5.0 * (1023.0 - valorSensor) / max(valorSensor, 1)) / R0, -2.222);

  const float R0 = 10.0 //(5.0 * (1023.0 - valorSensor) / valorSensor) / 9.83

  float porcentagem = ((float)(valorSensor - VALOR_MINIMO) / (VALOR_MAXIMO - VALOR_MINIMO)) * 100;
  
  if (porcentagem < 0) {
    porcentagem = 0;
  }else if (porcentagem > 100){
    porcentagem = 100;
  }

 // Serial.print("Valor de Saída do Sensor: ");
 // Serial.print(valorSensor);
 // Serial.print(" -> Porcentagem: ");
 //Serial.println(porcentagem);
 //Serial.println("%");
   Serial.println(ppm);


  delay(1000);

}
