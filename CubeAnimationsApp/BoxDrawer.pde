
static class BoxDrawer {
  BoxDrawer() {}

  static void drawBox(PGraphics g, Box box) {
    g.pushMatrix();
    g.rotateY(box.yaw);
    g.rotateZ(box.pitch);
    g.box(box.size);
    g.popMatrix();
  }

  static void drawFace(PGraphics g, Box box, int faceIndex) {
    PVector[] facePoints = box.getFacePoints(faceIndex % 6);
    GraphicsUtils.line(g, facePoints[0], facePoints[1]);
    GraphicsUtils.line(g, facePoints[1], facePoints[2]);
    GraphicsUtils.line(g, facePoints[2], facePoints[3]);
    GraphicsUtils.line(g, facePoints[3], facePoints[0]);
  }

  static void drawOpposingFaces(PGraphics g, Box box, int faceIndex) {
    PVector[] facePoints;

    facePoints = box.getFacePoints(floor(faceIndex / 2) * 2);
    GraphicsUtils.line(g, facePoints[0], facePoints[1]);
    GraphicsUtils.line(g, facePoints[1], facePoints[2]);
    GraphicsUtils.line(g, facePoints[2], facePoints[3]);
    GraphicsUtils.line(g, facePoints[3], facePoints[0]);

    facePoints = box.getFacePoints(floor(faceIndex / 2) * 2 + 1);
    GraphicsUtils.line(g, facePoints[0], facePoints[1]);
    GraphicsUtils.line(g, facePoints[1], facePoints[2]);
    GraphicsUtils.line(g, facePoints[2], facePoints[3]);
    GraphicsUtils.line(g, facePoints[3], facePoints[0]);
  }

  static void drawEdge(PGraphics g, Box box, int edgeIndex) {
    PVector[] edgePoints = box.getEdgePoints(edgeIndex);
    GraphicsUtils.line(g, edgePoints[0], edgePoints[1]);
  }

  static void drawEdgeLabel(PGraphics g, Box box, int edgeIndex) {
    PVector[] edgePoints = box.getEdgePoints(edgeIndex);
    PVector midPoint = PVector.add(edgePoints[0], PVector.mult(PVector.sub(edgePoints[1], edgePoints[0]), 0.5));

    g.pushMatrix();
    g.translate(midPoint.x, midPoint.y, midPoint.z);
    g.text(edgeIndex, 0, 0);
    g.popMatrix();
  }

  static void drawEdgeLabels(PGraphics g, Box box) {
    for (int i = 0; i < 12; i++) {
      drawEdgeLabel(g, box, i);
    }
  }

  static void drawVertex(PGraphics g, Box box, int vertex) {
    PVector vertexPoint = box.getVertexPoint(vertex);
    g.pushMatrix();
    g.translate(vertexPoint.x, vertexPoint.y, vertexPoint.z);
    g.sphereDetail(9);
    g.sphere(5);
    g.popMatrix();
  }

  static void drawVertexLabel(PGraphics g, Box box, int vertex) {
    PVector vertexPoint = box.getVertexPoint(vertex);

    g.pushMatrix();
    g.translate(vertexPoint.x, vertexPoint.y, vertexPoint.z);
    g.text(vertex, 0, 0);
    g.popMatrix();
  }

  static void drawVertexLabels(PGraphics g, Box box) {
    for (int i = 0; i < 8; i++) {
      drawVertexLabel(g, box, i);
    }
  }
}