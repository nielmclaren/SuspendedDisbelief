
class BoxDrawer {
  BoxDrawer() {}

  void drawBox(PGraphics g, Box box) {
    g.pushMatrix();
    g.rotateY(box.yaw);
    g.rotateZ(box.pitch);
    g.box(box.size);
    g.popMatrix();
  }

  void drawFace(PGraphics g, Box box, int faceIndex) {
    PVector[] facePoints = box.getFacePoints(faceIndex % 6);
    line(g, facePoints[0], facePoints[1]);
    line(g, facePoints[1], facePoints[2]);
    line(g, facePoints[2], facePoints[3]);
    line(g, facePoints[3], facePoints[0]);
  }

  void drawOpposingFaces(PGraphics g, Box box, int faceIndex) {
    PVector[] facePoints;

    facePoints = box.getFacePoints(floor(faceIndex / 2) * 2);
    line(g, facePoints[0], facePoints[1]);
    line(g, facePoints[1], facePoints[2]);
    line(g, facePoints[2], facePoints[3]);
    line(g, facePoints[3], facePoints[0]);

    facePoints = box.getFacePoints(floor(faceIndex / 2) * 2 + 1);
    line(g, facePoints[0], facePoints[1]);
    line(g, facePoints[1], facePoints[2]);
    line(g, facePoints[2], facePoints[3]);
    line(g, facePoints[3], facePoints[0]);
  }

  void drawEdge(PGraphics g, Box box, int edgeIndex) {
    PVector[] edgePoints = box.getEdgePoints(edgeIndex);
    line(g, edgePoints[0], edgePoints[1]);
  }

  void drawVertex(PGraphics g, Box box, int vertexIndex) {
    PVector vertexPoint = box.getVertexPoint(vertexIndex);
    g.pushMatrix();
    g.translate(vertexPoint.x, vertexPoint.y, vertexPoint.z);
    g.sphereDetail(9);
    g.sphere(5);
    g.popMatrix();
  }

  private void line(PGraphics g, PVector p0, PVector p1) {
    g.line(p0.x, p0.y, p0.z, p1.x, p1.y, p1.z);
  }
}