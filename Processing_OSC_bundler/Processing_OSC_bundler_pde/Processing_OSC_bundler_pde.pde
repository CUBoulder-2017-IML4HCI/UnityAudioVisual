import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;
NetAddress dest2;
int port;
OscMessage  myMessage;
OscMessage  myMessage2;
float[] annieVals, yueVals;

void setup() {
  port = 8082;
  oscP5 = new OscP5(this, port); // listen for OSC messages on port 12000
  dest = new NetAddress("127.0.0.1", 6446); // send to wekinator
  dest2 = new NetAddress("127.0.0.1", 6445); // send to wekinator
  size(150, 150);
  noFill();
  
  annieVals = new float[14];
  //arcadiaVals = new float[32];
  yueVals = new float[32];
}

void draw() {
  background(0);
  fill(255);
  textSize(14);
  text("Basic OSC sketch", 10, 10, 100, 100);
  textSize(12);
  text("listening on port: "+port, 10, 55, 100, 100);

}

void oscEvent(OscMessage theOscMessage) {
  myMessage = new OscMessage("/wek/inputs");
  myMessage2 = new OscMessage("/wek/inputs");
  if (theOscMessage.checkAddrPattern("/annie")) {
    if (theOscMessage.checkTypetag("ffffffffffffff")){
      for (int i = 0; i < 14; i++){
        annieVals[i] = theOscMessage.get(i).floatValue();
      }
    }
  }  
  /*if (theOscMessage.checkAddrPattern("/arcadia")) {
    if (theOscMessage.checkTypetag("ffffffffffffffffffffffffffffffff")){
      for (int i = 0; i < 32; i++){
        arcadiaVals[i] = theOscMessage.get(i).floatValue();
      }
    }
  }  */
  if (theOscMessage.checkAddrPattern("/yue")) {
    if (theOscMessage.checkTypetag("ffffffffffffffffffffffffffffffff")){
      for (int i = 0; i < 32; i++){
        yueVals[i] = theOscMessage.get(i).floatValue();
      }
    }
  }    
    /* send the message */
       // myMessage.add(55);
    /* send the message */
    for (int x = 0; x < annieVals.length; x++){
      myMessage.add(annieVals[x]);
    }
    /*for (int x = 0; x < arcadiaVals.length; x++){
      myMessage.add(arcadiaVals[x]);
    } */   
    for (int x = 0; x < yueVals.length; x++){
      myMessage2.add(yueVals[x]);
    }        
  oscP5.send(myMessage, dest);  
  oscP5.send(myMessage2, dest2);  
  myMessage.clear();
  myMessage2.clear();
}