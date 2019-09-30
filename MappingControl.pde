// video mapping
int canvasW = 7680;
int canvasH = 1080;
MappingControl mappingControl;

void
setupVideoMapping()
{
  canvas = createGraphics(canvasW,canvasH,P3D);
  mappingControl = new MappingControl(this, sketchName);
}

class MappingControl
{
  //SyphonServer syphonServer;
  Spout spout;
  
  final int controlPort = 8400;
  NetAddress controlAddress;
  PGraphics canvas;

  public MappingControl(PApplet pApplet, String pSketchName)
  {
    //syphonServer = new SyphonServer(pApplet, "Processing Syphon");
    spout = new Spout(pApplet);
    spout.createSender("Processing Spout");
    
    controlAddress = new NetAddress("127.0.0.1", controlPort);
 
    //OscMessage videoMapperMessage = new OscMessage("/SwitchSyphonClient");
    //videoMapperMessage.add(pSketchName); //It must contain the same name as the Sketch
    //videoMapperMessage.add("Processing Syphon");
    //videoMapperMessage.add(1.0);
    
    OscMessage videoMapperMessage = new OscMessage("/SwitchSpoutSender");
    videoMapperMessage.add(pSketchName); //It must contain the same name as the Sketch
    videoMapperMessage.add("Processing Spout");
    
    oscCom.send(videoMapperMessage, controlAddress); 
  }
  
  public void update(PGraphics pCanvas)
  {
      //syphonServer.sendImage(pCanvas);
      spout.sendTexture(pCanvas);
  }
  
};