class PlantNode
{
  ArrayList<PlantNode> connectedNodes = new ArrayList<PlantNode>();
  
  public float[] pos = new float[3];
  public float[] force = new float[3];
  
  void update()
  {
    pos[0]+=force[0]/10;
    pos[1]+=force[1]/10;
    pos[2]+=force[2]/10;
    force[0]*=.99;
    force[1]*=.99;
    force[2]*=.99;
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
