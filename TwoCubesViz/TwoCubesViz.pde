PGraphics perspectiveOne;
PGraphics perspectiveTwo;
PGraphics homePerspective;
PGraphics dynamicPerspective;

Box boxOne;
Box boxTwo;
boolean isOccluding = true;
float angleDelta = radians(5);

FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);
  perspectiveOne = createGraphics(width, height, P3D);
  perspectiveTwo = createGraphics(width, height, P3D);
  homePerspective = createGraphics(width, height, P3D);
  dynamicPerspective = createGraphics(width, height, P3D);

  reset();

  fileNamer = new FileNamer("output/export", "png");
}

void reset() {
  boxOne = new Box(100, 0, radians(7.5));
  boxTwo = new Box(100, radians(145), radians(22.5));
}

void draw() {
  float r = 200;
  drawScene(perspectiveOne, boxOne, boxTwo, "boxOne");
  drawScene(perspectiveTwo, boxOne, boxTwo, "boxTwo");
  drawScene(homePerspective, boxOne, boxTwo, new PVector(r, 0, 0));

  float a = mouseXToAngle(mouseX);
  PVector cameraPos = new PVector(r * cos(a), 0, r * sin(a));
  drawScene(dynamicPerspective, boxOne, boxTwo, cameraPos);

  background(50);
  image(perspectiveOne, 0, 0, width/2, height/2);
  image(perspectiveTwo, width/2, 0, width/2, height/2);
  image(homePerspective, 0, height/2, width/2, height/2);
  image(dynamicPerspective, width/2, height/2, width/2, height/2);
}

float mouseXToAngle(float v) {
  return map(mouseX, 0, width, 0, TWO_PI);
}

void drawScene(PGraphics g, Box boxOne, Box boxTwo, String perspective) {
  PVector cameraPos;
  switch (perspective) {
    case "boxOne":
      cameraPos = getCameraPosFromBox(boxOne);
      break;
    case "boxTwo":
      cameraPos = getCameraPosFromBox(boxTwo);
      break;
    default:
      cameraPos = new PVector(200, 0, 50);
  }
  drawScene(g, boxOne, boxTwo, cameraPos);
}

PVector getCameraPosFromBox(Box box) {
  float r = 200;
  PVector result = new PVector();

  PMatrix3D m = new PMatrix3D();
  m.rotate(box.yaw, 0, 1, 0);
  m.rotate(box.pitch, 1, 0, 0);
  m.mult(new PVector(0, r, 0), result);

  return result;
}

void drawScene(PGraphics g, Box boxOne, Box boxTwo, PVector cameraPos) {
  g.beginDraw();
  g.background(0);
  g.camera(cameraPos.x, cameraPos.y, cameraPos.z, 0, 0, 0, 0, 1, 0);

  if (isOccluding) {
    g.fill(0);
  }   else {
    g.noFill();
  }
  g.strokeWeight(5);
  g.pushMatrix();

  g.pushMatrix();
  g.stroke(#7effdb);
  g.rotateY(boxOne.yaw);
  g.rotateX(boxOne.pitch);
  g.box(boxOne.size);
  g.popMatrix();

  g.pushMatrix();
  g.stroke(#b693fe);
  g.rotateY(boxTwo.yaw);
  g.rotateX(boxTwo.pitch);
  g.box(boxTwo.size);
  g.popMatrix();

  g.popMatrix();
  g.endDraw();
}

void mouseReleased() {
  println("View angle:", degrees(mouseXToAngle(mouseX)));
}

void keyReleased() {
  switch (key) {
    case 'e':
      reset();
      break;
    case 'j':
      boxTwo.pitch -= angleDelta;
      println("yaw:", degrees(boxTwo.yaw), "pitch:", degrees(boxTwo.pitch));
      break;
    case 'k':
      boxTwo.pitch += angleDelta;
      println("yaw:", degrees(boxTwo.yaw), "pitch:", degrees(boxTwo.pitch));
      break;
    case 'h':
      boxTwo.yaw -= angleDelta;
      println("yaw:", degrees(boxTwo.yaw), "pitch:", degrees(boxTwo.pitch));
      break;
    case 'l':
      boxTwo.yaw += angleDelta;
      println("yaw:", degrees(boxTwo.yaw), "pitch:", degrees(boxTwo.pitch));
      break;
    case 'o':
      isOccluding = !isOccluding;
      break;
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}