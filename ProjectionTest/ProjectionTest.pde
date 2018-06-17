
final int VIEWPORT_WIDTH = 850;
final int VIEWPORT_HEIGHT = 850;
final int VIEWPORT_MARGIN = 20;
final int CAMERA_DISTANCE = 200;

PGraphics scene;
PGraphics projection;
Box box;

FileNamer fileNamer;

void setup() {
  size(1440, 850, P3D);

  scene = createGraphics(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, P3D);
  projection = createGraphics(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, P3D);
  box = new Box(100, 0, 0);

  fileNamer = new FileNamer("output/export", "png");
}

void draw() {
  background(24);

  PVector cameraPos = getCameraPos();
  drawScene(scene, cameraPos, box);
  drawProjection(projection, cameraPos, box);

  image(scene, 0, 0, VIEWPORT_WIDTH, VIEWPORT_HEIGHT);
  image(projection, 0, 0, VIEWPORT_WIDTH, VIEWPORT_HEIGHT);
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

void drawScene(PGraphics g, PVector cameraPos, Box box) {
  box.yaw = map(mouseX, 0, width, 0, TWO_PI);
  box.pitch = map(mouseY, 0, height, -PI/2, PI/2);

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

  g.pushMatrix();
  PVector[] points = box.getPoints();
  for (int i = 0; i < points.length; i++) {
    drawPoint(g, cameraPos, points[i]);
  }
  g.popMatrix();

  g.endDraw();
}

void drawPoint(PGraphics g, PVector cameraPos, PVector point) {
  g.pushStyle();
  g.pushMatrix();
  g.translate(point.x, point.y, point.z);
  g.strokeWeight(1);
  g.sphereDetail(9);
  g.sphere(10);
  g.popMatrix();
  g.popStyle();
}

void drawProjection(PGraphics g, PVector cameraPos, Box box) {
  g.beginDraw();
  g.background(0, 0);

  g.stroke(255, 0, 0);
  g.line(-50, 0, 75, 150);

  g.endDraw();
}

void keyReleased() {
  switch (key) {
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}