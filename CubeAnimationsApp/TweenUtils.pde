
static class TweenUtils {
  static float linearHill(float t) {
    if (t < 0.5) {
      return t / 0.5;
    }
    return 1 - (t - 0.5) / 0.5;
  }

  static float easeInSine(float t) {
    return 1 - cos(t * PI/2);
  }

  static float easeOutSine(float t) {
    return sin(t * PI/2);
  }

  static float easeInAndOutSine(float t) {
    return 1 - (cos(t * PI) + 1) / 2;
  }
}