TrackingControl trackingControl;

void
setupTracking()
{
  trackingControl = new TrackingControl(trackingMode);
}

class TouchPoint
{
  boolean alive;
  boolean born;
  boolean died;
  public int id;
  public float xPos;
  public float yPos;
  public float xVel;
  public float yVel;
  
  public TouchPoint(int pId, float pXCoord, float pYCoord)
  {
    id = pId;
    xPos = pXCoord;
    yPos = pYCoord;
    xVel = 0.0;
    yVel = 0.0;
    alive = false;
    born = false;
    died = false;
  }
  
  public TouchPoint( TouchPoint pPoint )
  {
    id = pPoint.id;
    xPos = pPoint.xPos;
    yPos = pPoint.yPos;
    xVel = pPoint.xVel;
    yVel = pPoint.yVel;
    alive = pPoint.alive;
    born = pPoint.born;
    died = pPoint.died;
  }
};

class TrackingControl
{
  final int maxTouchPointCount = 800;
  ArrayList<Integer> alivePointIds;
  ArrayList<Integer> bornPointIds;
  ArrayList<Integer> diedPointIds;
  TouchPoint[] touchPoints;
  boolean updated = false;
  
  final int controlPort = 64000;
  NetAddress controlAddress;

  public TrackingControl(int pTrackingMode)
  {   
    alivePointIds = new ArrayList<Integer>();
    bornPointIds = new ArrayList<Integer>();
    diedPointIds = new ArrayList<Integer>();
    touchPoints = new TouchPoint[maxTouchPointCount];
    
    for (int i=0; i<maxTouchPointCount; ++i)
    {
      touchPoints[i] = new TouchPoint(-1, 0.0, 0.0);
    }

    controlAddress = new NetAddress("127.0.0.1", controlPort);

    OscMessage oscMessage = new OscMessage("/trackerMaster/requestTuiostream");
    oscMessage.add(oscReceivePort);
    if (pTrackingMode == 0) oscMessage.add(0); // point mode
    else if (pTrackingMode == 1) oscMessage.add(1); // cluster mode
    oscCom.send(oscMessage, controlAddress);
  }

  public void update(OscMessage oscMessage)
  {
    String oscAddress = oscMessage.addrPattern();

    if ( oscAddress.equals("/tuio/2Dcur") )
    {
      String label = oscMessage.get(0).stringValue();

      if (label.equals("fseq"))
      {
        // reset status of all touch points
        for (int i=0; i<maxTouchPointCount; ++i)
        {
          touchPoints[i].alive = false;
          touchPoints[i].born = false;
          touchPoints[i].died = false;
        }

        // update status of all touch points
        for (int i=0; i<alivePointIds.size(); ++i)
        {
          int touchId = alivePointIds.get(i);
          touchPoints[touchId].alive = true;
        }

        for (int i=0; i<bornPointIds.size(); ++i)
        {
          int touchId = bornPointIds.get(i);
          touchPoints[touchId].born = true;
        }

        for (int i=0; i<diedPointIds.size(); ++i)
        {
          int touchId = diedPointIds.get(i);
          touchPoints[touchId].died = true;
        }

        alivePointIds.clear();
        bornPointIds.clear();
        diedPointIds.clear();

        updated = true;
      } 
      else
      {
        updated = false;

        if (label.equals("alive"))
        {
          for (int aI=1; aI<oscMessage.arguments().length; ++aI)
          {
            int touchId = oscMessage.get(aI).intValue();
            alivePointIds.add(touchId);
          }
        } 
        else if (label.equals("born"))
        {
          for (int aI=1; aI<oscMessage.arguments().length; ++aI)
          {
            int touchId = oscMessage.get(aI).intValue();
            bornPointIds.add(touchId);
          }
        } 
        else if (label.equals("died"))
        {
          for (int aI=1; aI<oscMessage.arguments().length; ++aI)
          {
            int touchId = oscMessage.get(aI).intValue();
            diedPointIds.add(touchId);
          }
        } 
        else if (label.equals("set"))
        {
          int touchId = oscMessage.get(1).intValue(); 
          TouchPoint touchPoint = touchPoints[touchId];  
          touchPoint.xPos = oscMessage.get(2).floatValue();
          touchPoint.yPos = oscMessage.get(3).floatValue();
          touchPoint.xVel = oscMessage.get(4).floatValue();
          touchPoint.yVel = oscMessage.get(5).floatValue();
        }
      }
    }
  }
};