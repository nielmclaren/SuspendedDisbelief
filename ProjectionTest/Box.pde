
class Box {
  public float size;
  public float yaw;
  public float pitch;

  Box() {
    size = 0;
    yaw = 0;
    pitch = 0;
  }

  Box(float sizeArg, float yawArg, float pitchArg) {
    size = sizeArg;
    yaw = yawArg;
    pitch = pitchArg;
  }

  PVector[] getPoints() {
    PVector[] points = new PVector[8];
    points[0] = getPoint(-1, -1, -1);
    points[1] = getPoint(-1, -1,  1);
    points[2] = getPoint(-1,  1, -1);
    points[3] = getPoint(-1,  1,  1);
    points[4] = getPoint( 1, -1, -1);
    points[5] = getPoint( 1, -1,  1);
    points[6] = getPoint( 1,  1, -1);
    points[7] = getPoint( 1,  1,  1);
    return points;
  }

  private PVector getPoint(int dx, int dy, int dz) {
    PVector point = new PVector(dx * size/2, dy * size/2, dz * size/2);
    PVector result = new PVector();

    PMatrix3D m = new PMatrix3D();
    m.rotate(yaw, 0, 1, 0);
    m.rotate(pitch, 0, 0, 1);
    m.mult(point, result);

    return result;
  }
}