
static class SnakeDrawer {
  static void draw(PGraphics g, Snake snake) {
    PVector start = snake.getStartPoint();
    PVector end = snake.getEndPoint();

    GraphicsUtils.line(g, start, end);
  }
}