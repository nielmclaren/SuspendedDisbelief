
class Snake {
  private Box box;
  private float length;
  private float start;
  private ArrayList<Integer> vertices;

  Snake(Box boxArg, float lengthArg) {
    box = boxArg;
    length = lengthArg;
    start = 0;

    int vertex = box.getRandomVertex();
    vertices = new ArrayList<Integer>();
    vertices.add(vertex);
    vertices.add(box.getRandomAdjacentVertex(vertex));
    updateVertices();
  }

  void advance(float dt) {
    start += dt;

    while (start >= 1) {
      vertices.remove(0);
      start -= 1;
    }

    updateVertices();
  }

  private void updateVertices() {
    while (vertices.size() < start + length + 1) {
      vertices.add(box.getRandomAdjacentVertexExcept(getLastVertex(), getSecondLastVertex()));
    }
  }

  PVector getStartPoint() {
    PVector p0 = box.getVertexPoint(vertices.get(0));
    PVector p1 = box.getVertexPoint(vertices.get(1));
    return getPoint(p0, p1, start);
  }

  PVector getEndPoint() {
    PVector p0 = box.getVertexPoint(getSecondLastVertex());
    PVector p1 = box.getVertexPoint(getLastVertex());
    return getPoint(p0, p1, (start + length) % 1);
  }

  private PVector getPoint(PVector p0, PVector p1, float t) {
    return PVector.add(p0, PVector.mult(PVector.sub(p1, p0), t));
  }

  private int getSecondLastVertex() {
    return vertices.get(vertices.size() - 2);
  }

  private int getLastVertex() {
    return vertices.get(vertices.size() - 1);
  }
}