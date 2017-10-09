/*
 SEMS ART PROJECT USING
 KinectPV2, Kinect for Windows v2 library for processing
 */

import java.util.ArrayList;
import KinectPV2.KJoint;
import KinectPV2.*;

// Global Variables
KinectPV2 kinect;
static enum State {
  DEMO,
  LIVE,
  RECORD,
  PLAY,
  PLAYING;
}

State state = State.LIVE;


void setup() {
  //Platform Setup
  fullScreen(P3D, 1);
  
  //State Setup
  
  //Kinect Setup
  kinect = new KinectPV2(this);
  kinect.enableDepthMaskImg(true);
  kinect.enableSkeletonDepthMap(true);
  kinect.enableSkeletonColorMap(true);
  kinect.enableColorImg(true);
  kinect.init();
  
  
}

void draw() {
  switch(state) {
    case DEMO: 
    case LIVE: 
    case RECORD: 
    case PLAY: 
    case PLAYING:
     print("Live");
  }
  background(0);
  pushMatrix(); //translate the scene to the center 
     ArrayList<KSkeleton> skeletonArray =  kinect.getSkeletonColorMap();  //get the skeletons as an Arraylist of KSkeletons
        //individual joints
        for (int i = 0; i < skeletonArray.size(); i++) {
          KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
        //if the skeleton is being tracked compute the skleton joints
        if (skeleton.isTracked()) {
          KJoint[] joints = skeleton.getJoints();
            color col  = skeleton.getIndexColor();
              fill(255, 255, 255);
              stroke(col);
              drawBody(joints);
             drawHandState(joints[KinectPV2.JointType_HandRight]);
             drawHandState(joints[KinectPV2.JointType_HandLeft]);
            }
          }
popMatrix();
fill(255, 0, 0);
}



// Kinect Methods

//draw the body
void drawBody(KJoint[] joints) 
  {
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