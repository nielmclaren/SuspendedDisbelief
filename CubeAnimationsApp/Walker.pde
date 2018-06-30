
class Walker {
  Box box;
  public int vertexIndex0;
  public int vertexIndex1;
  public float t;
  
  Walker(Box boxArg) {
    box = boxArg;
    vertexIndex0 = box.getRandomVertexIndex();
    vertexIndex1 = box.getRandomAdjacentVertexIndex(vertexIndex0);
    t = 0;
  }

  void advance(float dt) {
    t += dt;

    while (t >= 1) {
      int nextVertexIndex = box.getRandomAdjacentVertexIndexExcept(vertexIndex1, vertexIndex0);
      vertexIndex0 = vertexIndex1;
      vertexIndex1 = nextVertexIndex;
      t -= 1;
    }
  }

  PVector getPoint() {
    PVector p0 = box.getVertexPoint(vertexIndex0);
    PVector p1 = box.getVertexPoint(vertexIndex1);
    return PVector.add(p0, PVector.mult(PVector.sub(p1, p0), t));
  }
}