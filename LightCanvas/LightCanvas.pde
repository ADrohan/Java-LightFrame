import KinectPV2.*;

KinectPV2 kinect;

ArrayList<PVector> faces;

PVector nosePos = new PVector(0,0);

PVector chase = new PVector(0,0);

float speed = 1200;
float elapsed = 0.01f;

float esRad = 40.0;

void setup() {
  fullScreen();
  background(0);
  noCursor();
  kinect = new KinectPV2(this);

  //for face detection based on the color Img
  kinect.enableColorImg(true);

  //for face detection base on the infrared Img
  kinect.enableInfraredImg(true);

  //enable face detection
  kinect.enableFaceDetection(true);

  kinect.init();
}

void draw () {
  // Kinect Image Draw infrared 
  PImage info = kinect.getInfraredImage();
  scale(2.0);
  image(info, 125, 0);
  
  // Back Black Jack
  background(0);
  fill(255);
  
  kinect.generateFaceData();
  getFaceMapInfraredData();
  for (PVector item : faces) {
    ellipse(item.x, item.y, esRad,esRad);
  }

}

//public void chaseFace(PVector faceposition) {
//  if(faceposition.x <= 0.0 && faceposition.y <= 0.0){
//    //println("Zero");
//    //println("FacePosition: "+ faceposition);
//    //println("Chase: "+ chase);
//    return;
//  } else {
//    //println("Tracking");
//    //println("FacePosition: "+ faceposition);
//    //println("Chase: "+ chase);
//    PVector start = chase;
//    float distance = PVector.dist(start, faceposition);
//    PVector vect = faceposition.sub(start);
//    PVector direction = vect.normalize();
//    chase = chase.add(direction.mult(speed * elapsed));  
//    if(esRad/3 >= distance) {
//      chase = new PVector(faceposition.x + 150, faceposition.y);
//    }
//    return;
//  }
//}

 public void getFaceMapInfraredData() {
  ArrayList<FaceData> faceData =  kinect.getFaceData();
  faces = new ArrayList<PVector>();

  for (int i = 0; i < faceData.size(); i++) {
    FaceData faceD = faceData.get(i);

    if (faceD.isFaceTracked()) {
      //get the face data from the infrared frame
      PVector [] facePointsInfrared = faceD.getFacePointsInfraredMap();
      
      //for nose information
      for (int j = 0; j < facePointsInfrared.length; j++) {
        //obtain the position of the nose
        if (j == KinectPV2.Face_Nose)
          faces.add(new PVector(facePointsInfrared[j].x +60, facePointsInfrared[j].y));
      }
    }
  }
}