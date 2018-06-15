import controlP5.*;

final int VIEWPORT_WIDTH = 850;
final int VIEWPORT_HEIGHT = 850;
final int VIEWPORT_MARGIN = 20;
final int CAMERA_DISTANCE = 200;

PGraphics sceneOne;
PGraphics sceneTwo;
PGraphics sceneThree;

Box boxOne;
Box boxTwo;
boolean isOccluding = true;

ControlP5 cp5;

FileNamer fileNamer;

void setup() {
  size(1440, 850, P3D);

  sceneOne = createGraphics(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, P3D);
  sceneTwo = createGraphics(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, P3D);
  sceneThree = createGraphics(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, P3D);

  setupUi();
  reset();

  fileNamer = new FileNamer("output/export", "png");
}

void setupUi() {
  final int uiMargin = 18;
  final int left = VIEWPORT_WIDTH + VIEWPORT_MARGIN;
  final int right = width - VIEWPORT_MARGIN;

  final int labelColWidth = 70;
  final int lockColWidth = 64;
  final int yawPitchColWidth = floor((right - left - labelColWidth - lockColWidth) / 2);
  final int yawPitchColInnerWidth = yawPitchColWidth - 2 * uiMargin;

  final int labelColLeft = left + uiMargin;
  final int yawColLeft = left + labelColWidth + uiMargin;
  final int pitchColLeft = left + labelColWidth + yawPitchColWidth + uiMargin;
  final int lockColLeft = left + labelColWidth + yawPitchColWidth * 2 + uiMargin;
  final int rowHeight = 32;
  final int sliderHeight = 18;
  final int toggleSize = 18;
  final int labelOffsetY = 5;

  cp5 = new ControlP5(this);
  int currY = VIEWPORT_MARGIN;

  cp5.addLabel("yaw").setPosition(yawColLeft, currY);
  cp5.addLabel("pitch").setPosition(pitchColLeft, currY);
  cp5.addLabel("lock").setPosition(lockColLeft, currY);
  currY += rowHeight;

  cp5.addLabel("box 1").setPosition(labelColLeft, currY + labelOffsetY);

  cp5.addSlider("boxOneYaw")
    .setLabel("")
    .setPosition(yawColLeft, currY)
    .setSize(yawPitchColInnerWidth, sliderHeight)
    .setRange(0, 360)
    .setValue(0);

  cp5.addSlider("boxOnePitch")
    .setLabel("")
    .setPosition(pitchColLeft, currY)
    .setSize(yawPitchColInnerWidth, sliderHeight)
    .setRange(0, 360)
    .setValue(7.5);
  currY += rowHeight;

  cp5.addLabel("view 1").setPosition(labelColLeft, currY + labelOffsetY);

  cp5.addSlider("viewOneYaw")
    .setLabel("")
    .setPosition(yawColLeft, currY)
    .setSize(yawPitchColInnerWidth, sliderHeight)
    .setRange(0, 360)
    .setValue(0);

  cp5.addSlider("viewOnePitch")
    .setLabel("")
    .setPosition(pitchColLeft, currY)
    .setSize(yawPitchColInnerWidth, sliderHeight)
    .setRange(0, 360)
    .setValue(0);

  cp5.addToggle("viewOneLock")
    .setLabel("")
    .setPosition(lockColLeft, currY)
    .setSize(toggleSize, toggleSize)
    .setValue(true);
  currY += rowHeight;

  currY += rowHeight;

  cp5.addLabel("box 2").setPosition(labelColLeft, currY + labelOffsetY);

  cp5.addSlider("boxTwoYaw")
    .setLabel("")
    .setPosition(yawColLeft, currY)
    .setSize(yawPitchColInnerWidth, sliderHeight)
    .setRange(0, 360)
    .setValue(145);

  cp5.addSlider("boxTwoPitch")
    .setLabel("")
    .setPosition(pitchColLeft, currY)
    .setSize(yawPitchColInnerWidth, sliderHeight)
    .setRange(0, 360)
    .setValue(22.5);
  currY += rowHeight;

  cp5.addLabel("view 2").setPosition(labelColLeft, currY + labelOffsetY);

  cp5.addSlider("viewTwoYaw")
    .setLabel("")
    .setPosition(yawColLeft, currY)
    .setSize(yawPitchColInnerWidth, sliderHeight)
    .setRange(0, 360)
    .setValue(0);

  cp5.addSlider("viewTwoPitch")
    .setLabel("")
    .setPosition(pitchColLeft, currY)
    .setSize(yawPitchColInnerWidth, sliderHeight)
    .setRange(0, 360)
    .setValue(7);

  cp5.addToggle("viewTwoLock")
    .setLabel("")
    .setPosition(lockColLeft, currY)
    .setSize(toggleSize, toggleSize)
    .setValue(true);
  currY += rowHeight;

  currY += rowHeight;

  cp5.addLabel("view 3").setPosition(labelColLeft, currY + labelOffsetY);

  cp5.addSlider("viewThreeYaw")
    .setLabel("")
    .setPosition(yawColLeft, currY)
    .setSize(yawPitchColInnerWidth, sliderHeight)
    .setRange(0, 360)
    .setValue(0);

  cp5.addSlider("viewThreePitch")
    .setLabel("")
    .setPosition(pitchColLeft, currY)
    .setSize(yawPitchColInnerWidth, sliderHeight)
    .setRange(0, 360)
    .setValue(0);
  currY += rowHeight;

  cp5.addLabel("rotisserie\nspeed").setPosition(labelColLeft, currY + labelOffsetY);

  cp5.addSlider("viewThreeYawDelta")
    .setLabel("")
    .setPosition(yawColLeft, currY)
    .setSize(yawPitchColInnerWidth, sliderHeight)
    .setRange(0, 30)
    .setValue(2);
}

void reset() {
  boxOne = new Box(100, 0, radians(7.5));
  boxTwo = new Box(100, radians(145), radians(22.5));
}

void draw() {
  drawSceneOne();
  drawSceneTwo();
  drawSceneThree();

  background(24);

  image(sceneOne, 0, 0, VIEWPORT_WIDTH/2, VIEWPORT_HEIGHT/2);
  image(sceneTwo, VIEWPORT_WIDTH/2, 0, VIEWPORT_WIDTH/2, VIEWPORT_HEIGHT/2);
  image(sceneThree, 0, VIEWPORT_HEIGHT/2, VIEWPORT_WIDTH/2, VIEWPORT_HEIGHT/2);

  final int labelOffsetX = 12;
  final int labelOffsetY = 24;
  text("view 1", labelOffsetX, labelOffsetY);
  text("view 2", VIEWPORT_WIDTH/2 + labelOffsetX, labelOffsetY);
  text("view 3", labelOffsetX, VIEWPORT_HEIGHT/2 + labelOffsetY);
  text("overhead", VIEWPORT_WIDTH/2 + labelOffsetX, VIEWPORT_HEIGHT/2 + labelOffsetY);
}

void drawSceneOne() {
  boxOne.yaw = radians(cp5.getController("boxOneYaw").getValue());
  boxOne.pitch = radians(cp5.getController("boxOnePitch").getValue());
  if (cp5.getController("viewOneLock").getValue() != 0) {
    drawScene(sceneOne, boxOne, boxTwo, "boxOne");
  } else {
    float yaw = radians(cp5.getController("viewOneYaw").getValue());
    float pitch = radians(cp5.getController("viewOnePitch").getValue());
    PVector cameraPos = getCameraPosFromYawPitch(yaw, pitch);
    drawScene(sceneOne, boxOne, boxTwo, cameraPos);
  }
}

void drawSceneTwo() {
  boxTwo.yaw = radians(cp5.getController("boxTwoYaw").getValue());
  boxTwo.pitch = radians(cp5.getController("boxTwoPitch").getValue());
  if (cp5.getController("viewTwoLock").getValue() != 0) {
    drawScene(sceneTwo, boxOne, boxTwo, "boxTwo");
  } else {
    float yaw = radians(cp5.getController("viewTwoYaw").getValue());
    float pitch = radians(cp5.getController("viewTwoPitch").getValue());
    PVector cameraPos = getCameraPosFromYawPitch(yaw, pitch);
    drawScene(sceneTwo, boxOne, boxTwo, cameraPos);
  }
}

void drawSceneThree() {
  float yaw = radians(cp5.getController("viewThreeYaw").getValue());
  float pitch = radians(cp5.getController("viewThreePitch").getValue());
  PVector cameraPos = getCameraPosFromYawPitch(yaw, pitch);
  drawScene(sceneThree, boxOne, boxTwo, cameraPos);
}

void drawScene(PGraphics g, Box boxOne, Box boxTwo, String scene) {
  PVector cameraPos;
  switch (scene) {
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

PVector getCameraPosFromYawPitch(float yaw, float pitch) {
  // TODO: Implement get camera pos from yaw pitch.
  return new PVector(CAMERA_DISTANCE * cos(yaw), 0, CAMERA_DISTANCE * sin(yaw));
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

void controlEvent(ControlEvent theEvent) {
  println("got a control event from controller with id "+theEvent.getController().getId());
  
  if (theEvent.isFrom(cp5.getController("viewOneLock"))) {
    boolean isLocked = cp5.getController("viewOneLock").getValue() != 0;
    cp5.getController("viewOneYaw").setVisible(!isLocked);
    cp5.getController("viewOnePitch").setVisible(!isLocked);
    if (!isLocked) {
      cp5.getController("viewOneYaw").setValue(cp5.getController("boxOneYaw").getValue());
      cp5.getController("viewOnePitch").setValue(cp5.getController("boxOnePitch").getValue());
    }
  } else if (theEvent.isFrom(cp5.getController("viewTwoLock"))) {
    boolean isLocked = cp5.getController("viewTwoLock").getValue() != 0;
    cp5.getController("viewTwoYaw").setVisible(!isLocked);
    cp5.getController("viewTwoPitch").setVisible(!isLocked);
    if (!isLocked) {
      cp5.getController("viewTwoYaw").setValue(cp5.getController("boxTwoYaw").getValue());
      cp5.getController("viewTwoPitch").setValue(cp5.getController("boxTwoPitch").getValue());
    }
  }
}

void keyReleased() {
  switch (key) {
    case 'e':
      reset();
      break;
    case 'o':
      isOccluding = !isOccluding;
      break;
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}