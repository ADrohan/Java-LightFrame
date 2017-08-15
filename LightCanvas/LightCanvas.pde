//import KinectPV2.*;

//KinectPV2 kinect;

//FaceData [] faceData;

PVector nosePos = new PVector(0,0);

PVector chase = new PVector(0,0);

float speed = 1200;
float elapsed = 0.01f;

float esRad = 75.0;

void setup() {
  size(1280, 720);
  //fullScreen();
  background(0);
  //noCursor();
  
 // kinect = new KinectPV2(this);

  //for face detection based on the color Img
  //kinect.enableColorImg(true);

  //for face detection base on the infrared Img
  //kinect.enableInfraredImg(true);

  //enable face detection
  //kinect.enableFaceDetection(true);

 /// kinect.init();
}

void draw () {
background(0);
fill(255);

//kinect.generateFaceData();
//getFaceMapInfraredData();
nosePos.x = mouseX; 
nosePos.y = mouseY;

chaseFace();

ellipse(chase.x, chase.y, esRad,esRad);

}

public void chaseFace() {
  PVector start = chase;
  float distance = PVector.dist(start, nosePos);
  PVector vect = nosePos.sub(start);
  PVector direction = vect.normalize();
  chase = chase.add(direction.mult(speed * elapsed));  
  if(esRad/3 >= distance)
  {
    println("--------");
    println(nosePos);
    println(nosePos.x);
    println(nosePos.y);
    println(chase);
      chase = new PVector(mouseX, mouseY);
      println(chase);
  }
}

// public void getFaceMapInfraredData() {

//  ArrayList<FaceData> faceData =  kinect.getFaceData();

//  for (int i = 0; i < faceData.size(); i++) {
//    FaceData faceD = faceData.get(i);

//    if (faceD.isFaceTracked()) {
//      //get the face data from the infrared frame
//      PVector [] facePointsInfrared = faceD.getFacePointsInfraredMap();

//      //get the color of th user
//      int col = faceD.getIndexColor();

//      //for nose information
//      nosePos = new PVector();
//      noStroke();
//      fill(col);
//      for (int j = 0; j < facePointsInfrared.length; j++) {
//        //obtain the position of the nose
//        if (j == KinectPV2.Face_Nose)
//          nosePos.set(facePointsInfrared[j].x + 80, facePointsInfrared[j].y+20);
//      }
//      println(nosePos);
//    }
//  }
//}