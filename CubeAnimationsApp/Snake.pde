
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
    updateVertices();
  }

  Snake(Box boxArg, float lengthArg, int vertex0, int vertex1) {
    box = boxArg;
    length = lengthArg;
    start = 0;

    int vertex = box.getRandomVertex();
    vertices = new ArrayList<Integer>();
    vertices.add(vertex0);
    vertices.add(vertex1);
    updateVertices();
  }

  float getStart() {
    return start;
  }

  void setStart(float v) {
    start = v;

    while (start >= 1) {
      vertices.remove(0);
      start -= 1;
    }

    updateVertices();
  }

  float getLength() {
    return length;
  }

  void setLength(float v) {
    length = v;
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
    int targetCount = max(2, ceil(start + length) + 1);
    while (vertices.size() > targetCount) {
      vertices.remove(vertices.size() - 1);
    }
    while (vertices.size() < targetCount) {
      vertices.add(generateNextVertex());
    }
  }

  private int generateNextVertex() {
    if (vertices.size() > 1) {
      return box.getRandomAdjacentVertexExcept(getLastVertex(), getSecondLastVertex());
    }
    return box.getRandomAdjacentVertex(getLastVertex());
  }

  PVector getStartPoint() {
    PVector p0 = getVertexPoint(vertices.get(0));
    PVector p1 = getVertexPoint(vertices.get(1));
    return getPoint(p0, p1, start);
  }

  PVector getEndPoint() {
    PVector p0 = getVertexPoint(getSecondLastVertex());
    PVector p1 = getVertexPoint(getLastVertex());
    return getPoint(p0, p1, (start + length) % 1);
  }

  PVector[] getPoints() {
    PVector[] result = new PVector[vertices.size()];
    result[0] = getStartPoint();
    for (int i = 1; i < vertices.size() - 1; i++) {
      result[i] = getVertexPoint(vertices.get(i));
    }
    result[result.length - 1] = getEndPoint();
    return result;
  }

  private PVector getVertexPoint(int vertex) {
    return box.getVertexPoint(vertex);
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