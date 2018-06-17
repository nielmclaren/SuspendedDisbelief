
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
}