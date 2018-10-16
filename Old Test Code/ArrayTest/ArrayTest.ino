String val;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Serial.println("Ready");
}

void loop() {
  val = Serial.readString();
  //Serial.println(val);
  if(val!=NULL) {
    char wat[val.length()+1];
    val.toCharArray(wat,val.length()+1);
    //Serial.println(val.c_str());
    float *command = parseCommand(wat);
    Serial.println(*command);
  } else {
    Serial.println("Bool");
  }
}

float* parseCommand(char strCommand[]) {
  const char delim[2] = ":";
  char *fstr;
  fstr = strtok(strCommand,delim);
  //Serial.println(fstr);
  if (strcmp(fstr,"Calibrate")==0) {
    static float j[1];
    j[0]={1};
    //Serial.println(j[0]);
    return j;
  } else {
    static float j[2];
    j[0]=atof(fstr);
    j[1]={3};
    //Serial.println(j[0]);
    return j;
  }
}

