//basically a spring holding two nodes together
class NodeConnection
{
  float springForce = 0;
  float relaxedLength = 0;
  float distance = 0;
  
  PlantNode node1;
  PlantNode node2;
  
  float getCurrentForce()
  {
    distance = dist(node1.pos[0], node1.pos[1], node1.pos[2],
                    node2.pos[0], node2.pos[1], node2.pos[2]);
    return springForce*(relaxedLength-distance); 
  }
  
  void update(float elapsedSeconds)
  {
    float f = getCurrentForce();
    float[] toNode1 = new float[]{node1.pos[0]-node2.pos[0],
                                  node1.pos[1]-node2.pos[1],
                                  node1.pos[2]-node2.pos[2]};
    toNode1[0] *= f/distance;
    toNode1[1] *= f/distance;
    toNode1[2] *= f/distance;
    
    node1.addForce(toNode1);
    
    toNode1[0] *= -1;
    toNode1[1] *= -1;
    toNode1[2] *= -1;
    
    node2.addForce(toNode1);   
  }
  
  void draw()
  {
    vertex(node1.pos[0],node1.pos[1],node1.pos[2]);
    vertex(node2.pos[0],node2.pos[1],node2.pos[2]);
  }
}
