
class AnimationBaseCube implements IAnimation {
  private Box box;

  AnimationBaseCube(Box boxArg) {
    box = boxArg;
  }

  void step() {
  }

  void draw(PGraphics g) {
    g.noFill();
    g.strokeWeight(1);
    g.stroke(#333333);
    BoxDrawer.drawBox(g, box);
  }
}