// Simple bouncing balls
ArrayList<Ball> balls;
int ballWidth = 48;

void
setupContent()
{
  // Create an empty ArrayList (will store Ball objects)
  balls = new ArrayList<Ball>();
  
  // Start by adding one element
  balls.add(new Ball(0, width/2, 0, ballWidth));
}

void
udpateContent()
{
  for (int i = balls.size()-1; i >= 0; i--) 
  {   
    Ball ball = balls.get(i);
    ball.move();
    
    if (ball.finished()) 
    {
      balls.remove(i);
    }
  } 
}

void 
updateContent(TouchPoint[] touchPoints)
{
  for(int i=0; i<touchPoints.length; ++i) 
  {
      TouchPoint touchPoint = touchPoints[i];
    
      //if(touchPoint.born == true || touchPoint.alive == true)
      if(touchPoint.born == true)
      {
        float ballPosX = floor(map(touchPoint.xPos,0,4,0,canvasW));
        float ballPosY = floor(map(touchPoint.yPos,0,1,0,canvasH));
      
        balls.add(new Ball(balls.size(), ballPosX, ballPosY, ballWidth));
      }
  }  
}

void
drawContent()
{
  for (int i = balls.size()-1; i >= 0; i--) 
  {   
    Ball ball = balls.get(i);
    ball.display();
  }
}

class Ball 
{  
  int id;
  float x;
  float y;
  float w;
  float speed;
  float gravity;
  float damping;
  float life;
  
  Ball(int pId, float pX, float pY, float pW) 
  {
    id = pId;
    x = pX;
    y = pY;
    w = pW;
    speed = 0;
    gravity = 0.1;
    damping = 0.8;
    life = 255;
  }
  
  void move() 
  {
    // Add gravity to speed
    speed = speed + gravity;
    // Add speed to y location
    y = y + speed;
    // If square reaches the bottom
    // Reverse speed
    if (y > canvasH) 
    {
      // Damping
      speed = speed * -damping;
      y = canvasH;
      
      sound();
    }
  }
  
  boolean finished() 
  {
    // Balls fade out
    life--;
    return life < 0;
  }
  
  void display() 
  {
    // Display the circle
    canvas.fill(0,life);
    //stroke(0,life);
    canvas.ellipse(x,y,w,w);
  }
  
  void sound()
  {
    int voiceId = (id + 1) % audioControl.maxVoiceCount;
    float voicePosX = x / canvasW * 4.0;
    
    audioControl.setVoicePosition(voiceId,voicePosX,0.5);
    audioControl.startVoice(voiceId);
  }
} 