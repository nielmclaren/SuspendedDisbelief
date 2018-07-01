
class AnimationSnake implements IAnimation {
  private Snake snake;

  AnimationSnake(Snake snakeArg) {
    snake = snakeArg;
  }

  void step() {
    snake.advance(0.03);
  }

  void draw(PGraphics g) {
    g.noFill();
    g.strokeWeight(5);
    g.stroke(#7effdb);
    SnakeDrawer.draw(g, snake);
  }
}