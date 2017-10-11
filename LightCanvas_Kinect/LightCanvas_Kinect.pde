/*
 SEMS ART PROJECT USING
 KinectPV2, Kinect for Windows v2 library for processing
 */

import java.util.ArrayList;
import KinectPV2.KJoint;
import KinectPV2.*;

// Global Variables
KinectPV2 kinect;
static enum States {
  DEMO,
  LIVE,
  RECORD,
  PLAYING;
}
float esRad = 60.0;
ArrayList<PVector> demoArray = new ArrayList<PVector>();
ArrayList<ArrayList<PVector>> frames = new ArrayList<ArrayList<PVector>>();
States state = States.DEMO;
PrintWriter output;
int frame = 0;

void setup() {
  //Platform Setup
  //fullScreen(P3D, 1);
  size(400, 400);
  
  //Kinect Setup
  kinect = new KinectPV2(this);
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);
  kinect.init();
}

void draw() {
  //Frame Setup
  background(0);
  pushMatrix(); // Centre Screen
  
  switch(state) {
    case DEMO: 
      fill(255, 255, 255);
      for(PVector point : demoArray){
        ellipse(point.x, point.y, esRad,esRad);
      }
      ellipse(mouseX, mouseY, esRad,esRad);
      break;
    case LIVE:
      mainKinect();
      break;
    case RECORD: 
      mainKinect();
      break;
    case PLAYING:
      
      print("Playing");
      break;
  }
  popMatrix();
  fill(255, 0, 0);
}

public void keyPressed(){
  if (key == 'd'){
    state = States.DEMO;
  }
  else if (key == 'l'){
    demoArray = new ArrayList<PVector>();
    state = States.LIVE;
  }
  else if (key == 'r'){
    output = createWriter("data.txt");
    state = States.RECORD;
  }
  else if (key == 'p'){
    readFile("data.txt");
  }
  else if (key == 's'){
    state = States.LIVE;
  } 
}

void mouseClicked() {
  if(state == States.DEMO) {
    demoArray.add(new PVector(mouseX, mouseY));
  }
}

void readFile(String file) {
  BufferedReader reader = createReader(file);
  boolean fileEnd = false;
  String line;
  ArrayList<PVector> singleFrame = new ArrayList<PVector>();
  while(!fileEnd) {
    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null;
    }
    if (line == null) {
      fileEnd = true;
    } else {
      String[] persons = split(line, "|");
      for(String person : persons) {
        if(person.length() > 1){
          String[] hands = split(person, ":");
          for(String hand : hands) {
            if(hand.length() > 1){
              String[] points = split(hand, ",");
              singleFrame.add(new PVector(float(points[0]),float(points[1])));
            }
          }
        }
      }
      frames.add(singleFrame);
    }
  }
  state = States.PLAYING;
}


// Kinect Methods
void mainKinect() {
  ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();  //get the skeletons as an Arraylist of KSkeletons
  //individual joints
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {
      KJoint[] joints = skeleton.getJoints();
      color col  = skeleton.getIndexColor();
      fill(0, 0, 0);
      stroke(col);
      drawBody(joints);
      drawHandState(joints[KinectPV2.JointType_HandRight]);
      drawHandState(joints[KinectPV2.JointType_HandLeft]);
    }
  }
  if(state == States.RECORD) {
    for(KSkeleton point : skeletonArray) {
      KJoint[] joints =  point.getJoints();
      output.print(joints[KinectPV2.JointType_HandRight].getX()+","+joints[KinectPV2.JointType_HandRight].getY());
      output.print(":");
      output.print(joints[KinectPV2.JointType_HandLeft].getX()+","+joints[KinectPV2.JointType_HandLeft].getY());
      output.print("|");
    }
    output.println("");
    // print to file
  }
}
void drawBody(KJoint[] joints) {
  drawBone(joints, KinectPV2.JointType_HandRight, KinectPV2.JointType_HandRight);
  drawBone(joints, KinectPV2.JointType_Head, KinectPV2.JointType_Head);
}

//draw two joints
void drawBone(KJoint[] joints, int jointType1, int jointType2) {
  noStroke();
  pushMatrix();
  translate(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ());
  ellipse(0, 0, 25, 25);
  popMatrix();
  line(joints[jointType1].getX(), joints[jointType1].getY(), joints[jointType1].getZ(), joints[jointType2].getX(), joints[jointType2].getY(), joints[jointType2].getZ());
}

//draw a ellipse depending on the hand state and size adjustment
void drawHandState(KJoint joint) {
  noStroke();
  handState(joint.getState());
  pushMatrix();
  translate(joint.getX(), joint.getY(), joint.getZ());
  ellipse(0, 0, 70, 70);
  popMatrix();
}

//Depending on the hand state change the color
void handState(int handState) {
  switch(handState) {
  case KinectPV2.HandState_Open:
    fill(255, 255, 255);
    break;
  case KinectPV2.HandState_Closed:
    fill(255, 255, 255);
    break;
  case KinectPV2.HandState_NotTracked:
    fill(255, 255, 255);
    break;
  }
}