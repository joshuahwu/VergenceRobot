#include <stdio.h>
#define xPulse 8
#define xDir 9

#define yPulse 10
#define yDir 11

#define xMin 2
#define xMax 3
#define yMin 4
#define yMax 5
#define RED 48
#define BLUE 49
#define GREEN 50

int direction = 1; /*viewing from behind of motor, 1 = clockwise*/
unsigned long microsteps = 16; /*divides the steps per revolution by this number*/
int b[2];
int bstore[2];
unsigned long dimensions[2]={30000*microsteps,30000*microsteps};
unsigned long location[2]={0,0};
int virtDimX = 100;
int virtDimY = 50;

int rot = 1600;
int vel = 80;
String val;

/* Parses command received from Serial Connection and return designated inputs */
double* parseCommand(char strCommand[]) {
  const char delim[2] = ":";
  char *fstr;
  fstr = strtok(strCommand,delim);
  if (strcmp(fstr,"calibrate")==0) {
    /* Calibrate
     * No inputs
     */
    static double j[1];
    j[0]=1;
    return j;
    
  } else if (strcmp(fstr,"move")==0) {
    /* Move to specific coordinate
     * Inputs
     * (x0,y0) - destination coordinates in designated coordinate system
     * hold - hold target at (x0,y0) for milliseconds
     */
    static double j[4];
    j[0] = 2;
    int i = 1;
    while(fstr!=NULL) {
      fstr=strtok(NULL,delim);
      j[i++]=atof(fstr);
    }
    return j;
  } else if (strcmp(fstr,"oscillate")==0) {
    /* Oscillate between two specific coordinates
     * (x0,y0) and (x1,y1) - coordinates to move between in designated coordinate system
     * Speed - delayMicroseconds between pulses
     * Repetitions - Number of times to oscillate
     * Resolution - Resolution of pathway stepsize
     */
    static double j[8];
    j[0]=3;
    int i = 1;
    while(fstr!=NULL) {
      fstr=strtok(NULL,delim);
      j[i++]=atof(fstr);
    }
    return j;
  } else {
    /* Else return empty array */
    static double j[1];
    j[0]=10000;
    //Serial.println(j);
    return j;
  }
}

/* Moves to xMax then xMin and counts the number of steps it took.
 * Does the same in the y-direction
 * Returns the number of steps
 * Ends at (xMin, yMin)
 */
int* findDimensions() {
  recalibrate(xMax);
  int a = recalibrate(xMin);
  recalibrate(yMax);
  int b = recalibrate(yMin);
  static int i[2] = {a,b};
  return i;
}

/* Moves target to specified edge (xMax, xMin, yMax, yMin)
 * Standardizes edge as the point when the microswitch is just released.
 * Returns number of steps it took to get there
 */
unsigned long recalibrate(int pin) {
  delay(1000);
  unsigned long steps = 0;
  int val = digitalRead(pin);
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
    
    
    if(steps>(long) dimensions[1]*1.2) {
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

/* Implementation of Bresenham's Algorithm for a line 
 * Input vector (in number of steps) along with pulse width
 * Proprioceptive location
 */
void line(long x1, long y1, int v) {
  location[0]+=x1;
  location[1]+=y1;
  long x0 = 0, y0 = 0;
  long md1, md2, s_s1, s_s2, ox, oy;
  long dx = abs(x1-x0), sx = x0< x1 ? 1 : -1;
  long dy = abs(y1-y0), sy = y0< y1 ? 1 : -1;
  long err = (dx>dy ? dx : -dy)/2, e2; 
  digitalWrite(xDir,(sx+1)/2);
  digitalWrite(yDir,(sy+1)/2);
  for(;;){    
    if (x0==x1 && y0==y1) break;
    e2 = err;
    if (e2 >-dx) { 
      err -= dy; 
      x0 += sx;
      digitalWrite(xPulse, HIGH);
      if (e2<dy) {
        err += dx; 
        y0 += sy;
        digitalWrite(yPulse, HIGH);
        delayMicroseconds(v);
        digitalWrite(xPulse, LOW);
        digitalWrite(yPulse, LOW);
        delayMicroseconds(v);
      } else {
        delayMicroseconds(v);
        digitalWrite(xPulse, LOW);
        delayMicroseconds(v);
      }
    } else if (e2<dy) {
        err += dx;
        y0 += sy;
        digitalWrite(yPulse, HIGH);
        delayMicroseconds(v);
        digitalWrite(yPulse, LOW);
        delayMicroseconds(v);
    } else {
    }
  }
}


/* Main setup function
 * Verifies serial connection and traces edges for dimensions
 */
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

  /* Communcates with Serial connection to verify */
  Serial.println("Type the letter a and hit enter");
  char serialInit = 'b';
  while (serialInit != 'a')
  {
    serialInit = Serial.read();
  }
  Serial.println("Ready");

  /* Determines dimensions */
  int *i = findDimensions();
  /* Scales dimensions to be in terms of microsteps*/
  dimensions[0] = *i * microsteps;
  dimensions[1]= *(i+1) * microsteps;
  digitalWrite(GREEN,LOW);
  
}

/* Main looping function
 * Waits for commands from Serial Connection and executes actions
 */
void loop()
{
  Serial.flush();
  long dispx,dispy;
  int xErr,yErr;
  val = Serial.readString();
  
  /* Execute once there is incoming Serial information
   * Parse incoming command from Serial connection
   */
  if(val!= NULL) {
    char inputArray[val.length()+1];
    val.toCharArray(inputArray,val.length()+1);
    double *command = parseCommand(inputArray);
    switch ((int) *command) {
      case 1: // Calibrate
        /* Calibrates to xMin and yMin and updates location to (0,0) */
        digitalWrite(GREEN,HIGH);
        xErr = recalibrate(xMin);
        yErr = recalibrate(yMin);
        location[0] = 0;
        location[1] = 0;
        Serial.println("Done");
        delay(1000);
        digitalWrite(GREEN,LOW);
        break;
      case 2:
        /* moveTo
         * Simple move to designated location and holds for a certain time
         */
        dispx = (long) (*(command+1)/virtDimX*dimensions[0])-location[0];
        dispy = (long) (*(command+2)/virtDimY*dimensions[1])-location[1];
        line(dispx,dispy, vel);
        digitalWrite(BLUE,HIGH);
        Serial.println("Done");
        delay(*(command+3));
        digitalWrite(BLUE,LOW);
        break;
      case 3: // Speed
        {
          /* Oscillate
           * Moves to first coordinate and oscillates between that and second coordinate
           * 
           */
          long dx = (long) ((*(command+3)-*(command+1))/virtDimX*dimensions[0]);
          long dy = (long) ((*(command+4)-*(command+2))/virtDimY*dimensions[1]);
          dispx = (long) (*(command+1)/virtDimX*dimensions[0])-location[0];
          dispy = (long) (*(command+2)/virtDimY*dimensions[1])-location[1];
          line(dispx,dispy,vel);
          digitalWrite(RED,HIGH);
          delay(1000);
          int maxSpeed = *(command+5);
          int delta = *(command+7);
          long store_a = -dx/2;
          long store_b = -dy/2;
          int f = 3;
          int minSpeed = 60;
          int dv = minSpeed-maxSpeed;
          long dtx = (long) dx/(5*dv);
          long dty = (long) dy/(5*dv);
          
          for(int j=1; j<=*(command+6); j++) {
            /* Speeds up in first 10% */
            for(int i=0; i<(int)dv/2;i++) {
              int a = minSpeed-i*2;       
              line(dtx,dty,a);
            }
            
            /* Moves 80% */
            line((long) dx*0.8,(long) dy*0.8,maxSpeed);
            
            /* Slows down end 10% */
            for(int i=0; i<(int)dv/2;i++) {
              int a = maxSpeed+i*2;       
              line(dtx,dty,a);
            }

            /* Speeds up end 10% back */
            for(int i=0; i<(int)dv/2;i++) {
              int a = minSpeed-i*2;       
              line(-dtx,-dty,a);
            }

            /* Moves 80% back */
            line((long) -dx*0.8,(long) -dy*0.8,maxSpeed);

            /* Slows down end 10% back*/
            for(int i=0; i<(int) dv/2;i++) {
              int a = maxSpeed+i*2;       
              line(-dtx,-dty,a);
            }
          }
          digitalWrite(RED,LOW);
          Serial.println("Done");
          delay(2000);
        }
        break;
      case 4:
      /* Speed Trials
       * Still needs testing
       */
        unsigned long speedRuns[49];
        for(int j = 6;j<=102;j+=2) {
          recalibrate(xMin);
          recalibrate(yMin);
          delay(1000);
          int maxSpeed = j;
          long startTime = millis();
          line(1000*microsteps,10000*microsteps,maxSpeed);
          //Serial.println(location[0]);
          //Serial.println(location[1]);
          long endTime = millis();
          int index = (int) (j/2) - 3;
          speedRuns[(int)j/2-3] = endTime-startTime;
          delay(2000);
        }   
        break;
    }
  } else {
    //Serial.println("No Input");
  }
}


