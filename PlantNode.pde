class PlantNode
{
  ArrayList<NodeConnection> childConnections = new ArrayList<NodeConnection>();
  
  public float[] pos = new float[3];
  public float[] force = new float[3];
  public float[] growDir = new float[]{random(1),random(1),0};
  public float updateCounter = random(10);
  
  void update(float elapsedSeconds)
  {
    if(updateCounter < 0)
    {
//      for(NodeConnection c : childConnections)
//    { c.relaxedLength += .02; }
      //updateCounter = random(10);
    }
    else
    {
      updateCounter -= elapsedSeconds;
    }
    pos[0]+=elapsedSeconds*force[0];
    pos[1]+=elapsedSeconds*force[1];
    pos[2]+=elapsedSeconds*force[2];
  }
  
  void draw()
  {
    stroke(0);
    pushMatrix();
    translate(pos[0],pos[1],pos[2]);
    ellipse(0,0,5,5);
    popMatrix();
  }
  
  void addForce(float[] newForce)
  {
    force[0]+=newForce[0];
    force[1]+=newForce[1];
    force[2]+=newForce[2];
  }
}
