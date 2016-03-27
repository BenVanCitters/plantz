import java.util.Collections;
import java.util.Comparator;
class Plant
{
  ArrayList<PlantNode> nodes = new ArrayList<PlantNode>();
  ArrayList<NodeConnection> nodeConnections = new ArrayList<NodeConnection>();
  
  public Plant()
  {
    
  }
  
  void update()
  {
    for(NodeConnection c : nodeConnections)
    {
      c.update();
    }
    
    for(PlantNode p : nodes)
    {
      p.update();
    }
  }
  
  void draw()
  {
    for(NodeConnection c : nodeConnections)
    {
      c.draw();
    }
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
                                    
        return (int)(distanceSq1-distanceSq2);
      }});
    return newNodes;
  }
}
