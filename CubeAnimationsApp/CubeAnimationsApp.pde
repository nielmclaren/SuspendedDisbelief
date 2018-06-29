import controlP5.*;

final int VIEWPORT_WIDTH = 850;
final int VIEWPORT_HEIGHT = 850;
final int VIEWPORT_MARGIN = 20;
final int CAMERA_DISTANCE = 200;

PGraphics scene;
boolean isPerspectiveOne;

Box boxOne;
Box boxTwo;

ControlP5 cp5;

JSONObject settingsJson;

FileNamer fileNamer;

void setup() {
  size(1440, 850, P3D);

  scene = createGraphics(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, P3D);
  isPerspectiveOne = true;

  setupUi();
  reset();
  loadSettings();

  fileNamer = new FileNamer("output/export", "png");
}

void setupUi() {
  final int uiMargin = 18;

  final int buttonWidth = 80;
  final int buttonHeight = 24;

  cp5 = new ControlP5(this);
  cp5.setAutoDraw(false);

  int currX = VIEWPORT_WIDTH + VIEWPORT_MARGIN;
  int currY = VIEWPORT_MARGIN;

  cp5.addButton("perspectiveOne")
    .setLabel("perspective one")
    .setPosition(currX, currY)
    .setSize(buttonWidth, buttonHeight);
  currX += buttonWidth + uiMargin;

  cp5.addButton("perspectiveTwo")
    .setLabel("perspective two")
    .setPosition(currX, currY)
    .setSize(buttonWidth, buttonHeight);
  currY += buttonHeight + uiMargin;

  currY += buttonHeight + uiMargin;

  currX = VIEWPORT_WIDTH + VIEWPORT_MARGIN;
  cp5.addButton("defaultSettings")
    .setLabel("defaults")
    .setPosition(currX, currY)
    .setSize(buttonWidth, buttonHeight);
  currX += buttonWidth + uiMargin;

  cp5.addButton("loadSettings")
    .setLabel("load")
    .setPosition(currX, currY)
    .setSize(buttonWidth, buttonHeight);
  currX += buttonWidth + uiMargin;
}

void reset() {
  boxOne = new Box(100, 0, radians(7.5));
  boxTwo = new Box(100, 0, radians(22.5));
}

void draw() {
  if (isPerspectiveOne) {
    drawSceneOne();
  } else {
    drawSceneTwo();
  }

  background(24);

  image(scene, 0, 0, VIEWPORT_WIDTH, VIEWPORT_HEIGHT);

  cp5.draw();
}

void drawSceneOne() {
  PVector cameraPos = getSceneOneCameraPos();
  drawScene(scene, cameraPos);
}

PVector getSceneOneCameraPos() {
  if (settingsJson.getBoolean("viewOneLock")) {
    return getCameraPosFromBox(boxOne);
  }

  float yaw = radians(settingsJson.getFloat("viewOneYaw"));
  float pitch = radians(settingsJson.getFloat("viewOnePitch"));
  return getCameraPosFromYawPitch(yaw, pitch);
}

void drawSceneTwo() {
  PVector cameraPos = getSceneTwoCameraPos();
  drawScene(scene, cameraPos);
}

PVector getSceneTwoCameraPos() {
  if (settingsJson.getBoolean("viewTwoLock")) {
    return getCameraPosFromBox(boxTwo);
  }

  float yaw = radians(settingsJson.getFloat("viewTwoYaw"));
  float pitch = radians(settingsJson.getFloat("viewTwoPitch"));
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

PVector getCameraPosFromBox(Box box) {
  return getCameraPosFromYawPitch(box.yaw, box.pitch);
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
  if (settingsJson.getBoolean("displayOrigin")) {
    float r = 80;
    g.noFill();
    g.stroke(255, 0, 0);
    g.line(0, 0, 0, r, 0, 0);
    g.stroke(0, 255, 0);
    g.line(0, 0, 0, 0, r, 0);
    g.stroke(0, 0, 255);
    g.line(0, 0, 0, 0, 0, r);
  }

  g.noFill();
  g.strokeWeight(5);
  g.pushMatrix();

  g.pushMatrix();
  g.stroke(#7effdb);
  g.rotateY(boxOne.yaw);
  g.rotateZ(boxOne.pitch);
  g.box(boxOne.size);
  g.popMatrix();

  g.pushMatrix();
  g.stroke(#b693fe);
  g.rotateY(boxTwo.yaw);
  g.rotateZ(boxTwo.pitch);
  g.box(boxTwo.size);
  g.popMatrix();

  g.popMatrix();
  g.endDraw();
}

void defaultSettings() {
  loadSettingsFromFile("defaultSettings.json");
  updateBoxesFromSettings();
}

void loadSettings() {
  loadSettingsFromFile("settings.json");
  updateBoxesFromSettings();
}

void loadSettingsFromFile(String filename) {
  settingsJson = loadJSONObject(filename);
}

void updateBoxesFromSettings() {
  boxOne.yaw = settingsJson.getFloat("boxOneYaw");
  boxOne.pitch = settingsJson.getFloat("boxOnePitch");
  boxOne.size = settingsJson.getFloat("boxOneSize");

  boxTwo.yaw = settingsJson.getFloat("boxTwoYaw");
  boxTwo.pitch = settingsJson.getFloat("boxTwoPitch");
  boxTwo.size = settingsJson.getFloat("boxTwoSize");
}

void controlEvent(ControlEvent theEvent) {
  println("got a control event from controller with id " + theEvent.getController().getId());
}

void perspectiveOne() {
  isPerspectiveOne = true;
}

void perspectiveTwo() {
  isPerspectiveOne = false;
}

void keyReleased() {
  switch (key) {
    case 'e':
      reset();
      break;
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}