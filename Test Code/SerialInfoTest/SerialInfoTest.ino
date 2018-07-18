//Initialization
#define ledPin 13
String vals;

float* parseArray(char strInput[]) {
  const char delim[2] = ":";
  char * strtokIn;
  strtokIn = strtok(strInput, delim);
  if (strcmp(strtokIn, "forward_coeffs") == 0) {
    static float valsNew[17];
    valsNew[0] = 1;
    int i = 1;
    while (strtokIn != NULL) {
      strtokIn = strtok(NULL, delim);
      valsNew[i++] = atof(strtokIn);
    }
    return valsNew;
  } else if (strcmp(strtokIn, "reverse_coeffs") == 0){
    static float valsNew[13];
    valsNew[0] = 2;
    int i =1;
    while (strtokIn != NULL) {
      strtokIn = strtok(NULL, delim);
      valsNew[i++] = atof(strtokIn);
    }
    return valsNew;
  }
}



void setup() {
  // put your setup code here, to run once:
  pinMode(ledPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  vals = Serial.readString();
  float valsNew;

  if (vals != NULL) {
    char inputArray[vals.length() + 1];
    vals.toCharArray(inputArray, vals.length() + 1);
    float *forward_coeffs = parseArray(inputArray);
    float *reverse_coeffs = parseArray(inputArray);
    for (int i=0; i<=15; i++){
      Serial.println(*(forward_coeffs + (i+1)), 4);
    }
    for (int i=0; i<=11; i++){
      Serial.println(*(reverse_coeffs + (i+1)), 4);
    }
    /*
    Serial.println(*(forward_coeffs + 1), 4);
    Serial.println(*(forward_coeffs + 2), 4);
    Serial.println(*(forward_coeffs + 3), 4);
    Serial.println(*(forward_coeffs + 4), 4);*/
    //numberOfElements = (sizeof(*received) / sizeof(*received
    //for (int i = 0; i<=3; i++){
      //Serial.println(*(received + (i+1)));
    //}

    /*if (*received == 1) {
      for (int i = 0; i <= 3; i++) {
        digitalWrite(ledPin, HIGH);
        delay(1000);
        digitalWrite(ledPin, LOW);
        delay(1000);
      }
    }*/
  }
}

