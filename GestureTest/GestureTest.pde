/* --------------------------------------------------------------------------
 * SimpleOpenNI User Test
 * --------------------------------------------------------------------------
 * Processing Wrapper for the OpenNI/Kinect library
 * http://code.google.com/p/simple-openni
 * --------------------------------------------------------------------------
 * prog:  Max Rheiner / Interaction Design / zhdk / http://iad.zhdk.ch/
 * date:  02/16/2011 (m/d/y)
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;

SimpleOpenNI  context;
boolean       autoCalib=true;
GestureController controller;
int checkGestures=0;
Gesture currGesture;

PFrame gestureInfoFrame;

void setup()
{
  context = new SimpleOpenNI(this);
   
  // enable depthMap generation 
  if(context.enableDepth() == false)
  {
     println("Can't open the depthMap, maybe the camera is not connected!"); 
     exit();
     return;
  }
  
  // enable skeleton generation for all joints
  context.enableUser(SimpleOpenNI.SKEL_PROFILE_ALL);
 
  background(200,0,0);

  stroke(0,0,255);
  strokeWeight(3);
  smooth();
  
  
  gestureInfoFrame = new PFrame("Current Gesture");
  //wave = new Wave(0);
  PFont font;
  font = loadFont("Serif-30.vlw"); 
  gestureInfoFrame.s.textFont(font); 
  controller = new GestureController();
  GestureInfo.init();
  
  
  
  size(context.depthWidth(), context.depthHeight()); 
}

void draw()
{
  // update the cam
  context.update();
  
  // draw depthImageMap
  image(context.depthImage(),0,0);
  
  // draw the skeleton if it's available
  for(int i = 0; i<10; i++){
    if(context.isTrackingSkeleton(i)){
      fill(0,0,255);
      drawSkeleton(i);
      
      if(checkGestures==5){
        checkGestures=0;
        PVector[] joints = new PVector[GestureInfo.JOINTS_LENGTH];  
        
        PVector jointPos = new PVector();
        context.getJointPositionSkeleton(i,SimpleOpenNI.SKEL_LEFT_ELBOW,jointPos);
        joints[GestureInfo.LEFT_ELBOW] = jointPos;
        
        PVector jointPos1 = new PVector();
        context.getJointPositionSkeleton(i,SimpleOpenNI.SKEL_LEFT_HAND,jointPos1);
        joints[GestureInfo.LEFT_HAND] = jointPos1;
        
        PVector jointPos2 = new PVector();
        context.getJointPositionSkeleton(i,SimpleOpenNI.SKEL_LEFT_SHOULDER,jointPos2);
        joints[GestureInfo.LEFT_SHOULDER] = jointPos2;
        
        PVector jointPos3 = new PVector();
        context.getJointPositionSkeleton(i,SimpleOpenNI.SKEL_TORSO,jointPos3);
        joints[GestureInfo.TORSO] = jointPos3;
        
        PVector jointPos4 = new PVector();
        context.getJointPositionSkeleton(i,SimpleOpenNI.SKEL_RIGHT_ELBOW,jointPos4);
        joints[GestureInfo.RIGHT_ELBOW] = jointPos4;
        
        PVector jointPos5 = new PVector();
        context.getJointPositionSkeleton(i,SimpleOpenNI.SKEL_RIGHT_HAND,jointPos5);
        joints[GestureInfo.RIGHT_HAND] = jointPos5;
        
        PVector jointPos6 = new PVector();
        context.getJointPositionSkeleton(i,SimpleOpenNI.SKEL_RIGHT_SHOULDER,jointPos6);
        joints[GestureInfo.RIGHT_SHOULDER] = jointPos6;
        
        PVector jointPos7 = new PVector();
        context.getJointPositionSkeleton(i,SimpleOpenNI.SKEL_HEAD,jointPos7);
        joints[GestureInfo.HEAD] = jointPos7;
        
        PVector jointPos8 = new PVector();
        context.getJointPositionSkeleton(i,SimpleOpenNI.SKEL_NECK,jointPos8);
        joints[GestureInfo.NECK] = jointPos8;
        
        PVector jointPos9 = new PVector();
        context.getJointPositionSkeleton(i,SimpleOpenNI.SKEL_LEFT_KNEE,jointPos9);
        joints[GestureInfo.LEFT_KNEE] = jointPos9;
        
        PVector jointPos10 = new PVector();
        context.getJointPositionSkeleton(i,SimpleOpenNI.SKEL_RIGHT_KNEE,jointPos10);
        joints[GestureInfo.RIGHT_KNEE] = jointPos10;
        
        
        Gesture response = controller.updateGestures(joints);
        
        if(response!=null){
          currGesture = response;
          if(response.confidence==1){
            //Erase previous
            gestureInfoFrame.s.fill(0);
            gestureInfoFrame.s.rect(0,0,gestureInfoFrame.w,gestureInfoFrame.h);
            
            
            gestureInfoFrame.s.fill(255,0,0);
            gestureInfoFrame.s.text(response.name+"!",0,50);
          }
        }
      }
      else{
        checkGestures++;
        
      }
    }
    
  }
  if(currGesture!=null){
    if(currGesture.confidence!=1){
      //Erase previous
      gestureInfoFrame.s.fill(0);
      gestureInfoFrame.s.rect(0,0,gestureInfoFrame.w,gestureInfoFrame.h);
      gestureInfoFrame.s.fill(255,255,255);
      gestureInfoFrame.s.text(currGesture.name+". Con: "+currGesture.confidence +". Dur: "+currGesture.duration +". Tempo: "+currGesture.tempo,0,50);
    }  
  }
}

// draw the skeleton with the selected joints
void drawSkeleton(int userId)
{
  // to get the 3d joint data
  /*
  PVector jointPos = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_NECK,jointPos);
  println(jointPos);
  */
  
  context.drawLimb(userId, SimpleOpenNI.SKEL_HEAD, SimpleOpenNI.SKEL_NECK);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_LEFT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_LEFT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_NECK, SimpleOpenNI.SKEL_RIGHT_SHOULDER);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_RIGHT_ELBOW);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);

  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_SHOULDER, SimpleOpenNI.SKEL_TORSO);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_SHOULDER, SimpleOpenNI.SKEL_TORSO);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_LEFT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_HIP, SimpleOpenNI.SKEL_LEFT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_LEFT_KNEE, SimpleOpenNI.SKEL_LEFT_FOOT);

  context.drawLimb(userId, SimpleOpenNI.SKEL_TORSO, SimpleOpenNI.SKEL_RIGHT_HIP);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_HIP, SimpleOpenNI.SKEL_RIGHT_KNEE);
  context.drawLimb(userId, SimpleOpenNI.SKEL_RIGHT_KNEE, SimpleOpenNI.SKEL_RIGHT_FOOT);  
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(int userId)
{
  println("onNewUser - userId: " + userId);
  println("  start pose detection");
  
  if(autoCalib)
    context.requestCalibrationSkeleton(userId,true);
  else    
    context.startPoseDetection("Psi",userId);
}

void onLostUser(int userId)
{
  println("onLostUser - userId: " + userId);
}

void onStartCalibration(int userId)
{
  println("onStartCalibration - userId: " + userId);
}

void onEndCalibration(int userId, boolean successfull)
{
  println("onEndCalibration - userId: " + userId + ", successfull: " + successfull);
  
  if (successfull) 
  { 
    println("  User calibrated !!!");
    context.startTrackingSkeleton(userId); 
  } 
  else 
  { 
    println("  Failed to calibrate user !!!");
    println("  Start pose detection");
    context.startPoseDetection("Psi",userId);
  }
}

void onStartPose(String pose,int userId)
{
  println("onStartPose - userId: " + userId + ", pose: " + pose);
  println(" stop pose detection");
  
  context.stopPoseDetection(userId); 
  context.requestCalibrationSkeleton(userId, true);
 
}

void onEndPose(String pose,int userId)
{
  println("onEndPose - userId: " + userId + ", pose: " + pose);
}
