import java.util.Collections;
import java.util.Comparator;
class Plant
{
  ArrayList<PlantNode> nodes = new ArrayList<PlantNode>();
  ArrayList<NodeConnection> nodeConnections = new ArrayList<NodeConnection>();
  
  public Plant()
  {
    
  }
  
  void update(float elapsedSeconds)
  {
    //update physics
    int iC = 10-nodeConnections.size();
    for(NodeConnection c : nodeConnections)
    { 
      c.update(elapsedSeconds); 
      if(++iC > 0)
      {
        c.relaxedLength += .1; 
      } 
    }
    
    ArrayList<PlantNode> newNodes = new ArrayList<PlantNode>();
    
    float forceDamping = .99;
    for(PlantNode pn : nodes)
    { 
      pn.update(elapsedSeconds); 
      pn.force[0]*=forceDamping; pn.force[1]*=forceDamping; pn.force[2]*=forceDamping;
      if(pn.updateCounter < 0 && pn.childConnections.size() < 1)
      {
        newNodes.add(sprout(pn));
      }
    }
    nodes.addAll(newNodes);
  }
  
  PlantNode sprout(PlantNode node)
  {
    PlantNode newNode = new PlantNode();
//    println("node.growDir[]: " + node.growDir[0] + "," + node.growDir[1] + "," + node.growDir[2] );
    newNode.pos = new float[]{node.pos[0] + node.growDir[0]+(random(.1)-.05),
                              node.pos[1] + node.growDir[1]+(random(.1)-.05),
                              node.pos[2] + node.growDir[2]+(random(.1)-.05)};
                              
    newNode.growDir[0] = node.growDir[0];
    newNode.growDir[1] = node.growDir[1];
    newNode.growDir[2] = node.growDir[2];

    NodeConnection con1 = new NodeConnection();
    con1.node1 = newNode;
    con1.node2 = node;
    float distance = dist(con1.node1.pos[0],con1.node1.pos[1],con1.node1.pos[2],
                          con1.node2.pos[0],con1.node2.pos[1],con1.node2.pos[2]);
    con1.relaxedLength = distance;// + random(-distance*.8,distance*.8);
    con1.springForce = .8;
//    if(distance < 60)
    nodeConnections.add(con1);
    node.childConnections.add(con1);
    return newNode;
  }
  
  void draw()
  {
    stroke(255);
    beginShape(LINES);
    for(NodeConnection c : nodeConnections)
    {
      c.draw();
    }
    endShape();
    for(PlantNode p : nodes)
    {
      p.draw();
    }
  }
  
  //operation to get nearby neighbors to connect to when adding 
  // random nodes in to the scene
  ArrayList<PlantNode> getNearestNeighbors(final float[] pos)
  {
    ArrayList<PlantNode> newNodes = new ArrayList<PlantNode>(nodes);
    // Sorting
    Collections.sort(newNodes, new Comparator<PlantNode>() 
    {
      @Override
      public int compare(PlantNode node1, PlantNode node2)
      {
        float[] diff1 = new float[]{pos[0]-node1.pos[0],
                                    pos[1]-node1.pos[1],
                                    pos[2]-node1.pos[2]};
        float distanceSq1 =diff1[0]*diff1[0]+diff1[1]*diff1[1]+diff1[2]*diff1[2];
        float[] diff2 = new float[]{pos[0]-node2.pos[0],
                                    pos[1]-node2.pos[1],
                                    pos[2]-node2.pos[2]};
       float distanceSq2 = diff2[0]*diff2[0]+diff2[1]*diff2[1]+diff2[2]*diff2[2];
                                    
        return (int)(100*(distanceSq1-distanceSq2));
      }});
    return newNodes;
  }
}
