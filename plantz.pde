Plant p = new Plant();
long lastNanoTimeStamp;

void setup()
{
  size(700,700,OPENGL);
  fillInNodes();
  lastNanoTimeStamp = System.nanoTime();
}

void fillInNodes()
{
  PlantNode starterNode = new PlantNode();
  starterNode.pos = new float[]{0,0,0};
  p.nodes.add(starterNode);
}

void draw()
{
  long start = System.nanoTime();
  float elapsedSeconds = (start-lastNanoTimeStamp)/1000000000.f;
  p.update(elapsedSeconds);
  long updateDuration = System.nanoTime()-start;
  
  start = System.nanoTime();
  background(0);
  pushMatrix();
  translate(width/2,height/2);
  rotateX(millis()/5000.f);
  rotateZ(millis()/5000.f);
  p.draw();
  popMatrix();
  long drawDuration = System.nanoTime()-start;
  debugPrint(updateDuration,drawDuration);
  
//  noStroke();
//  fill(255,150);
//ellipse(mouseX,mouseY,60*2,60*2);
  if(mousePressed)
  {
    newPoint(new float[]{mouseX-width/2,mouseY-height/2,random(1)});
//    for(int i = 0; i < 100; i++)
//      newPoint(new float[]{random(width),random(height),random(1)});
  }
  lastNanoTimeStamp = System.nanoTime();
}

void debugPrint(long updateDuration, long drawDuration)
{
  println("framerate: " + frameRate + " updateTime(millis): " + updateDuration/1000000.f + 
          " drawTime(millis): " + drawDuration/1000000.f);
  println("nodeCount: " + p.nodes.size());
  println("connectionCount: " + p.nodeConnections.size());
}

void mousePressed()
{
  
}
void newPoint(float[] pos)
{
  ArrayList<PlantNode> tmp= p.getNearestNeighbors(pos);

  PlantNode newNode = new PlantNode();
  newNode.pos = pos;
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
//    if(distance < 60)
      p.nodeConnections.add(con1);
  }

}
