
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

    println("in: " + faceIndex + " out: " + floor(faceIndex / 2) + " and " + (floor(faceIndex / 2) + 1));
    
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

  private void line(PGraphics g, PVector p0, PVector p1) {
    g.line(p0.x, p0.y, p0.z, p1.x, p1.y, p1.z);
  }
}