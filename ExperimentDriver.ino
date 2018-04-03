#define xPulse 9
#define xDir 8

#define yPulse 11
#define yDir 10

#define xMin 0
#define xMax 2
#define yMin 3
#define yMax 4

#define max(a,b) \
  ({ __typeof__ (a) _a = (a); \
      __typeof__ (b) _b = (b); \
    _a > _b ? _a : _b; })

#define min(a,b) \
  ({ __typeof__ (a) _a = (a); \
      __typeof__ (b) _b = (b); \
    _a < _b ? _a : _b; })

long delay_Micros =1200; // Set value

long currentMicros = 0; long previousMicros = 0;
int direction = 1;
int microsteps = 16;

// Set up Parameters
int rot = 1600;
int vel = 80;

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
  
  digitalWrite(yDir,direction);
  digitalWrite(xDir,direction);
  Serial.begin(9600);
  Serial.println('a');
  char a = 'b';
  while (a != 'a')
  {
    a = Serial.read();
  }
  //Serial.println(digitalRead(xMax));
  //Serial.println("what");
  //recalibrate();
  //line(0,0,50000,50000);
  
}

int circ_center = 5000;
int circ_radius = 2000;
int val = 0;

void loop()
{
  if(Serial.read()=='9') {
    val = Serial.read();
    findCenter();
  }
//  //makeSinusoid();
//  recalibrate_y(yMin);
//  recalibrate_x(xMin);
//  delay(1000);
//  line(0,0,circ_center,circ_center);
//  line(0,0,(int) circ_radius/2,0);
//  drawCircle(circ_radius);
////  makeCircle(circ_center, circ_radius);
//  delay(2000);
//  
//  recalibrate_x(xMax);
//  recalibrate_y(yMin);
//  delay(1000);
//  line(0,0,-circ_center,circ_center);
//  line(0,0,(int) circ_radius/2,0);
//  drawCircle(circ_radius);
//  delay(2000);
//
//  recalibrate_y(yMax);
//  recalibrate_x(xMax);
//  delay(1000);
//  line(0,0,-circ_center,-circ_center);
//  line(0,0,(int) circ_radius/2,0);
//  drawCircle(circ_radius);
//  delay(2000);
//
//  recalibrate_x(xMin);
//  recalibrate_y(yMax);
//  delay(1000);
//  line(0,0,circ_center,-circ_center);
//  line(0,0,(int) circ_radius/2,0);
//  drawCircle(circ_radius);
//  delay(2000);
}

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

    line(0,0,0,(int) a - store_a);
    line(0,0,(int) b - store_b,0);
    
    store_a = (int) a;
    store_b = (int) b;
  }
}


void findCenter() {
  recalibrate_x(xMax);
  int a = recalibrate_x(xMin);
  recalibrate_y(yMax);
  int b = recalibrate_y(yMin);
  Serial.println(a);
  Serial.println(b);
  for(int i = 0; i<microsteps; i++) {
    line(0,0,(int) a/2, (int) b/2);
  }
//  for(int i = 0; i<microsteps; i++) {
//    line(0,0,(int)4186/2,0);
//    delay(1000);
//  }
  
}

void xMove(int steps, bool direction, int speed){
  digitalWrite(xDir,direction);
  //int microDelay = (int) rot/speed;
  for(int i = 1; i<=steps; i++) {
    digitalWrite(xPulse, HIGH);
    delayMicroseconds(speed);
    digitalWrite(xPulse, LOW);
    delayMicroseconds(speed);
//    if(i%10==0) {
//      digitalRead(Stop);
//    }
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
//    if(i%10==0) {
//      digitalRead(Stop);
//    }
  }
}

int recalibrate_x(int pin) {
  delay(1000);
  int steps = 0;
  int val = digitalRead(pin);
  while(val) {
    if(pin==0) {
      xMove(microsteps,0,vel);
    } else {
      xMove(microsteps,1,vel);
    }
    steps+=1;
    val = digitalRead(pin);
    if(val==0) {
      while(val==0) {
        if(pin==0) {
          xMove(microsteps,1,vel);
          delay(200);
        } else {
          xMove(microsteps,0,vel);
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

int recalibrate_y(int pin) {
  delay(1000);
  int steps = 0;
  int val = digitalRead(pin);
  //Serial.println(val);
  while(val) {
    if(pin==2) {
      yMove(microsteps,0,vel);
    } else {
      yMove(microsteps,1,vel);
    }
    steps+=1;
    
    val = digitalRead(pin);
    if(val==0) {
      while(val==0) {
        if(pin==2) {
          yMove(microsteps,1,vel);
          delay(200);
        } else {
          yMove(microsteps,0,vel);
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

void line(int x0, int y0, int x1, int y1) {     /// Bresenham's Line Algorithm
 int md1, md2, s_s1, s_s2, ox, oy;
 int dx = abs(x1-x0), sx = x0< x1 ? 1 : -1;
 int dy = abs(y1-y0), sy = y0< y1 ? 1 : -1;
 int err = (dx>dy ? dx : -dy)/2, e2; 
 for(;;){    
   if (x0==x1 && y0==y1) break;
   e2 = err;
   if (e2 >-dx) { 
     err -= dy; 
     x0 += sx;
     //Serial.println(x0);
     xMove(1,max(sx,0),vel);
   }    
   if (e2 < dy) { 
     err += dx; 
     y0 += sy; 
     yMove(1,max(sy,0),vel);
   }
 }
}

