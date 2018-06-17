
final int VIEWPORT_WIDTH = 850;
final int VIEWPORT_HEIGHT = 850;
final int VIEWPORT_MARGIN = 20;
final int CAMERA_DISTANCE = 200;

PGraphics scene;
Box box;

FileNamer fileNamer;

void setup() {
  size(1440, 850, P3D);

  scene = createGraphics(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, P3D);
  box = new Box(100, 0, 0);

  fileNamer = new FileNamer("output/export", "png");
}

void draw() {
  background(24);

  PVector cameraPos = getCameraPos();
  drawScene(scene, cameraPos);
  image(scene, 0, 0, VIEWPORT_WIDTH, VIEWPORT_HEIGHT);
}

PVector getCameraPos() {
  float yaw = radians(22.5);
  float pitch = radians(7.5);
  return getCameraPosFromYawPitch(yaw, pitch);
}

PVector getCameraPosFromYawPitch(float yaw, float pitch) {
  PVector result = new PVector();

  PMatrix3D m = new PMatrix3D();
  m.rotate(yaw, 0, 1, 0);
  m.rotate(pitch, 0, 0, 1);
  m.mult(new PVector(CAMERA_DISTANCE, 0, 0), result);

  return result;
}

void drawScene(PGraphics g, PVector cameraPos) {
  g.beginDraw();
  g.background(0);

  if (cameraPos.x == 0 && cameraPos.z == 0) {
    g.camera(cameraPos.x, cameraPos.y, cameraPos.z, 0, 0, 0, 0, 0, 1);
  } else {
    g.camera(cameraPos.x, cameraPos.y, cameraPos.z, 0, 0, 0, 0, 1, 0);
  }

  // Draw the origin
  float r = 80;
  g.stroke(255, 0, 0);
  g.line(0, 0, 0, r, 0, 0);
  g.stroke(0, 255, 0);
  g.line(0, 0, 0, 0, r, 0);
  g.stroke(0, 0, 255);
  g.line(0, 0, 0, 0, 0, r);

  g.noFill();
  g.strokeWeight(5);

  g.pushMatrix();
  g.stroke(#7effdb);
  g.rotateY(box.yaw);
  g.rotateZ(box.pitch);
  g.box(box.size);
  g.popMatrix();

  g.endDraw();
}

void keyReleased() {
  switch (key) {
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}