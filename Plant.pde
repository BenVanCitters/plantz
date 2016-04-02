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
    int iC = 70-nodeConnections.size();
    for(NodeConnection c : nodeConnections)
    { 
      c.update(elapsedSeconds); 
      if(++iC > 0)
      {
        c.relaxedLength += .6; 
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
        PlantNode new1 = sprout(pn);
        PlantNode new2 = sprout(pn);
        newNodes.add(new1);
        newNodes.add(new2);
        
        connect(new1,new2,1000);
      }
    }
    nodes.addAll(newNodes);
  }
  
  NodeConnection connect(PlantNode nodeA, PlantNode nodeB, float minDist)
  {
    NodeConnection con1 = new NodeConnection();
    con1.node1 = nodeA;
    con1.node2 = nodeB;
    float distance = dist(nodeA.pos[0],nodeA.pos[1],nodeA.pos[2],
                          nodeB.pos[0],nodeB.pos[1],nodeB.pos[2]);
    con1.relaxedLength = distance;// + random(-distance*.8,distance*.8);
    con1.springForce = .8;
    if(distance < minDist)
    {
      addConnection(con1);
      return con1;
    }
    return null;
  }
  
  PlantNode sprout(PlantNode node)
  {
    PlantNode newNode = new PlantNode();
//    println("node.growDir[]: " + node.growDir[0] + "," + node.growDir[1] + "," + node.growDir[2] );
    float rndAmt = .05;
    newNode.pos = new float[]{node.pos[0] + node.force[0]/2+(random(rndAmt)-rndAmt/2),
                              node.pos[1] + node.force[1]/2+(random(rndAmt)-rndAmt/2),
                              node.pos[2] + node.force[2]/2+(random(rndAmt)-rndAmt/2)};
                              
    node.childConnections.add(connect(node, newNode,10000));
    
    ArrayList<PlantNode> tmp= getNearestNeighbors( newNode.pos);
    int count = min(tmp.size(),5);
  for(int i = 0; i < count; i++)
//  for(PlantNode nd : tmp)
    {
      connect(newNode,tmp.get(i),20);
    }
    return newNode;
  }
  
  void addConnection(NodeConnection con)
  {
    //make sure that we don't add duplicate connections
    for(NodeConnection oldCon : nodeConnections)
    {
      if(oldCon.node1 == con.node1 && oldCon.node2 == con.node2)
        return;
      if(oldCon.node2 == con.node1 && oldCon.node1 == con.node2)
        return;
    }
    nodeConnections.add(con);
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
//      p.draw();
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
