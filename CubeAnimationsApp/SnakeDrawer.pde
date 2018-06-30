
static class SnakeDrawer {
  static void draw(PGraphics g, Snake snake) {
    PVector[] points = snake.getPoints();
    for (int i = 0; i < points.length - 1; i++) {
      GraphicsUtils.line(g, points[i], points[i + 1]);
    }
  }
}