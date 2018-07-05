#include <stdio.h>

/* Defining Pins */
/*pins for the x-axis stepper motor*/
#define xPulse 8 /*50% duty cycle pulse width modulation*/
#define xDir 9 /*rotation direction*/
/*pins for the y-axis stepper motor*/
#define yPulse 10
#define yDir 11
/*pins for the 4 microswitches*/ 
#define xMin 2
#define xMax 3
#define yMin 4
#define yMax 5
/*pins for LED*/
#define RED 48
#define BLUE 49
#define GREEN 50

/* Defining initial variables and arrays */
int direction = 1; /*viewing from behind motor, with shaft facing away, 1 = clockwise, 0 = counterclockwise*/
unsigned long microsteps = 16; /*divides the steps per revolution by this number, corresponds to microstepping settings on stepper driver*/
unsigned long dimensions[2]={30000*microsteps,30000*microsteps}; /*preallocating dimensions to previously measured values*/
unsigned long location[2]={0,0}; /*presetting location*/
/*arbitrary upper limit for coordinate input, with lower limit of 0*/
int virtDimX = 100; /* max virtual x dimension that can be inputted*/
int virtDimY = 50; /*max virtual y dimension that can be inputted*/

int vel = 80; /*default velocity for calibration and basic movement actions in terms of square pulse width (microseconds)*/
/*delay in microseconds between motors turning on and off*/
String val; /*String object to store inputs read from the Serial Connection*/


/* parseCommand function: Parses command received from Serial Connection and returns designated inputs */
double* parseCommand(char strCommand[]) { /*inputs are null terminated character arrays*/
  const char delim[2] = ":"; /*unchangeable character, 2-element array designating the delimiter as :*/
  char *fstr; /*first string defined as a pointer variable*/ 
  fstr = strtok(strCommand,delim); /*first call: identifies first input of the string*/
  if (strcmp(fstr,"calibrate")==0) { /*implement if first string is "calibrate"*/
    /* Calibrate
     * No numerical inputs
     */
    static double inputs[1]; /*create inputs array with number of elements corresponding to number of inputs*/
    inputs[0]=1; /*set first element in array to 1, switch case for calibrate*/
    return inputs;
    
  } else if (strcmp(fstr,"move")==0) { /*implement if first string is "move"*/
    /* Move to specific coordinate
     * Numerical Inputs:
     * (x0,y0) - destination coordinates in designated coordinate system
     * hold - hold target at (x0,y0) for milliseconds
     * move:x0:y0:hold duration
     */
    static double inputs[4]; 
    inputs[0] = 2; /*set first element in array to 2, switch case for move*/
    int inputs = 1;
    /*assign numerical inputs to spaces in array*/
    while(fstr!=NULL) { /*implement while the first string is not empty*/
      fstr=strtok(NULL,delim); /*subsequent calls: accesses inputs to String object until it reaches null character*/
      /*split entire string into tokens (individual strings), returns pointer to first token*/
      inputs[i++]=atof(fstr); /*converts string to a double and stores in the designated space in the array*/
    }
    return inputs;
    
  } else if (strcmp(fstr,"oscillate")==0) { /*implement if first string is "oscillate"*/
    /* Oscillate between two specific coordinates
     *  Numerical Inputs:
     * (x0,y0) and (x1,y1) - coordinates to move between in designated coordinate system
     * Speed - delayMicroseconds between pulses
     * Repetitions - Number of times to oscillate
     * Resolution - Resolution of pathway stepsize
     * oscillate:x0:y0:x1:y1:speed:repetitions:resolution
     */
    static double inputs[8];
    inputs[0]=3; /*set first element in array to 3, switch case for oscillate*/
    int i = 1;
    /*assign numerical inputs to spaces in array*/
    while(fstr!=NULL) {
      fstr=strtok(NULL,delim);
      inputs[i++]=atof(fstr);
    }
    return inputs;
    
  } else { /*implement in any other case*/
    /* Else return empty array */
    static double j[1];
    j[0]=10000;
    //Serial.println(j);
    return j;
  }
}

/* findDimensions function:
 * Moves to xMax from current location then to xMin and counts the number of steps it took
 * Does the same in the y-direction
 * Returns the number of steps in a 2-element array, x & y dimension
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

/* recalibrate function:
 * Moves target to specified edge (xMax, xMin, yMax, yMin)
 * Standardizes edge as the point when the microswitch is just released.
 * Returns number of steps it took to get there
 * 0 = pressed, 1 = unpressed for pin reads
 */
unsigned long recalibrate(int pin) { /*input is microswitch pin*/
  delay(1000);
  unsigned long steps = 0;
  /*Specific pin recalibration/movement toward that pin*/
  int val = digitalRead(pin); /*read the pin, 0 = pressed, 1 = unpressed*/
  while(val) {
    if(pin==xMin) { 
      line(-microsteps*10,0,vel); /*move in negative x-direction toward xMin*/
    } else if(pin==xMax) { 
      line(microsteps*10,0,vel); /*move in positive x-direction toward xMax*/
    } else if(pin==yMin) { 
      line(0,-microsteps*10,vel); /*move in negative y-direction toward yMin*/
    } else if(pin==yMax){
      line(0,microsteps*10,vel); /*move in positive y-direction toward yMax*/
    }
    steps+=10; /*add 10 to steps counter*/
    
    
    if(steps>(long) dimensions[1]*1.2) { /*if the number of steps is greater than 120% of the number of steps of the y-dimension*/
      Serial.end(); /*end the serial connection*/
      break; /*break out of the loop*/
    }
    
    /*Overshoot adjustment: moves back until pin is just released*/
    val = digitalRead(pin);
    if(val==0) { /*if switch is pressed*/
      while(val==0) { /*while switch is pressed*/
        if(pin==xMin) {
          line(microsteps,0,vel); /*if microswitch is pressed (if value read from pin is 0), away from that pin*/
          location[0]=0; /*update coordinate location*/
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
        val = digitalRead(pin); /*re-read the state of the pin*/
        steps-=1; /*remove one step from total step count, correcting for the overshoot*/
      }
      break; /*when val no longer is 0, switch has just been released, break from the loop*/
    }
  }
  return steps; /*return the number of steps*/ 
}

/* Implementation of Bresenham's Algorithm for a line 
 * Input vector (in number of steps) along with pulse width (velocity/speed)
 * Proprioceptive location
 */
void line(long x1, long y1, int v) { /*inputs: x-component of vector, y-component of vector, speed/pulse width*/
  location[0]+=x1; /*add x1 to current x-coordinate location*/
  location[1]+=y1;
  long x0 = 0, y0 = 0;
  long dx = abs(x1-x0), signx = x0< x1 ? 1 : -1; /*change in x is absolute value of difference between (x1,y1) location and origin*/
  /*if x0 is less than x1, set signx equal to 1; if x0 is not less than x1, set signx equal to -1*/
  /*if x-component of vector (desired x displacement) is positive, signx = 1*/
  long dy = abs(y1-y0), signy = y0< y1 ? 1 : -1; /*same as above in terms of y*/
  long err = (dx>dy ? dx : -dy)/2, e2; /*if dx is greater than dy, set error equal to dx/2; if dx is not greater than dy, set error equal to -dy/2*/
  digitalWrite(xDir,(signx+1)/2); /*setup x motor rotation direction, if signx = 1, direction = 1, rotate clockwise; if signx = -1, direction = 0, rotate counterclockwise*/
  digitalWrite(yDir,(signy+1)/2); 
  for(;;){ /*infinite loop (;;)*/
    if (x0==x1 && y0==y1) break; /*once the desired location is reached, break out of the infinite loop and halt movement*/
    e2 = err; /*to maintain error at start of loop, since error changes in some cases*/
    if (e2 >-dx) { 
      err -= dy; /*subtract dy from the error*/
      x0 += signx; /*add signx (1 or -1) to the x-coordinate location*/
      /*switching from HIGH to LOW represents one cycle of square wave, which corresponds to motor rotation*/
      digitalWrite(xPulse, HIGH); /*half of cycle for x rotation*/
      if (e2<dy) { 
        err += dx; 
        y0 += signy; 
        digitalWrite(yPulse, HIGH); /*half of cycle for y rotation*/
        delayMicroseconds(v);
        digitalWrite(xPulse, LOW); /*full cycle, rotation possible*/
        digitalWrite(yPulse, LOW);
        delayMicroseconds(v);
      } else {
        delayMicroseconds(v);
        digitalWrite(xPulse, LOW);
        delayMicroseconds(v);
      }
    } else if (e2<dy) { 
        err += dx; 
        y0 += signy;
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
{ /*pulse and direction pins for x & y-dimension motors are outputting signal*/
  pinMode(xPulse,OUTPUT);
  pinMode(xDir,OUTPUT);
  pinMode(yPulse,OUTPUT);
  pinMode(yDir,OUTPUT);
  /*microswitch pins are awaiting input signal (pressed or unpressed)*/
  pinMode(xMin,INPUT);
  pinMode(xMax,INPUT);
  pinMode(yMin,INPUT);
  pinMode(yMax,INPUT);
  /*initially set microswitch pins to HIGH (1), indicating unpressed*/
  digitalWrite(xMin,HIGH);
  digitalWrite(xMax,HIGH);
  digitalWrite(yMin,HIGH);
  digitalWrite(yMax,HIGH);
  /*LED pins output*/
  pinMode(RED,OUTPUT);
  pinMode(GREEN,OUTPUT);
  pinMode(BLUE,OUTPUT);
  /*initially, red & blue off, green on*/
  digitalWrite(RED,LOW);
  digitalWrite(BLUE,LOW);
  digitalWrite(GREEN,HIGH);
  digitalWrite(yDir,direction);
  digitalWrite(xDir,direction);
  /*set serial data transmission rate*/
  Serial.begin(9600);

  /* Communicates with Serial connection to verify */
  Serial.println("Type the letter a, then hit enter.");
  char serialInit = 'b';
  while (serialInit != 'a') /*while serialInit does not equal a, which is always since serialInit = b*/
  {
    serialInit = Serial.read(); /*be ready to read incoming serial data*/
  }
  Serial.println("Ready");

  /* Determines dimensions */
  int *i = findDimensions(); /*pointer to the array that contains the x & y-dimensions in terms of steps*/
  /* Scales dimensions to be in terms of microsteps*/
  dimensions[0] = *i * microsteps; /*x-dimension*/
  dimensions[1]= *(i+1) * microsteps; /*y-dimension*/
  digitalWrite(GREEN,LOW); /*turn off green*/
  
}

/* Main looping function
 * Waits for commands from Serial Connection and executes actions
 */
void loop()
{
  Serial.flush();
  long dispx,dispy;
  int xErr,yErr;
  val = Serial.readString(); /*read characters from input into a String object*/
  
  /* Execute once there is incoming Serial information
   * Parse incoming command from Serial connection
   */
  if(val!= NULL) { /*if val is not empty*/
    char inputArray[val.length()+1]; /*create an array the size of val string +1*/
    val.toCharArray(inputArray,val.length()+1); /*convert val from String object to null terminated character array*/
    double *command = parseCommand(inputArray); /*create pointer variable to parsed commands*/
    switch ((int) *command) { /*switch case based on first command*/
      case 1: // calibrate
        /* Calibrates to xMin and yMin and updates location to (0,0) */
        digitalWrite(GREEN,HIGH);
        xErr = recalibrate(xMin); /*xErr is number of steps from initial x-coordinate location to 0*/
        yErr = recalibrate(yMin); 
        location[0] = 0;
        location[1] = 0;
        Serial.println("Done");
        delay(1000);
        digitalWrite(GREEN,LOW);
        break;
      case 2: // move:x0:y0:hold duration
        /* Simple move to designated location and holds for a certain time
         */
        dispx = (long) (*(command+1)/virtDimX*dimensions[0])-location[0]; /* Converting input virtual dimensions to microsteps*/
        dispy = (long) (*(command+2)/virtDimY*dimensions[1])-location[1];
        /*move by designated vector displacement*/
        line(dispx, dispy, vel);
        digitalWrite(BLUE,HIGH);
        Serial.println("Done");
        delay(*(command+3)); /*delay by the specified hold duration*/
        digitalWrite(BLUE,LOW);
        break;
      case 3: // oscillate:x0:y0:x1:y1:speed:repetitions:resolution
        {
          /* Oscillate
           * Moves to first coordinate and oscillates between that and second coordinate
           */
          long dx = (long) ((*(command+3)-*(command+1))/virtDimX*dimensions[0]); /* Converting input virtual dimensions to microsteps*/
          long dy = (long) ((*(command+4)-*(command+2))/virtDimY*dimensions[1]);
          dispx = (long) (*(command+1)/virtDimX*dimensions[0])-location[0]; /*x displacment, difference between desired initial x and current x*/
          dispy = (long) (*(command+2)/virtDimY*dimensions[1])-location[1];
          line(dispx, dispy, vel);
          digitalWrite(RED,HIGH);
          delay(1000);
          int maxSpeed = *(command+5); /*smaller value for microseconds corresponds to faster overall speed*/
          int delta = *(command+7);
          long store_a = -dx/2;
          long store_b = -dy/2;
          //int f = 3;
          int minSpeed = 60; /* Minimum speed that target slows down to at edges of movement*/
          int dv = minSpeed-maxSpeed;
          long dtx = (long) dx/(10*dv/2); /*intervals into which first and last 10% are divided*/
          long dty = (long) dy/(10*dv/2);
          
          for(int j=1; j<=*(command+6); j++) {
            /*Speeds up in first 10% with intervals of 2 microseconds*/
            for(int i=0; i<(int)dv/2;i++) {
              int a = minSpeed-i*2;       
              line(dtx,dty,a);
            }
            
            /* Moves 80% */
            line((long) dx*0.8,(long) dy*0.8,maxSpeed);
            
            /*Slows down end 10% with intervals of 2 microseconds*/
            for(int i=0; i<(int)dv/2;i++) {
              int a = maxSpeed+i*2;       
              line(dtx,dty,a);
            }

            /*Speeds up end 10% back with intervals of 2 microseconds*/
            for(int i=0; i<(int)dv/2;i++) {
              int a = minSpeed-i*2;       
              line(-dtx,-dty,a);
            }

            /* Moves 80% back */
            line((long) -dx*0.8,(long) -dy*0.8,maxSpeed);

            /* Slows down end 10% back with intervals of 2 microseconds*/
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


