
static class SnakeDrawer {
  static void draw(PGraphics g, Snake snake) {
    PVector[] points = snake.getPoints();
    if (points.length > 2) {
      g.beginShape();
      for (int i = 0; i < points.length; i++) {
        GraphicsUtils.vertex(g, points[i]);
      }
      g.endShape();
    } else if (points.length > 1) {
      GraphicsUtils.line(g, points[0], points[1]);
    }
  }
}