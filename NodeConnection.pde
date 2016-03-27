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
    distance = dist(node1.pos[0],node1.pos[1],node1.pos[2],
                          node2.pos[0],node2.pos[1],node2.pos[2]);
    return springForce*(relaxedLength-distance); 
  }
  
  void update()
  {
    float f = getCurrentForce();
    float[] toNode1 = new float[]{node1.pos[0]-node2.pos[0],
                                  node1.pos[1]-node2.pos[1],
                                  node1.pos[2]-node2.pos[2]};
    toNode1[0] *= f/distance;
    toNode1[1] *= f/distance;
    toNode1[2] *= f/distance;
    
    node1.addForce(toNode1);
    
    float[] toNode2 = new float[]{node2.pos[0]-node1.pos[0],
                                  node2.pos[1]-node1.pos[1],
                                  node2.pos[2]-node1.pos[2]};
    toNode2[0] *= f/distance;
    toNode2[1] *= f/distance;
    toNode2[2] *= f/distance;
    
    node2.addForce(toNode2);   
  }
  
  void draw()
  {
    stroke(100);
    beginShape(LINES);
    vertex(node1.pos[0],node1.pos[1],node1.pos[2]);
    vertex(node2.pos[0],node2.pos[1],node2.pos[2]);
    endShape();
  }
}
