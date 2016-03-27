Plant p = new Plant();

void fillInNodes()
{
 PlantNode starterNode = new PlantNode();
    starterNode.pos = new float[]{250,250,0};
    p.nodes.add(starterNode);
    
    PlantNode starterNode1 = new PlantNode();
    starterNode1.pos = new float[]{270,270,0};
    p.nodes.add(starterNode1);

    PlantNode starterNode3 = new PlantNode();
    starterNode3.pos = new float[]{50,300,0};
    p.nodes.add(starterNode3);
    
    NodeConnection con1 = new NodeConnection();
    con1.node1 = starterNode;
    con1.node2 = starterNode1;
    con1.relaxedLength = 20;
    con1.springForce = .8;
    p.nodeConnections.add(con1);
    
    NodeConnection con2 = new NodeConnection();
    con2.node1 = starterNode3;
    con2.node2 = starterNode1;
    con2.relaxedLength = 20;
    con2.springForce = .8;
    p.nodeConnections.add(con2);
    
    NodeConnection con3 = new NodeConnection();
    con3.node1 = starterNode3;
    con3.node2 = starterNode;
    con3.relaxedLength = 20;
    con3.springForce = .8;
    p.nodeConnections.add(con3); 
}


void setup()
{
  size(500,500,P3D);
  fillInNodes();
}

void draw()
{
  long start = millis();
  
//  fill(0,0,0,10);
//  rect(0,0,width,height);
  background(0);
  p.update();
  p.draw();
  debugPrint(millis()-start);
  
//  noStroke();
//  fill(255,150);
//ellipse(mouseX,mouseY,60*2,60*2);
  if(mousePressed)
  {
    newPoint();
  }
}

void debugPrint(long frameDuration)
{
  println("framerate: " + frameRate + " frameDuration(millis): " + frameDuration);
  println("nodeCount: " + p.nodes.size());
  println("connectionCount: " + p.nodeConnections.size());
}

void mousePressed()
{
  
}
void newPoint()
{
  float[] mousePos = new float[]{mouseX,mouseY,random(1)}; 
  ArrayList<PlantNode> tmp= p.getNearestNeighbors(mousePos);
//  if(tmp.size()>3)
  {
    PlantNode newNode = new PlantNode();
    newNode.pos = mousePos;
    p.nodes.add(newNode);
    
    int count = min(tmp.size(),6);
    for(int i = 0; i < count; i++)
    {
      NodeConnection con1 = new NodeConnection();
      con1.node1 = newNode;
      con1.node2 = tmp.get(i);
      float distance = dist(con1.node1.pos[0],con1.node1.pos[1],con1.node1.pos[2],
                            con1.node2.pos[0],con1.node2.pos[1],con1.node2.pos[2]);
      con1.relaxedLength = distance + random(-distance*.8,distance*.8);
      con1.springForce = .8;
      if(distance < 60)
        p.nodeConnections.add(con1);
    }
  }
}
