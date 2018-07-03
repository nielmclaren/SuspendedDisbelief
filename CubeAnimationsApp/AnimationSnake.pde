
class AnimationSnake implements IAnimation {
  private Snake snake;
  private color snakeColor;

  AnimationSnake(Snake snakeArg, color snakeColorArg) {
    snake = snakeArg;
    snakeColor = snakeColorArg;
  }

  void step() {
    snake.advance(0.02);
  }

  void draw(PGraphics g) {
    g.noFill();
    g.strokeWeight(32);
    g.stroke(snakeColor);
    g.strokeJoin(ROUND);
    g.strokeCap(ROUND);
    SnakeDrawer.draw(g, snake);
  }
}