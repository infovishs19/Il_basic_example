AudioControl audioControl;

void
setupAudio()
{
  audioControl = new AudioControl();
  audioControl.loadAudioFiles(audioFilePath);
  
  for(int i=0; i<audioControl.maxVoiceCount; ++i)
  {
    audioControl.setVoiceBuffer(i + 1, (i + 1) % 8 + 1);
    audioControl.setVoiceLoop(i + 1,false);
  }
}

class AudioControl
{
  final int controlPort = 23456;
  NetAddress controlAddress;
  int maxVoiceCount = 32;
  
  public AudioControl()
  {
    controlAddress = new NetAddress("127.0.0.1", controlPort);
    //stopAllAudio();
  }
  
 public void loadAudioFiles(String pFilePath)
 {
    String messageAddress = "/global";
    OscMessage message = new OscMessage(messageAddress);
    message.add("load");
    message.add(pFilePath);
    
    oscCom.send(message, controlAddress);
 }
 
 public void setMasterVolume(float pVolume)
 {
    String messageAddress = "/global";
    OscMessage message = new OscMessage(messageAddress);
    message.add("volume");
    message.add(pVolume);
    
    oscCom.send(message, controlAddress);
 }
 
 public void stopAllAudio()
 {
    String messageAddress = "/global";
    OscMessage message = new OscMessage(messageAddress);
    message.add("stopall");
    
    oscCom.send(message, controlAddress);
 }
 
 public void setVoiceBuffer(int pVoiceIndex, int pBufferIndex)
 {
    String messageAddress = "/voice";
    OscMessage message = new OscMessage(messageAddress);
    message.add(pVoiceIndex);
    message.add("buffer");
    message.add(pBufferIndex);
    
    oscCom.send(message, controlAddress);
 }
 
 public void startVoice(int pVoiceIndex)
 {
    String messageAddress = "/voice";
    OscMessage message = new OscMessage(messageAddress);
    message.add(pVoiceIndex);
    message.add("start");
    
    oscCom.send(message, controlAddress);
 }
 
 public void stopVoice(int pVoiceIndex)
 {
    String messageAddress = "/voice";
    OscMessage message = new OscMessage(messageAddress);
    message.add(pVoiceIndex);
    message.add("stop");
    
    oscCom.send(message, controlAddress);
 }
 
  public void setVoiceLoop(int pVoiceIndex, boolean pLoop)
  {
    String messageAddress = "/voice";
    OscMessage message = new OscMessage(messageAddress);
    message.add(pVoiceIndex);
    message.add("loop");
    if(pLoop == true) message.add(1); 
    else message.add(0);
    
    oscCom.send(message, controlAddress);
  }
  
  public void setVoiceVolume(int pVoiceIndex, float pVolume)
  {
    if(pVolume < 0.0) pVolume = 0.0;
    else if(pVolume > 1.0) pVolume = 1.0;

    String messageAddress = "/voice";
    OscMessage message = new OscMessage(messageAddress);
    message.add(pVoiceIndex);
    message.add("volume");
    message.add(pVolume); 
    
    oscCom.send(message, controlAddress);
  }
  
  public void setVoicePosition(int pVoiceIndex, float pPosX, float pPosY)
  {
  
    String messageAddress = "/voice";
  
    OscMessage message1 = new OscMessage(messageAddress);
    message1.add(pVoiceIndex);
    message1.add("azi");
    message1.add(pPosX);
    oscCom.send(message1, controlAddress);
    
    OscMessage message2 = new OscMessage(messageAddress);
    message2.add(pVoiceIndex);
    message2.add("ele");
    message2.add(pPosY);
    oscCom.send(message2, controlAddress);
  }
 
};