PGraphics perspectiveOne;
PGraphics perspectiveTwo;
PGraphics dynamicPerspective;

Box boxOne;
Box boxTwo;

FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);
  perspectiveOne = createGraphics(width, height, P3D);
  perspectiveTwo = createGraphics(width, height, P3D);
  dynamicPerspective = createGraphics(width, height, P3D);

  boxOne = new Box(100, random(TWO_PI), random(-PI/2, PI/2));

  fileNamer = new FileNamer("output/export", "png");
}

void draw() {
  boxTwo = new Box(100,
    map(mouseX, 0, width, 0, TWO_PI),
    map(mouseY, 0, height, 0, TWO_PI));

  drawScene(perspectiveOne, boxOne, boxTwo, "boxOne");
  drawScene(perspectiveTwo, boxOne, boxTwo, "boxTwo");

  float r = 200;
  float t = (float)(frameCount) / 100;
  drawScene(dynamicPerspective, boxOne, boxTwo, new PVector(r * cos(t), 0, r * sin(t)));

  background(50);
  image(perspectiveOne, 0, 0, width/2, height/2);
  image(perspectiveTwo, width/2, 0, width/2, height/2);
  image(dynamicPerspective, 0, height/2, width/2, height/2);
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

  g.fill(0);
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

void keyReleased() {
  switch (key) {
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}