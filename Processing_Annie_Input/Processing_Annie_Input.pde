import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress dest;
NetAddress dest2;
int port;
OscMessage  myMessage;

void setup() {
  port = 6448;
  oscP5 = new OscP5(this, port); // listen for OSC messages on port 12000
  dest = new NetAddress("127.0.0.1", 8082); // send to bundler
  size(150, 150);
  noFill();
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
  if (!theOscMessage.checkAddrPattern("/wek/inputs")) {
    println(theOscMessage);
  }
  myMessage = new OscMessage("/annie");
  for (int i = 0; i < 14; i++){
    myMessage.add(theOscMessage.get(i).floatValue());
  }
  oscP5.send(myMessage, dest);    
}