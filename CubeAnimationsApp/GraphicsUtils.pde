
static class GraphicsUtils {
  static void line(PGraphics g, PVector p0, PVector p1) {
    g.line(p0.x, p0.y, p0.z, p1.x, p1.y, p1.z);
  }

  static void vertex(PGraphics g, PVector p) {
    g.vertex(p.x, p.y, p.z);
  }
}