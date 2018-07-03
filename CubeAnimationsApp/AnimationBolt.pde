
class AnimationBolt implements IAnimation {
  private Snake snake;
  private int step;

  AnimationBolt(Box box, int vertex0, int vertex1) {
    snake = new Snake(box, 0, vertex0, vertex1);
    step = 0;
  }

  void step() {
    /*
    float t = (step / 100.) % 1;
    setTime(t);
    step++;
    */
  }

  void setTime(float t) {
    if (t < 0.5) {
      snake.setLength(TweenUtils.easeOutSine(t / 0.5));
    } else {
      snake.setStart(TweenUtils.easeOutSine((t - 0.5) / 0.5));
      snake.setLength(1 - TweenUtils.easeOutSine((t - 0.5) / 0.5));
    }
  }

  void draw(PGraphics g) {
    g.noFill();
    g.strokeWeight(5);
    g.stroke(#7effdb);
    SnakeDrawer.draw(g, snake);
  }
}