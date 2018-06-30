
class Walker {
  Box box;
  public int vertex0;
  public int vertex1;
  public float t;
  
  Walker(Box boxArg) {
    box = boxArg;
    vertex0 = box.getRandomVertex();
    vertex1 = box.getRandomAdjacentVertex(vertex0);
    t = 0;
  }

  void advance(float dt) {
    t += dt;

    while (t >= 1) {
      int nextVertex = box.getRandomAdjacentVertexExcept(vertex1, vertex0);
      vertex0 = vertex1;
      vertex1 = nextVertex;
      t -= 1;
    }
  }

  PVector getPoint() {
    PVector p0 = box.getVertexPoint(vertex0);
    PVector p1 = box.getVertexPoint(vertex1);
    return PVector.add(p0, PVector.mult(PVector.sub(p1, p0), t));
  }
}