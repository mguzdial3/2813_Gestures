public class Gesture{
  public float tempo, duration, confidence;
  public String name;
  //Definitions for types of gestures
  public final int UPPERBODY=0;
  public final int LOWERBODY=1;
  public final int ARMS=2;
  public final int FULLBODY=3;
  
  //ACTUAL TYPE OF THIS GESTURE, NOT CURRENTLY SET, AS THIS IS JUST THE BASE CLASS
  //Also allows us to switch which joints we're grabbing based on what part of the gesture we're in
  public int type;
  
  //0 is birth, 1 is life, 2 is death
  public int state;
  public PVector[] joints, prevJoints;
    
  public Gesture(){
    this.type=UPPERBODY;  
  }
  
  public Gesture(int type){
    this.type=type;
    
    state=-1;
  }
  
  //Returns confidence at this moment
  public float update(PVector[] joints){
    
    
    return confidence;
  }
  
  public boolean birthChecker(){
    if(state==-1){
      return false;
    }
    else if(state==0){
      //Previously has been birth
      return true;
    }
    return false;
  }
  
  public boolean lifeChecker(){
    if(state==0){
      return false;
    }
    else if(state==1){
      return true;
    }
    return false;
  }
  
  public boolean deathChecker(){
    return false;
  }
}

/**
----------------------------------------------------------------------------------------------------------------
*/
public class Wave extends Gesture{
  boolean usingLeft=false;
  public final int waveAmount=10;

  
  
  public Wave(){
    super();
    super.name="Wave";
    prevJoints = new PVector[GestureInfo.JOINTS_LENGTH];
  }
  
  public float update(PVector[] joints){
    this.joints=joints;
    
    if(prevJoints[GestureInfo.LEFT_HAND]!=null){
      if(state==-1){
        
          if(birthChecker()){
            state=0;
          }
        
      }
      else if(state==0){
        boolean birthing = birthChecker();
        
        if(!birthing){
          if(lifeChecker()){
            state=1;
            confidence=0.5f;
          }
          else{
            state=-1;
            duration=0;
            tempo=0;
            confidence=0;
          }
        }
        else{
          if(confidence<0.3){
            confidence+=0.001f;
          }
          else{
            confidence=0;
            duration=0;
            tempo=0;
          }
        }
        
      }
      else if(state==1){
        
        boolean living =lifeChecker();
        
        if(!living){
          if(deathChecker()){
            state=2;
            confidence =0.8f;
          }
          else{
            state=-1;
            duration=0;
            tempo=0;
            confidence=0;
          }
        }
        else{
          if(confidence<0.6){
            confidence+=0.001f;
          }
          else{
            confidence-=0.02f;
          }
        }
        
      }
      else if(state==2){
        
        boolean dying = deathChecker();
        
        //If no longer dying, reset
        if(!dying){
          
          //Final check
          if(usingLeft){
           // if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_DOWN]){
              confidence=1;
              
           // }
          //  else{
             // confidence=0;
              
          //  }
          }
          else{
           // if(GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_DOWN]){
              confidence=1;
           // }
           // else{
              //confidence=0;
           // }
            
          }
         
         state=-1;
         duration=0;
         tempo=0; 
        }
        else{
          if(confidence<0.95){
            confidence+=0.001f;
          }
          else{
            confidence-=0.02f;
          }
        }
        
      }
    }
    
    prevJoints = joints;
    return confidence;
  }
  
  //Checks is birth is happening,
  //In this case hand is below elbow which is below shoulder at first 
  public boolean birthChecker(){
    if(state==-1){
      
      //If leftHand is below leftElbow which is below leftShoulder (or right)
      
      if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_DOWN] || GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_DOWN]){
          //birth is totes happening
          //print("Got the starter");
          state=0;
          confidence=0.3f;
          return true;
       }
    }
    else if(state==0){
      //If hand is higher than it was previously
      if(prevJoints[GestureInfo.LEFT_HAND]==null){
        
      }
      
      
      if((GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_RISING]) ||
        (GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_RISING])){
        //println("Got one of them rising");          
        duration++;
        
        if((GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_RISING]) ){
          PVector diffHand = PVector.sub(joints[GestureInfo.LEFT_HAND], prevJoints[GestureInfo.LEFT_HAND]);
          usingLeft=true;
          tempo+=diffHand.mag();
        }
        else{
          PVector diffHand = PVector.sub(joints[GestureInfo.RIGHT_HAND],prevJoints[GestureInfo.RIGHT_HAND]);
          usingLeft=false;
          tempo+=diffHand.mag();
        }
        return true;
      }
    }
    
    return false;
    //return true;
  }
  
  
  public boolean lifeChecker(){
    //If hand isn't going up anymore, that's a prerequisite
    if(state==0 || state==1){
      if(usingLeft){
        //If is moving back and forth
        println("Left hand moving left: "+GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_MOVING_LEFT]);
        println("Left hand moving right: "+GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_MOVING_RIGHT]);
        println("Left hand not down: "+!GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_DOWN]);
        
        if(((GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_MOVING_LEFT] || GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_MOVING_RIGHT])) ){
          print("Ever happening?");
          duration++;
          PVector handDiff = new PVector();
          handDiff = PVector.sub(joints[GestureInfo.LEFT_HAND],prevJoints[GestureInfo.LEFT_HAND]);
          tempo+=handDiff.mag();
          return true;
        }
      }
      else{
        println("Right hand moving left: "+GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_MOVING_LEFT]);
        println("Right hand moving right: "+GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_MOVING_RIGHT]);
        println("Right hand not down: "+!GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_DOWN]);
         if(((GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_MOVING_LEFT] || GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_MOVING_RIGHT])) ){
          duration++;
          PVector handDiff = new PVector();
          handDiff = PVector.sub(joints[GestureInfo.RIGHT_HAND],prevJoints[GestureInfo.RIGHT_HAND]);
          tempo+=handDiff.mag();
          return true;
        }
      }
    }
    
    
    return false;
  }
  
  
  public boolean deathChecker(){
    if(state==1 || state==2){
      
      //If hand is below shoulder
      if(usingLeft){
        if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_FALLING]){
          
          PVector diffHand = PVector.sub(joints[GestureInfo.LEFT_HAND],prevJoints[GestureInfo.LEFT_HAND]);
          usingLeft=true;
          tempo+=diffHand.mag();
          duration++;
          return true;
        }
        
      }
      else{
        if(GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_FALLING]){
          PVector diffHand = PVector.sub(joints[GestureInfo.RIGHT_HAND],prevJoints[GestureInfo.RIGHT_HAND]);
          usingLeft=false;
          tempo+=diffHand.mag();
          duration++;
          return true;
        }
      }
    }
    
    
    return false;
    
  }
}


/**
----------------------------------------------------------------------------------------------------------------
*/
public class Confusion extends Gesture{
  //And therefore right leg
  boolean usingLeftArm=false;

  
  
  public Confusion(){
    super();
    super.name="Confusion";
    prevJoints = new PVector[GestureInfo.JOINTS_LENGTH];
  }
  
  public float update(PVector[] joints){
    this.joints=joints;
    
    if(prevJoints[GestureInfo.LEFT_HAND]!=null){
      if(state==-1){
          confidence=0;
          if(birthChecker()){
            state=0;
          }
        
      }
      else if(state==0){
        boolean birthing = birthChecker();
        
        if(!birthing){
          if(lifeChecker()){
            state=1;
            confidence=0.5f;
          }
          else{
            state=-1;
            duration=0;
            tempo=0;
            confidence=0;
          }
        }
        else{
          if(confidence<0.3){
            confidence+=0.001f;
          }
          else{
            confidence=0;
            duration=0;
            tempo=0;
          }
        }
        
      }
      else if(state==1){
        
        boolean living =lifeChecker();
        
        if(!living){
          if(deathChecker()){
            state=2;
            confidence =0.8f;
          }
          else{
            state=-1;
            duration=0;
            tempo=0;
            confidence=0;
          }
        }
        else{
          if(confidence<0.6){
            confidence+=0.001f;
          }
          else{
            confidence-=0.02f;
          }
        }
        
      }
      else if(state==2){
        
        boolean dying = deathChecker();
        
        //If no longer dying, reset
        if(!dying){
          
           // if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_DOWN]){
              confidence=1;
          
         state=-1;
         duration=0;
         tempo=0; 
        }
        else{
          if(confidence<0.95){
            confidence+=0.001f;
          }
          else{
            confidence-=0.02f;
          }
        }
        
      }
    }
    
    prevJoints = joints;
    return confidence;
  }
  
  //Checks is birth is happening,
  //In this case hand is below elbow which is below shoulder at first 
  public boolean birthChecker(){
    if(state==-1){
      
      //If leftHand is below leftElbow which is below leftShoulder (or right)
      
      if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_DOWN] || GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_DOWN]){
          //birth is totes happening
          //print("Got the starter");
          state=0;
          confidence=0.3f;
          return true;
       }
    }
    else if(state==0){
      //If hand is higher than it was previously
      if(prevJoints[GestureInfo.LEFT_HAND]==null){
        
      }
      
      
      if((GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_RISING]) &&(GestureInfo.gesturePieces[GestureInfo.RIGHT_KNEE_GOING_BACK]) && 
      (!GestureInfo.gesturePieces[GestureInfo.LEFT_ARM_ANGLE_MED])||
        (GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_RISING])&&(GestureInfo.gesturePieces[GestureInfo.LEFT_KNEE_GOING_BACK])&& 
      (!GestureInfo.gesturePieces[GestureInfo.RIGHT_ARM_ANGLE_MED])){
        //println("Got one of them rising");          
        duration++;
        
        if((GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_RISING]) ){
          PVector diffHand = PVector.sub(joints[GestureInfo.LEFT_HAND], prevJoints[GestureInfo.LEFT_HAND]);
          usingLeftArm=true;
          tempo+=diffHand.mag();
        }
        else{
          PVector diffHand = PVector.sub(joints[GestureInfo.RIGHT_HAND],prevJoints[GestureInfo.RIGHT_HAND]);
          usingLeftArm=false;
          print("Confusion: Not using 'left'");
          tempo+=diffHand.mag();
        }
        return true;
      }
    }
    
    return false;
    //return true;
  }
  
  
  public boolean lifeChecker(){
    //If hand isn't going up anymore, that's a prerequisite
    if(state==0 || state==1){
      if(usingLeftArm){
        //If is moving back and forth
        if((GestureInfo.gesturePieces[GestureInfo.LEFT_ARM_ANGLE_DECREASING]) && !GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_DOWN]){
          
          duration++;
          PVector handDiff = new PVector();
          handDiff = PVector.sub(joints[GestureInfo.LEFT_HAND],prevJoints[GestureInfo.LEFT_HAND]);
          tempo+=handDiff.mag();
          return true;
        }
      }
      else{
         if((GestureInfo.gesturePieces[GestureInfo.RIGHT_ARM_ANGLE_DECREASING]) && !GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_DOWN]){
          duration++;
          PVector handDiff = new PVector();
          handDiff = PVector.sub(joints[GestureInfo.RIGHT_HAND],prevJoints[GestureInfo.RIGHT_HAND]);
          tempo+=handDiff.mag();
          return true;
        }
      }
    }
    
    
    return false;
  }
  
  
  public boolean deathChecker(){
    if(state==1 || state==2){
      
      //If hand is below shoulder
      if(usingLeftArm){
        if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_NEAR_HEAD] &&GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_STILL]){
          
          PVector diffHand = PVector.sub(joints[GestureInfo.LEFT_HAND],prevJoints[GestureInfo.LEFT_HAND]);
          usingLeftArm=true;
          tempo+=diffHand.mag();
          duration++;
          return true;
        }
        
      }
      else{
        if(GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_NEAR_HEAD] &&GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_STILL]){
          PVector diffHand = PVector.sub(joints[GestureInfo.RIGHT_HAND],prevJoints[GestureInfo.RIGHT_HAND]);
          usingLeftArm=false;
          tempo+=diffHand.mag();
          duration++;
          return true;
        }
      }
    }
    
    
    return false;
    
  }
}


/**
----------------------------------------------------------------------------------------------------------------
*/
public class Terror extends Gesture{
  //And therefore right leg

  
  
  public Terror(){
    super();
    super.name="Terror";
    prevJoints = new PVector[GestureInfo.JOINTS_LENGTH];
  }
  
  public float update(PVector[] joints){
    this.joints=joints;
    
    if(prevJoints[GestureInfo.LEFT_HAND]!=null){
      if(state==-1){
          confidence=0;
          if(birthChecker()){
            state=0;
          }
        
      }
      else if(state==0){
        boolean birthing = birthChecker();
        
        if(!birthing){
          if(lifeChecker()){
            state=1;
            confidence=0.5f;
          }
          else{
            state=-1;
            duration=0;
            tempo=0;
            confidence=0;
          }
        }
        else{
          if(confidence<0.3){
            confidence+=0.001f;
          }
          else{
            confidence=0;
            duration=0;
            tempo=0;
          }
        }
        
      }
      else if(state==1){
        
        boolean living =lifeChecker();
        
        if(!living){
          if(deathChecker()){
            state=2;
            confidence =0.8f;
          }
          else{
            state=-1;
            duration=0;
            tempo=0;
            confidence=0;
          }
        }
        else{
          if(confidence<0.6){
            confidence+=0.001f;
          }
          else{
            confidence-=0.02f;
          }
        }
        
      }
      else if(state==2){
        
        boolean dying = deathChecker();
        
        //If no longer dying, reset
        if(!dying){
          
              confidence=1;
          
         
         state=-1;
         duration=0;
         tempo=0; 
        }
        else{
          if(confidence<0.95){
            confidence+=0.001f;
          }
          else{
            confidence-=0.02f;
          }
        }
        
      }
    }
    
    prevJoints = joints;
    return confidence;
  }
  
  //Checks is birth is happening,
  //In this case hand is below elbow which is below shoulder at first 
  public boolean birthChecker(){
    if(state==-1){
      
      //If leftHand is below leftElbow which is below leftShoulder (or right)
      
      if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_DOWN] && GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_DOWN]){
          //birth is totes happening
          //print("Got the starter");
          state=0;
          confidence=0.3f;
          return true;
       }
    }
    else if(state==0){
      //If hand is higher than it was previously
      if(prevJoints[GestureInfo.LEFT_HAND]==null){
        
      }
      
      
      if((GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_RISING]) &&   
      (GestureInfo.gesturePieces[GestureInfo.LEFT_ARM_ANGLE_DECREASING])&&
        (GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_RISING])&& 
      (GestureInfo.gesturePieces[GestureInfo.RIGHT_ARM_ANGLE_DECREASING])){
        //println("Got one of them rising");          
        duration++;
        PVector diffHand = PVector.sub(joints[GestureInfo.LEFT_HAND], prevJoints[GestureInfo.LEFT_HAND]);
        tempo+=diffHand.mag();
        PVector diffHandR = PVector.sub(joints[GestureInfo.RIGHT_HAND],prevJoints[GestureInfo.RIGHT_HAND]);
       
          //Average of two vectors
        tempo+=(diffHand.mag()+diffHandR.mag())/2;
        
        return true;
      }
    }
    
    return false;
    //return true;
  }
  
  
  public boolean lifeChecker(){
    //If hand isn't going up anymore, that's a prerequisite
    if(state==0 || state==1){
        //If is moving back and forth
        if((GestureInfo.gesturePieces[GestureInfo.LEFT_ARM_ANGLE_MED]) && !GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_DOWN]
        && (GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_RISING]) && (GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_RISING])
    && (GestureInfo.gesturePieces[GestureInfo.RIGHT_ARM_ANGLE_MED]) && !GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_DOWN]){
          
          duration++;
          PVector handDiff = new PVector();
          
          //Average
          handDiff = PVector.sub(joints[GestureInfo.LEFT_HAND],prevJoints[GestureInfo.LEFT_HAND]);
          PVector handDiffR = PVector.sub(joints[GestureInfo.RIGHT_HAND],prevJoints[GestureInfo.RIGHT_HAND]);
          tempo+=(handDiff.mag()+handDiffR.mag());
          return true;
        }
     }
      
    
    
    
    return false;
  }
  
  
  public boolean deathChecker(){
    if(state==1 || state==2){
      
      if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_STILL]
      && GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_STILL]){
          
          PVector diffHand = PVector.sub(joints[GestureInfo.LEFT_HAND],prevJoints[GestureInfo.LEFT_HAND]);
          PVector diffHandR = PVector.sub(joints[GestureInfo.RIGHT_HAND],prevJoints[GestureInfo.RIGHT_HAND]);
          
          //Average
          tempo+=(diffHand.mag()+diffHandR.mag())/2;
          duration++;
          return true;
        }
        
      }
      
    
    
    
    return false;
    
  }
}

/**
----------------------------------------------------------------------------------------------------------------
*/
public class Sadness extends Gesture{
  //And therefore right leg

  
  
  public Sadness(){
    super();
    super.name="Sadness";
    prevJoints = new PVector[GestureInfo.JOINTS_LENGTH];
  }
  
  public float update(PVector[] joints){
    this.joints=joints;
    
    if(prevJoints[GestureInfo.LEFT_HAND]!=null){
      if(state==-1){
          confidence=0;
          if(birthChecker()){
            state=0;
          }
        
      }
      else if(state==0){
        boolean birthing = birthChecker();
        
        if(!birthing){
          if(lifeChecker()){
            state=1;
            confidence=0.5f;
          }
          else{
            state=-1;
            duration=0;
            tempo=0;
            confidence=0;
          }
        }
        else{
          if(confidence<0.3){
            confidence+=0.001f;
          }
          else{
            confidence-=0.02;
          }
        }
        
      }
      else if(state==1){
        
        boolean living =lifeChecker();
        
        if(!living){
          if(deathChecker()){
            state=2;
            confidence =0.8f;
          }
          else{
            state=-1;
            duration=0;
            tempo=0;
            confidence=0;
          }
        }
        else{
          if(confidence<0.6){
            confidence+=0.001f;
          }
          else{
            confidence-=0.02f;
          }
        }
        
      }
      else if(state==2){
        
        boolean dying = deathChecker();
        
        //If no longer dying, reset
        if(!dying){
          
              confidence=1;
          
         
         state=-1;
         duration=0;
         tempo=0; 
        }
        else{
          if(confidence<0.95){
            confidence+=0.001f;
          }
          else{
            confidence-=0.02f;
          }
        }
        
      }
    }
    
    prevJoints = joints;
    return confidence;
  }
  
  //Checks is birth is happening,
  //In this case hand is below elbow which is below shoulder at first 
  public boolean birthChecker(){
    if(state==-1){
      
      //If leftHand is below leftElbow which is below leftShoulder (or right)
     // println("Ever got hands together?: "+GestureInfo.gesturePieces[GestureInfo.HANDS_TOGETHER]);
      if(GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_DOWN] && GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_DOWN]
      && GestureInfo.gesturePieces[GestureInfo.HANDS_TOGETHER] ){
        
          //birth is totes happening
          //print("Got the starter");
          state=0;
          confidence=0.3f;
          return true;
       }
    }
    else if(state==0){
      //If hand is higher than it was previously
      if(prevJoints[GestureInfo.LEFT_HAND]==null){
        
      }
      
      
      if((GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_RISING]) && 
        (GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_RISING])&& 
        GestureInfo.gesturePieces[GestureInfo.HANDS_TOGETHER] && 
        !GestureInfo.gesturePieces[GestureInfo.HANDS_ABOVE_HEAD]){
        //println("Got one of them rising");          
        duration++;
        PVector diffHand = PVector.sub(joints[GestureInfo.LEFT_HAND], prevJoints[GestureInfo.LEFT_HAND]);
        tempo+=diffHand.mag();
        PVector diffHandR = PVector.sub(joints[GestureInfo.RIGHT_HAND],prevJoints[GestureInfo.RIGHT_HAND]);
       
          //Average of two vectors
        tempo+=(diffHand.mag()+diffHandR.mag())/2;
        
        return true;
      }
    }
    
    return false;
    //return true;
  }
  
  
  public boolean lifeChecker(){
    //If hand isn't going up anymore, that's a prerequisite
    if(state==0 || state==1){
        //If is moving back and forth
        if((GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_RISING]) && 
        (GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_RISING])&& 
        GestureInfo.gesturePieces[GestureInfo.HANDS_TOGETHER] && 
        GestureInfo.gesturePieces[GestureInfo.HANDS_ABOVE_HEAD]){
          
          duration++;
          PVector handDiff = new PVector();
          
          //Average
          handDiff = PVector.sub(joints[GestureInfo.LEFT_HAND],prevJoints[GestureInfo.LEFT_HAND]);
          PVector handDiffR = PVector.sub(joints[GestureInfo.RIGHT_HAND],prevJoints[GestureInfo.RIGHT_HAND]);
          tempo+=(handDiff.mag()+handDiffR.mag());
          return true;
        }
     }
      
    
    
    
    return false;
  }
  
  
  public boolean deathChecker(){
    if(state==1 || state==2){
      
      if(GestureInfo.gesturePieces[GestureInfo.HANDS_ABOVE_HEAD] && GestureInfo.gesturePieces[GestureInfo.LEFT_HAND_STILL]
      && GestureInfo.gesturePieces[GestureInfo.RIGHT_HAND_STILL]){
          
          PVector diffHand = PVector.sub(joints[GestureInfo.LEFT_HAND],prevJoints[GestureInfo.LEFT_HAND]);
          PVector diffHandR = PVector.sub(joints[GestureInfo.RIGHT_HAND],prevJoints[GestureInfo.RIGHT_HAND]);
          
          //Average
          tempo+=(diffHand.mag()+diffHandR.mag())/2;
          duration++;
          return true;
        }
        
      }
      
    
    
    
    return false;
    
  }
}
