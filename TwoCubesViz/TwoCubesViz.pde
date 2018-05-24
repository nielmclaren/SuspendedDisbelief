PGraphics perspectiveOne;
PGraphics perspectiveTwo;
PGraphics dynamicPerspective;

FileNamer fileNamer;

void setup() {
  size(800, 800, P3D);
  perspectiveOne = createGraphics(width, height, P3D);
  perspectiveTwo = createGraphics(width, height, P3D);
  dynamicPerspective = createGraphics(width, height, P3D);

  fileNamer = new FileNamer("output/export", "png");
}

void draw() {
  Box boxOne = new Box(100, 0, 0);
  Box boxTwo = new Box(100,
    map(mouseX, 0, width, 0, TWO_PI),
    map(mouseY, 0, height, 0, TWO_PI));

  drawScene(perspectiveOne, boxOne, boxTwo, new PVector(-300, 0, 0));
  drawScene(perspectiveTwo, boxOne, boxTwo, new PVector(200, 0, 50));

  float r = 500;
  float t = (float)(frameCount) / 100;
  drawScene(dynamicPerspective, boxOne, boxTwo, new PVector(r * cos(t), 0, r * sin(t)));

  background(50);
  image(perspectiveOne, 0, 0, width/2, height/2);
  image(perspectiveTwo, width/2, 0, width/2, height/2);
  image(dynamicPerspective, 0, height/2, width/2, height/2);
}

void drawScene(PGraphics g, Box boxOne, Box boxTwo, PVector cameraPos) {
  g.beginDraw();
  g.background(0);
  g.camera(cameraPos.x, cameraPos.y, cameraPos.z, 0, 0, 0, 0, 1, 0);
  g.lights();

  g.noStroke();
  g.pushMatrix();

  g.pushMatrix();
  g.fill(#7effdb);
  g.rotateY(boxOne.yaw);
  g.rotateX(boxOne.pitch);
  g.box(boxOne.size);
  g.popMatrix();

  g.pushMatrix();
  g.fill(#b693fe);
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