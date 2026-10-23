const int PINO_SENSOR_MQ2 = A0;

const int VALOR_MINIMO = 0;
const int VALOR_MAXIMO = 1000;

const float PPM_MINIMO = 0;
const float PPM_MAXIMO = 2000;

// Limites de estado (ppm)
const float PPM_NORMAL_MAXIMO = 300;   // até 300: normal
const float PPM_CRITICO = 1000;        // a partir de 1000: crítico

int valorAnterior = 0;

float calcularPpm(int valorSensor) {
  int valorLimitado = constrain(valorSensor, VALOR_MINIMO, VALOR_MAXIMO);
  float proporcao = (float)(valorLimitado - VALOR_MINIMO) / (VALOR_MAXIMO - VALOR_MINIMO);
  return PPM_MINIMO + proporcao * (PPM_MAXIMO - PPM_MINIMO);
}

const char* classificarEstado(float ppm) {
  if (ppm >= PPM_CRITICO) {
    return "CRITICO";
  } else if (ppm > PPM_NORMAL_MAXIMO) {
    return "RISCO";
  }
  return "NORMAL";
}

void setup() {
  Serial.begin(9600);
  Serial.println("=== Monitoramento de gás Ativado ===");
}

void loop() {
  int valorSensor = analogRead(PINO_SENSOR_MQ2);
  int ppm = calcularPpm(valorSensor);

  //Serial.print("Bruto: ");
  //Serial.print(valorSensor);
  //Serial.print(" (variacao: ");
  //Serial.print(valorSensor - valorAnterior);
  //Serial.print(") -> ");
  Serial.print(ppm, 1);
  //Serial.print(" ppm -> Estado: ");
  Serial.print(";");
  Serial.println(classificarEstado(ppm));

  valorAnterior = valorSensor;
  delay(500);
}