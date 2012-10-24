public class GestureController{
  ArrayList<Gesture> gestures = new ArrayList<Gesture>();  
  PVector[] prevJoints;
  int[] counters;
  float prevRAngle, prevLAngle, rAngle, lAngle;
  
  public GestureController(){
    
    Gesture wave = new Wave();
    //gestures.add(wave);
    
    Gesture confusion = new Confusion();
    gestures.add(confusion);
    
    Gesture sadness = new Sadness();
    gestures.add(sadness);
    
    Gesture terror = new Terror();
    gestures.add(terror);
    
    //print("Gestures: "+gestures.toString());
    counters = new int[GestureInfo.NUMBER_OF_PIECES];
  }
  
  public Gesture updateGestures(PVector[] joints){
    if(prevJoints!=null){
      setGesturePieces(joints);
    }
    
    prevJoints=joints;
    prevRAngle = rAngle;
    prevLAngle= lAngle; 
    return checkGestures(joints);
  }
  
  public void setGesturePieces(PVector[] joints){
    
    //Left hand rising (Might want to change these first four to be based on the normalized vector
    
    if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_RISING]){
      GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_RISING] = joints[GestureInfo.LEFT_HAND].y>prevJoints[GestureInfo.LEFT_HAND].y;
      if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_RISING]){
        counters[GestureInfo.LEFT_HAND_RISING]=3;
        
      }
      else{
        if(counters[GestureInfo.LEFT_HAND_RISING]==0){
          //Do nothing, it's already false
        }
        else{
          counters[GestureInfo.LEFT_HAND_RISING]-=1;
          GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_RISING]=true;
        }
      }
    }
    else{
      GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_RISING] = joints[GestureInfo.LEFT_HAND].y>prevJoints[GestureInfo.LEFT_HAND].y;
      if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_RISING]){
        counters[GestureInfo.LEFT_HAND_RISING]=3;
      }
    }
    
    
    
    
    ////////////////////
    //Right hand rising
    if(GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_RISING]){
      GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_RISING] = joints[GestureInfo.RIGHT_HAND].y>prevJoints[GestureInfo.RIGHT_HAND].y;
      if(GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_RISING]){
        counters[GestureInfo.RIGHT_HAND_RISING]=3;
        
      }
      else{
        if(counters[GestureInfo.RIGHT_HAND_RISING]==0){
          //Do nothing, it's already false
        }
        else{
          counters[GestureInfo.RIGHT_HAND_RISING]-=1;
          GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_RISING]=true;
        }
      }
    }
    else{
      GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_RISING] = joints[GestureInfo.RIGHT_HAND].y>prevJoints[GestureInfo.RIGHT_HAND].y;
      if(GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_RISING]){
        counters[GestureInfo.RIGHT_HAND_RISING]=3;
      }
    }
    
    
    
    //Left hand faling
    if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_FALLING]){
      GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_FALLING] = joints[GestureInfo.LEFT_HAND].y<prevJoints[GestureInfo.LEFT_HAND].y;
      if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_FALLING]){
        counters[GestureInfo.LEFT_HAND_FALLING]=3;
        
      }
      else{
        if(counters[GestureInfo.LEFT_HAND_FALLING]==0){
          //Do nothing, it's already false
        }
        else{
          counters[GestureInfo.LEFT_HAND_FALLING]-=1;
          GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_FALLING]=true;
        }
      }
    }
    else{
      GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_FALLING] = joints[GestureInfo.LEFT_HAND].y<prevJoints[GestureInfo.LEFT_HAND].y;
      if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_FALLING]){
        counters[GestureInfo.LEFT_HAND_FALLING]=3;
      }
    }
    
    //Right hand falling
    if(GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_FALLING]){
      GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_FALLING] = joints[GestureInfo.RIGHT_HAND].y<prevJoints[GestureInfo.RIGHT_HAND].y;
      if(GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_FALLING]){
        counters[GestureInfo.RIGHT_HAND_FALLING]=3;
        
      }
      else{
        if(counters[GestureInfo.RIGHT_HAND_FALLING]==0){
          //Do nothing, it's already false
        }
        else{
          counters[GestureInfo.RIGHT_HAND_FALLING]-=1;
          GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_FALLING]=true;
        }
      }
    }
    else{
      GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_FALLING] = joints[GestureInfo.RIGHT_HAND].y<prevJoints[GestureInfo.RIGHT_HAND].y;
      if(GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_FALLING]){
        counters[GestureInfo.RIGHT_HAND_FALLING]=3;
      }
    }
    
    //Left hand down
    GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_DOWN] = (joints[GestureInfo.LEFT_HAND].y<joints[GestureInfo.LEFT_ELBOW].y)&& joints[GestureInfo.LEFT_ELBOW].y<joints[GestureInfo.LEFT_SHOULDER].y;
    
    //Right hand down
    GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_DOWN] = joints[GestureInfo.RIGHT_HAND].y<joints[GestureInfo.RIGHT_ELBOW].y && joints[GestureInfo.RIGHT_ELBOW].y<joints[GestureInfo.RIGHT_SHOULDER].y;
    
    //Left hand moving left
    GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_MOVING_LEFT] = joints[GestureInfo.LEFT_HAND].x<prevJoints[GestureInfo.LEFT_HAND].x;
    
    //Right hand moving left
    GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_MOVING_LEFT] = joints[GestureInfo.RIGHT_HAND].x<prevJoints[GestureInfo.RIGHT_HAND].x;
    
    //Left hand moving right
    GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_MOVING_RIGHT] = joints[GestureInfo.LEFT_HAND].x>prevJoints[GestureInfo.LEFT_HAND].x;
    
    //Right hand moving right
    GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_MOVING_RIGHT] = joints[GestureInfo.RIGHT_HAND].x>prevJoints[GestureInfo.RIGHT_HAND].x;
    
    float distanceMeter = PVector.sub(joints[GestureInfo.HEAD],joints[GestureInfo.NECK]).mag()/2;
    
    GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_STILL] = PVector.sub(joints[GestureInfo.LEFT_HAND],prevJoints[GestureInfo.LEFT_HAND]).mag()<distanceMeter;
    GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_STILL] = PVector.sub(joints[GestureInfo.RIGHT_HAND],prevJoints[GestureInfo.RIGHT_HAND]).mag()<distanceMeter;
    
    
    
  
    GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_NEAR_HEAD]=   PVector.sub(joints[GestureInfo.LEFT_HAND],joints[GestureInfo.HEAD]).mag()<distanceMeter*2;
    GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_NEAR_HEAD]=   PVector.sub(joints[GestureInfo.RIGHT_HAND],joints[GestureInfo.HEAD]).mag()<distanceMeter*2;
    
    //Left knee going back
    if(GestureInfo.gesturePieces[GestureInfo.LEFT_KNEE_GOING_BACK]){
      GestureInfo.gesturePieces[GestureInfo.LEFT_KNEE_GOING_BACK] = joints[GestureInfo.LEFT_KNEE].z>prevJoints[GestureInfo.LEFT_KNEE].z;
      if(GestureInfo.gesturePieces[GestureInfo.LEFT_KNEE_GOING_BACK]){
        counters[GestureInfo.LEFT_KNEE_GOING_BACK]=3;
        
      }
      else{
        if(counters[GestureInfo.LEFT_KNEE_GOING_BACK]==0){
          //Do nothing, it's already false
        }
        else{
          counters[GestureInfo.LEFT_KNEE_GOING_BACK]-=1;
          GestureInfo.gesturePieces[GestureInfo.LEFT_KNEE_GOING_BACK]=true;
        }
      }
    }
    else{
      GestureInfo.gesturePieces[GestureInfo.LEFT_KNEE_GOING_BACK] = joints[GestureInfo.LEFT_KNEE].z>prevJoints[GestureInfo.LEFT_KNEE].z;
      if(GestureInfo.gesturePieces[GestureInfo.LEFT_KNEE_GOING_BACK]){
        counters[GestureInfo.LEFT_KNEE_GOING_BACK]=3;
      }
    }
    
    //RIGHT knee going back
    if(GestureInfo.gesturePieces[GestureInfo.RIGHT_KNEE_GOING_BACK]){
      GestureInfo.gesturePieces[GestureInfo.RIGHT_KNEE_GOING_BACK] = joints[GestureInfo.RIGHT_KNEE].z>prevJoints[GestureInfo.RIGHT_KNEE].z;
      if(GestureInfo.gesturePieces[GestureInfo.RIGHT_KNEE_GOING_BACK]){
        counters[GestureInfo.RIGHT_KNEE_GOING_BACK]=3;
        
      }
      else{
        if(counters[GestureInfo.RIGHT_KNEE_GOING_BACK]==0){
          //Do nothing, it's already false
        }
        else{
          counters[GestureInfo.RIGHT_KNEE_GOING_BACK]-=1;
          GestureInfo.gesturePieces[GestureInfo.RIGHT_KNEE_GOING_BACK]=true;
        }
      }
    }
    else{
      GestureInfo.gesturePieces[GestureInfo.RIGHT_KNEE_GOING_BACK] = joints[GestureInfo.RIGHT_KNEE].z>prevJoints[GestureInfo.RIGHT_KNEE].z;
      if(GestureInfo.gesturePieces[GestureInfo.RIGHT_KNEE_GOING_BACK]){
        counters[GestureInfo.RIGHT_KNEE_GOING_BACK]=3;
      }
    }
    
    GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_BELOW_SHOULDER] = joints[GestureInfo.LEFT_HAND].y<joints[GestureInfo.LEFT_SHOULDER].y && 
    joints[GestureInfo.LEFT_ELBOW].y<joints[GestureInfo.LEFT_HAND].y;
    
    GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_BELOW_SHOULDER] = joints[GestureInfo.RIGHT_HAND].y<joints[GestureInfo.RIGHT_SHOULDER].y && 
    joints[GestureInfo.RIGHT_ELBOW].y<joints[GestureInfo.RIGHT_HAND].y;
  
    
    PVector rUpperArm=PVector.sub(joints[GestureInfo.RIGHT_SHOULDER], joints[GestureInfo.RIGHT_ELBOW]);
    PVector rLowerArm = PVector.sub(joints[GestureInfo.RIGHT_HAND], joints[GestureInfo.RIGHT_ELBOW]);
    
    PVector lUpperArm=PVector.sub(joints[GestureInfo.LEFT_SHOULDER], joints[GestureInfo.LEFT_ELBOW]);
    PVector lLowerArm = PVector.sub(joints[GestureInfo.LEFT_HAND], joints[GestureInfo.LEFT_ELBOW]);
    
    rAngle = PVector.angleBetween(rUpperArm, rLowerArm);
    lAngle = PVector.angleBetween(lUpperArm, lLowerArm);
    
    GestureInfo.gesturePieces[GestureInfo.LEFT_ARM_ANGLE_DECREASING]= lAngle<prevLAngle;
    GestureInfo.gesturePieces[GestureInfo.RIGHT_ARM_ANGLE_DECREASING]= rAngle<prevRAngle;
    
    GestureInfo.gesturePieces[GestureInfo.LEFT_ARM_ANGLE_MED]= lAngle<100;
    GestureInfo.gesturePieces[GestureInfo.RIGHT_ARM_ANGLE_MED]= rAngle<100;
    
    //Left hand down
    GestureInfo.gesturePieces[GestureInfo.LEFT_ARM_UP] = (joints[GestureInfo.LEFT_HAND].y>joints[GestureInfo.LEFT_ELBOW].y)&& joints[GestureInfo.LEFT_ELBOW].y>joints[GestureInfo.LEFT_SHOULDER].y;
    
    //Right hand down
    GestureInfo.gesturePieces[GestureInfo.RIGHT_ARM_UP] = joints[GestureInfo.RIGHT_HAND].y>joints[GestureInfo.RIGHT_ELBOW].y && joints[GestureInfo.RIGHT_ELBOW].y>joints[GestureInfo.RIGHT_SHOULDER].y;
    
    GestureInfo.gesturePieces[GestureInfo.HANDS_TOGETHER]=   PVector.sub(joints[GestureInfo.LEFT_HAND],joints[GestureInfo.RIGHT_HAND]).mag()<distanceMeter*3;
    
    //Hands above head
    GestureInfo.gesturePieces[GestureInfo.RIGHT_ARM_UP] = (joints[GestureInfo.RIGHT_HAND].y>joints[GestureInfo.RIGHT_ELBOW].y)&& joints[GestureInfo.RIGHT_ELBOW].y>joints[GestureInfo.RIGHT_SHOULDER].y;   

    GestureInfo.gesturePieces[GestureInfo.HANDS_ABOVE_HEAD]=joints[GestureInfo.RIGHT_HAND].y>joints[GestureInfo.HEAD].y && joints[GestureInfo.LEFT_HAND].y>joints[GestureInfo.HEAD].y;


}
  
  public Gesture checkGestures(PVector[] joints){
    
    float maxValue=-1.0f;
    Gesture maxGesture = null;
    
    //Go through and call each Gesture's update, see what it returns and return the max.
    for (int i = 0; i<gestures.size(); i++){
      
      float confidenceValue = gestures.get(i).update(joints);
      if(confidenceValue>maxValue){
        maxValue = confidenceValue;
        maxGesture = gestures.get(i);
        
      }
      
    }
    
    return maxGesture;
  }
  
  
  
  
  
}
