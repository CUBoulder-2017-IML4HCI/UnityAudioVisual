// This demo changes the pitch of the sound played and the screen color to match the class received
// Works with 1 classifier output, any number of classes
// Rebecca Fiebrink, 2016

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
OscP5 oscP5;
NetAddress dest;

//No need to edit:
PFont myFont, myBigFont;
int frameNum = 0;
int currentHue = 100;
int currentTextHue = 255;
String currentMessage = "Waiting...";

//For sound:
Minim       minim;
AudioOutput out;
Oscil       wave;
String[] pitches = {"C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"};


void setup() {
  size(400,400, P3D);
  colorMode(HSB);
  smooth();
  
  //Set up sound:
  minim = new Minim(this);
  out = minim.getLineOut();
  wave = new Oscil( 440, 0.5f, Waves.SINE );
  wave.setAmplitude(0.0);
  // patch the Oscil to the output
  wave.patch( out );
  
  //Initialize OSC communication
  oscP5 = new OscP5(this,9999); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  
  //Set up fonts
  myFont = createFont("Arial", 14);
  myBigFont = createFont("Arial", 60);
}

void draw() {
  frameRate(30);
  background(currentHue, 255, 255);
  drawText();
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 //println("received message");
  if (theOscMessage.checkAddrPattern("/scale") == true) {
    if(theOscMessage.checkTypetag("f")) {
      float f = theOscMessage.get(0).floatValue();
      showMessage(f);
      println(f);
    }
  }
  
}

void showMessage(float f) {
    int i = (int)map(f, 0.0, 1.0, 1, 8);
    currentHue = (int)generateColor(i);
    currentTextHue = (int)generateColor((i+1));
    currentMessage = Integer.toString(i);
    
    
    if (i >= 1 && i <= 8) {
      wave.setFrequency(Frequency.ofPitch(pitches[i-1]).asHz());
    } else if (i < 1) {
      wave.setFrequency(Frequency.ofPitch(pitches[0]).asHz());
    } else {
      wave.setFrequency(Frequency.ofPitch(pitches[7]).asHz());
    }
    wave.setAmplitude(0.5);

}

//Write instructions to screen.
void drawText() {
    stroke(0);
    textFont(myFont);
    textAlign(LEFT, TOP); 
    fill(currentTextHue, 255, 255);

    text("Receives 1 classifier output message from unity", 10, 10);
    text("Listening for OSC message /scale, port 9999", 10, 30);
    
    textFont(myBigFont);
    text(currentMessage, 190, 180);
}


float generateColor(int which) {
  float f = 100; 
  int i = which;
  if (i <= 0) {
     return 100;
  } 
  else {
     return (generateColor(which-1) + 1.61*255) %255; 
  }
}