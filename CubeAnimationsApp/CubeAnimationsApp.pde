import controlP5.*;

final int VIEWPORT_WIDTH = 850;
final int VIEWPORT_HEIGHT = 850;
final int EXPORT_WIDTH = 1920;
final int EXPORT_HEIGHT = 1080;
final int VIEWPORT_MARGIN = 20;
final int CAMERA_DISTANCE = 200;

PGraphics scene;
boolean isPerspectiveOne;

Box boxOne;
Box boxTwo;

ArrayList<IAnimation> animations;

ControlP5 cp5;

JSONObject settingsJson;

FileNamer fileNamer;
FileNamer animationFileNamer;

void setup() {
  size(1440, 850, P3D);

  scene = createGraphics(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, P3D);
  isPerspectiveOne = false;

  setupUi();
  reset();
  loadSettings();
  setupAnimations();

  fileNamer = new FileNamer("output/export", "png");
  animationFileNamer = new FileNamer("output/anim", "/");
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

void setupAnimations() {
  animations = new ArrayList<IAnimation>();
  animations.add(new AnimationBaseCube(boxOne));
  animations.add(new AnimationSnake(new Snake(boxOne, PI), #7effdb));
  animations.add(new AnimationSnake(new Snake(boxTwo, PI), #b693fe));
}

void draw() {
  stepAnimations();

  if (isPerspectiveOne) {
    drawSceneOne();
  } else {
    drawSceneTwo();
  }

  background(24);

  image(scene, 0, 0, VIEWPORT_WIDTH, VIEWPORT_HEIGHT);

  cp5.draw();
}

void stepAnimations() {
  for (IAnimation animation : animations) {
    animation.step();
  }
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

  float cameraZ = (height/2.0) / tan(PI*60.0/360.0);
  g.perspective(PI/3.0, width/height, 1, 1000000);

  if (cameraPos.x == 0 && cameraPos.z == 0) {
    g.camera(cameraPos.x, cameraPos.y, cameraPos.z, 0, 0, 0, 0, 0, 1);
  } else {
    g.camera(cameraPos.x, cameraPos.y, cameraPos.z, 0, 0, 0, 0, 1, 0);
  }

  drawAnimations(g);

  g.endDraw();
}

void drawAnimations(PGraphics g) {
  for (IAnimation animation : animations) {
    g.pushStyle();
    animation.draw(g);
    g.popStyle();
  }
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
  boxOne.yaw = radians(settingsJson.getFloat("boxOneYaw"));
  boxOne.pitch = radians(settingsJson.getFloat("boxOnePitch"));
  boxOne.size = settingsJson.getFloat("boxOneSize");

  boxTwo.yaw = radians(settingsJson.getFloat("boxTwoYaw"));
  boxTwo.pitch = radians(settingsJson.getFloat("boxTwoPitch"));
  boxTwo.size = settingsJson.getFloat("boxTwoSize");
}

void perspectiveOne() {
  isPerspectiveOne = true;
}

void perspectiveTwo() {
  isPerspectiveOne = false;
}

void exportAnimations() {
  animations = new ArrayList<IAnimation>();
  animations.add(new AnimationSnake(new Snake(boxOne, PI), #7effdb));
  exportAnimation("output/cube-one-");

  animations = new ArrayList<IAnimation>();
  animations.add(new AnimationSnake(new Snake(boxTwo, PI), #b693fe));
  exportAnimation("output/cube-two-");

  animations = new ArrayList<IAnimation>();
  animations.add(new AnimationSnake(new Snake(boxOne, PI), #7effdb));
  animations.add(new AnimationSnake(new Snake(boxTwo, PI), #b693fe));
  exportAnimation("output/cube-both-");

  setupAnimations();
}

void exportAnimation(String filePrefix) {
  PVector cameraOnePos = getSceneOneCameraPos();
  PVector cameraTwoPos = getSceneTwoCameraPos();

  PGraphics scene = createGraphics(min(EXPORT_WIDTH, EXPORT_HEIGHT), min(EXPORT_WIDTH, EXPORT_HEIGHT), P3D);
  PGraphics export = createGraphics(EXPORT_WIDTH, EXPORT_HEIGHT, P3D);
  FileNamer animOneFrameFileNamer = new FileNamer(filePrefix + "perspective-one/frame", "png");
  FileNamer animTwoFrameFileNamer = new FileNamer(filePrefix + "perspective-two/frame", "png");

  int numFrames = 2000;
  for (int i = 0; i < numFrames; i++) {
    stepAnimations();

    drawScene(scene, cameraOnePos);
    drawExportImage(scene, export);
    export.save(animOneFrameFileNamer.next());

    drawScene(scene, cameraTwoPos);
    drawExportImage(scene, export);
    export.save(animTwoFrameFileNamer.next());
  }
}

void drawExportImage(PGraphics scene, PGraphics export) {
  export.beginDraw();
  export.background(0);
  export.imageMode(CENTER);
  export.image(scene, EXPORT_WIDTH/2, EXPORT_HEIGHT/2);
  export.endDraw();
}

void controlEvent(ControlEvent theEvent) {
  println("got a control event from controller with id " + theEvent.getController().getId());
}

void keyReleased() {
  switch (key) {
    case 'a':
      exportAnimations();
      break;
    case 'e':
      reset();
      break;
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}