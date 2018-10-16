#include <stdio.h>
#define xPulse 9
#define xDir 8

#define yPulse 11
#define yDir 10

#define xMin 5
#define xMax 2
#define yMin 3
#define yMax 4
#define RED 7
#define BLUE 13
#define GREEN 12

//#define max(a,b) \
//  ({ __typeof__ (a) _a = (a); \
//      __typeof__ (b) _b = (b); \
//    _a > _b ? _a : _b; })
//
//#define min(a,b) \
//  ({ __typeof__ (a) _a = (a); \
//      __typeof__ (b) _b = (b); \
//    _a < _b ? _a : _b; })

int direction = 1;
unsigned long microsteps = 16;
int b[2];
int bstore[2];
unsigned long dimensions[2]={1638*microsteps,2092*microsteps};
unsigned long location[2]={0,0};
int virtDim = 100;

// Set up Parameters
int rot = 1600;
int vel = 80;
int circ_center = 5000;
int circ_radius = 2000;
String val;

//void initialize() {
//  Serial.println('a');
//  char a = 'b';
//  while (a != 'a')
//  {
//    a = Serial.read();
//  }
//}

double* parseCommand(char strCommand[]) {
  const char delim[2] = ":";
  char *fstr;
  fstr = strtok(strCommand,delim);
  //Serial.println(fstr);
  if (strcmp(fstr,"Calibrate")==0) {
    static double j[1];
    j[0]=1;
    //Serial.println(j);
    return j;
  } else if (strcmp(fstr,"Saccade")==0) {
    static double j[4];
    j[0] = 2;
    int i = 1;
    while(fstr!=NULL) {
      fstr=strtok(NULL,delim);
      j[i++]=atof(fstr);
    }
    return j;
  } else if (strcmp(fstr,"Smooth")==0) {
    static double j[7];
    j[0]=3;
    int i = 1;
    while(fstr!=NULL) {
      fstr=strtok(NULL,delim);
      j[i++]=atof(fstr);
    }
    return j;
  } else {
    static double j[1];
    j[0]=4;
    //Serial.println(j);
    return j;
  }
}

//float speedCalc(int vel) {
//  return Math.exp((10.438-vel)/0.73+rotationalVel*1.8*Math.pi/180)
//}

void drawCircle(int radius) {
  int store_a = 9;
  int store_b = (int) 0.99999*radius;
  for(int i = 1; i<(int)2*3.14159*500; i++) {
    int a = (int) radius*sin((float)i/500);
    int b = (int) radius*cos((float)i/500);
    //if(i==1) {
    //  Serial.println(a);
    //  Serial.println(b);
    //}

    line(0,(int) a - store_a,vel);
    line((int) b - store_b,0,vel);
    
    store_a = (int) a;
    store_b = (int) b;
  }
}

int* findDimensions() {
  recalibrate(xMax);
  int a = recalibrate(xMin);
  recalibrate(yMax);
  int b = recalibrate(yMin);
  //Serial.println(a);
  //Serial.println(b);
  //for(int i = 0; i<microsteps; i++) {
  //  line((int) a/2, (int) b/2);
  //}
  static int i[2] = {a,b};
  return i;
}

void xMove(int steps, bool direction, int speed){
  digitalWrite(xDir,direction);
  //int microDelay = (int) rot/speed;
  for(int i = 1; i<=steps; i++) {
    digitalWrite(xPulse, HIGH);
    delayMicroseconds(speed);
    digitalWrite(xPulse, LOW);
    delayMicroseconds(speed);
  }
}

void yMove(int steps, bool direction, int speed) {
  digitalWrite(yDir,direction);
  //int microDelay = (int) rot/speed;
  for(int i = 1; i<=steps; i++) {
    digitalWrite(yPulse, HIGH);
    delayMicroseconds(speed);
    digitalWrite(yPulse, LOW);
    delayMicroseconds(speed);
  }
}

unsigned long recalibrate(int pin) {
  delay(1000);
  unsigned long steps = 0;
  int val = digitalRead(pin);
  //Serial.println(val);
  while(val) {
    if(pin==xMin) {
      line(-microsteps*10,0,vel);
    } else if(pin==xMax) {
      line(microsteps*10,0,vel);
    } else if(pin==yMin) {
      line(0,-microsteps*10,vel);
    } else if(pin==yMax){
      line(0,microsteps*10,vel);
    }
    steps+=10;
    if(steps>2500) {
      Serial.end();
      break;
    }
    
    val = digitalRead(pin);
    if(val==0) {
      while(val==0) {
        if(pin==xMin) {
          line(microsteps,0,vel);
          location[0]=0;
          delay(200);
        } else if(pin==xMax) {
          line(-microsteps,0,vel);
          location[0]=dimensions[0];
          delay(200);
        } else if(pin==yMin) {
          line(0,microsteps,vel);
          location[1]=0;
          delay(200);
        } else if(pin==yMax){
          line(0,-microsteps,vel);
          location[1]=dimensions[1];
          delay(200);
        } 
        val = digitalRead(pin);
        steps-=1;
      }
      break;
    }
  }
  return steps;
}

void line(long x1, long y1, int v) {     /// Bresenham's Line Algorithm
  //for(int i = 0; i<stepsize;i++) {
  location[0]+=x1;
  location[1]+=y1;
  //Serial.println(x1);
  //Serial.println(y1);
  long x0 = 0, y0=0;
  long md1, md2, s_s1, s_s2, ox, oy;
  long dx = abs(x1-x0), sx = x0< x1 ? 1 : -1;
  long dy = abs(y1-y0), sy = y0< y1 ? 1 : -1;
  long err = (dx>dy ? dx : -dy)/2, e2; 
  for(;;){    
    if (x0==x1 && y0==y1) break;
    e2 = err;
    if (e2 >-dx) { 
      err -= dy; 
      x0 += sx;
      digitalWrite(xDir,(sx+1)/2);
      digitalWrite(xPulse, HIGH);
      delayMicroseconds(v);
      digitalWrite(xPulse, LOW);
      delayMicroseconds(v);
      //Serial.println(x0);
//        /xMove(1,max(sx,0),v);
    }    
    if (e2 < dy) { 
      //yMove(1,max(sy,0),v);
      err += dx; 
      y0 += sy;
      digitalWrite(yDir,(sy+1)/2);
      digitalWrite(yPulse, HIGH);
      delayMicroseconds(v);
      digitalWrite(yPulse, LOW);
      delayMicroseconds(v);
    }
  }
}

void setup()
{
  pinMode(xPulse,OUTPUT);
  pinMode(xDir,OUTPUT);
  pinMode(yPulse,OUTPUT);
  pinMode(yDir,OUTPUT);
  pinMode(xMin,INPUT);
  pinMode(xMax,INPUT);
  pinMode(yMin,INPUT);
  pinMode(yMax,INPUT);
  digitalWrite(xMin,HIGH);
  digitalWrite(xMax,HIGH);
  digitalWrite(yMin,HIGH);
  digitalWrite(yMax,HIGH);
  pinMode(RED,OUTPUT);
  pinMode(GREEN,OUTPUT);
  pinMode(BLUE,OUTPUT);
  digitalWrite(RED,LOW);
  digitalWrite(BLUE,LOW);
  digitalWrite(GREEN,HIGH);
  
  digitalWrite(yDir,direction);
  digitalWrite(xDir,direction);
  Serial.begin(9600);
  Serial.println('a');
  char a = 'b';
  while (a != 'a')
  {
    a = Serial.read();
  }
  int *i = findDimensions();
  dimensions[0] = *i * microsteps;
  dimensions[1]= *(i+1) * microsteps;
  digitalWrite(GREEN,LOW);
  Serial.println(dimensions[0]);
  Serial.println(dimensions[1]);
  //recalibrate_x(xMin);
  //recalibrate_y(yMin);
}
int i = 0;
void loop()
{
  Serial.flush();
  long dispx,dispy;
  int xErr,yErr;
  val = Serial.readString();
  if(val!= NULL) {
    //Serial.println(val);
    char wat[val.length()+1];
    val.toCharArray(wat,val.length()+1);
    double *command = parseCommand(wat);
    Serial.println(*command);
    switch ((int) *command) {
      case 1: // Calibrate
        digitalWrite(GREEN,HIGH);
        xErr = recalibrate(xMin);
        yErr = recalibrate(yMin);
        //Serial.println("Done Calibrate");
        location[0] = 0;
        location[1] = 0;
        Serial.println("Done");
        Serial.println(xErr);
        Serial.println(yErr);
        delay(1000);
        digitalWrite(GREEN,LOW);
        break;
      case 2: // Saccade
        dispx = (long) (*(command+1)/virtDim*dimensions[0])-location[0];
        dispy = (long) (*(command+2)/virtDim*dimensions[1])-location[1];
        //Serial.println(dispx);
        //Serial.println(dispy);
        line(dispx,dispy, vel);
        digitalWrite(BLUE,HIGH);
        //location[0] = *(command+1);
        //location[1] = *(command+2);
        Serial.println("Done");
        delay(*(command+3));
        digitalWrite(BLUE,LOW);
        break;
      case 3: //Speed
        long dx = (long) ((*(command+3)-*(command+1))/virtDim*dimensions[0]);
        long dy = (long) ((*(command+4)-*(command+2))/virtDim*dimensions[1]);
        dispx = (long) (*(command+1)/virtDim*dimensions[0])-location[0];
        dispy = (long) (*(command+2)/virtDim*dimensions[1])-location[1];
        //Serial.println(dispx);
        //Serial.println(dispy);
        //Serial.println(dx);
        //Serial.println(dy);
        line(dispx,dispy,vel);
        //location[0] = *(command+1);
        //location[1] = *(command+2);
        //Serial.println(location[0]);
        //Serial.println(location[1]);
        digitalWrite(RED,HIGH);
        delay(1000);
        int maxSpeed = *(command+5);
        int delta = *(command+6);
        //int dtx = (int) dx/delta;
        //int dty = (int) dy/delta;
        //long store_a = -dx/2;
        //long store_b = -dy/2;
        //int f = 3;
        for(int j = 1;j<=*(command+7);j++) {
          line(dx,dy,maxSpeed);
          line(-dx,-dy,maxSpeed);
          //delay(2000);
        }
//        for(int j=1; j<=*(command+7); j++) {
//          for(int i=1; i<(int)delta/2;i++) {
//  //          int a = (int) -dx/2*sqrt((1+(float)f*f)/(1+(float)f*f*pow(cos(i),2)))*cos(i);
//  //          int b = (int) -dy/2*sqrt((1+(float)f*f)/(1+(float)f*f*pow(cos(i),2)))*cos(i);
//            long a = (long) -dx/2*sin(3.14159/2*cos((float)2*3.14159*i/delta));
//            long b = (long) -dy/2*sin(3.14159/2*cos((float)2*3.14159*i/delta));
//            //long a = (long) -dx/2*cos((float)i/delta);
//            //long b = (long) -dy/2*cos((float)i/delta);
//  
//            line((long)a-store_a,(long)b-store_b,maxSpeed);
//            store_a = (long) a;
//            store_b = (long) b;
//          }
//          delay(500);
//          for(int i = (int) delta/2+1;i<(int)delta;i++) {
//            //          int a = (int) -dx/2*sqrt((1+(float)f*f)/(1+(float)f*f*pow(cos(i),2)))*cos(i);
//  //          int b = (int) -dy/2*sqrt((1+(float)f*f)/(1+(float)f*f*pow(cos(i),2)))*cos(i);
//            long a = (long) -dx/2*sin(3.14159/2*cos((float)2*3.14159*i/delta));
//            long b = (long) -dy/2*sin(3.14159/2*cos((float)2*3.14159*i/delta));
//            //long a = (long) -dx/2*cos((float)i/delta);
//            //long b = (long) -dy/2*cos((float)i/delta);
//  
//            line((long)a-store_a,(long)b-store_b,maxSpeed);
//            store_a = (long) a;
//            store_b = (long) b;
//          }
//          delay(500);
//        }
        //Serial.println(location[0]);
        //Serial.println(location[1]);
        digitalWrite(RED,LOW);
        Serial.println("Done");
        delay(2000);
        break;
    }
  } else {
    //Serial.println("No Input");
  }
}


