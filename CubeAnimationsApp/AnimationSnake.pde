
class AnimationSnake implements IAnimation {
  private Snake snake;
  private float opacity;

  AnimationSnake(Snake snakeArg) {
    snake = snakeArg;
    opacity = 0;
  }

  void step() {
    snake.advance(0.06);
    if (snake.getLength() <= 0.1) {
      snake.setLength(4);
      opacity = 0;
    } else {
      snake.setLength(snake.getLength() - 0.055);
      opacity += 0.01;
    }
  }

  void draw(PGraphics g) {
    g.strokeWeight(5);
    g.stroke(#7effdb, 255 * opacity);
    SnakeDrawer.draw(g, snake);
  }
}