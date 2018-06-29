
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

  PVector [] getFacePoints(int faceIndex) {
    switch (faceIndex) {
      case 0: return getFacePoints(-1,  0,  0);
      case 1: return getFacePoints( 1,  0,  0);
      case 2: return getFacePoints( 0, -1,  0);
      case 3: return getFacePoints( 0,  1,  0);
      case 4: return getFacePoints( 0,  0, -1);
      case 5: return getFacePoints( 0,  0,  1);

      default: return getFacePoints(-1, 0, 0);
    }
  }

  // One of dx, dy, dz should be positive or negative one. Others must be zero.
  PVector[] getFacePoints(int dx, int dy, int dz) {
    if (dx != 0) {
      return new PVector[]{ getPoint(dx, -1, -1), getPoint(dx, -1, 1), getPoint(dx, 1, 1), getPoint(dx, 1, -1) };
    } else if (dy != 0) {
      return new PVector[]{ getPoint(-1, dy, -1), getPoint(-1, dy, 1), getPoint(1, dy, 1), getPoint(1, dy, -1) };
    } else if (dz != 0) {
      return new PVector[]{ getPoint(-1, -1, dz), getPoint(-1, 1, dz), getPoint(1, 1, dz), getPoint(1, -1, dz) };
    }
    return null;
  }

  // Each of dx, dy, dz should be positive or negative one.
  PVector getPoint(int dx, int dy, int dz) {
    PVector point = new PVector(dx * size/2, dy * size/2, dz * size/2);
    PVector result = new PVector();

    PMatrix3D m = new PMatrix3D();
    m.rotate(yaw, 0, 1, 0);
    m.rotate(pitch, 0, 0, 1);
    m.mult(point, result);

    return result;
  }
}