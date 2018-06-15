import controlP5.*;

final int VIEWPORT_WIDTH = 850;
final int VIEWPORT_HEIGHT = 850;
final int VIEWPORT_MARGIN = 20;
final int CAMERA_DISTANCE = 200;
final int OVERHEAD_CAMERA_DISTANCE = 500;
final int MARKER_SIZE = 20;

PGraphics sceneOne;
PGraphics sceneTwo;
PGraphics sceneThree;
PGraphics sceneOverhead;

Box boxOne;
Box boxTwo;
float viewThreeYawOffset;

ControlP5 cp5;

FileNamer fileNamer;

void setup() {
  size(1440, 850, P3D);

  sceneOne = createGraphics(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, P3D);
  sceneTwo = createGraphics(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, P3D);
  sceneThree = createGraphics(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, P3D);
  sceneOverhead = createGraphics(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, P3D);

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
  cp5.setAutoDraw(false);

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
    .setRange(-89, 89)
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
    .setRange(-89, 89)
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
    .setRange(-89, 89)
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
    .setRange(-89, 89)
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
    .setRange(-89, 89)
    .setValue(0);
  currY += rowHeight;

  cp5.addLabel("rotisserie").setPosition(labelColLeft, currY + labelOffsetY);

  cp5.addToggle("isRotisserieEnabled")
    .setLabel("")
    .setPosition(yawColLeft, currY)
    .setSize(toggleSize, toggleSize)
    .setValue(true);

  cp5.addSlider("viewThreeYawDelta")
    .setLabel("")
    .setPosition(yawColLeft + toggleSize + uiMargin, currY)
    .setSize(2 * yawPitchColWidth - toggleSize - uiMargin - 2 * uiMargin, sliderHeight)
    .setRange(0, 3)
    .setValue(0.2);
  currY += rowHeight;

  currY += rowHeight;

  cp5.addLabel("occlusion").setPosition(labelColLeft, currY + labelOffsetY);

  cp5.addToggle("isOccluded")
    .setLabel("")
    .setPosition(yawColLeft, currY)
    .setSize(toggleSize, toggleSize)
    .setValue(true);
  currY += rowHeight;

  cp5.addLabel("draw origin").setPosition(labelColLeft, currY + labelOffsetY);

  cp5.addToggle("displayOrigin")
    .setLabel("")
    .setPosition(yawColLeft, currY)
    .setSize(toggleSize, toggleSize)
    .setValue(false);
  currY += rowHeight;
}

void reset() {
  boxOne = new Box(100, 0, radians(7.5));
  boxTwo = new Box(100, radians(145), radians(22.5));
  viewThreeYawOffset = 0;
}

void draw() {
  stepSceneOne();
  stepSceneTwo();
  stepSceneThree();
  drawSceneOne();
  drawSceneTwo();
  drawSceneThree();
  drawSceneOverhead();

  background(24);

  image(sceneOne, 0, 0, VIEWPORT_WIDTH/2, VIEWPORT_HEIGHT/2);
  image(sceneTwo, VIEWPORT_WIDTH/2, 0, VIEWPORT_WIDTH/2, VIEWPORT_HEIGHT/2);
  image(sceneThree, 0, VIEWPORT_HEIGHT/2, VIEWPORT_WIDTH/2, VIEWPORT_HEIGHT/2);
  image(sceneOverhead, VIEWPORT_WIDTH/2, VIEWPORT_HEIGHT/2, VIEWPORT_WIDTH/2, VIEWPORT_HEIGHT/2);

  final int labelOffsetX = 12;
  final int labelOffsetY = 24;
  text("view 1", labelOffsetX, labelOffsetY);
  text("view 2", VIEWPORT_WIDTH/2 + labelOffsetX, labelOffsetY);
  text("view 3", labelOffsetX, VIEWPORT_HEIGHT/2 + labelOffsetY);
  text("overhead", VIEWPORT_WIDTH/2 + labelOffsetX, VIEWPORT_HEIGHT/2 + labelOffsetY);

  cp5.draw();
}

void stepSceneOne() {
  boxOne.yaw = radians(cp5.getController("boxOneYaw").getValue());
  boxOne.pitch = radians(cp5.getController("boxOnePitch").getValue());
}

void stepSceneTwo() {
  boxTwo.yaw = radians(cp5.getController("boxTwoYaw").getValue());
  boxTwo.pitch = radians(cp5.getController("boxTwoPitch").getValue());
}

void stepSceneThree() {
  if (cp5.getController("isRotisserieEnabled").getValue() != 0) {
    viewThreeYawOffset += radians(cp5.getController("viewThreeYawDelta").getValue());
  }
}

void drawSceneOne() {
  PVector cameraPos = getSceneOneCameraPos();
  drawScene(sceneOne, cameraPos, false);
}

PVector getSceneOneCameraPos() {
  if (cp5.getController("viewOneLock").getValue() != 0) {
    return getCameraPosFromBox(boxOne);
  }

  float yaw = radians(cp5.getController("viewOneYaw").getValue());
  float pitch = radians(cp5.getController("viewOnePitch").getValue());
  return getCameraPosFromYawPitch(yaw, pitch);
}

void drawSceneTwo() {
  PVector cameraPos = getSceneTwoCameraPos();
  drawScene(sceneTwo, cameraPos, false);
}

PVector getSceneTwoCameraPos() {
  if (cp5.getController("viewTwoLock").getValue() != 0) {
    return getCameraPosFromBox(boxTwo);
  }

  float yaw = radians(cp5.getController("viewTwoYaw").getValue());
  float pitch = radians(cp5.getController("viewTwoPitch").getValue());
  return getCameraPosFromYawPitch(yaw, pitch);
}

void drawSceneThree() {
  PVector cameraPos = getSceneThreeCameraPos();
  drawScene(sceneThree, cameraPos, false);
}

PVector getSceneThreeCameraPos() {
  float yaw = viewThreeYawOffset + radians(cp5.getController("viewThreeYaw").getValue());
  float pitch = radians(cp5.getController("viewThreePitch").getValue());
  return getCameraPosFromYawPitch(yaw, pitch);
}

void drawSceneOverhead() {
  PVector cameraPos = new PVector(0, OVERHEAD_CAMERA_DISTANCE, 0);
  drawScene(sceneOverhead, cameraPos, true);
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

void drawScene(PGraphics g, PVector cameraPos, boolean displayOverheadAnnotations) {
  g.beginDraw();
  g.background(0);
  if (cameraPos.x == 0 && cameraPos.z == 0) {
    g.camera(cameraPos.x, cameraPos.y, cameraPos.z, 0, 0, 0, 0, 0, 1);
  } else {
    g.camera(cameraPos.x, cameraPos.y, cameraPos.z, 0, 0, 0, 0, 1, 0);
  }

  if (displayOverheadAnnotations) {
    drawOverheadAnnotations(g);
  }

  // Draw the origin
  if (cp5.getController("displayOrigin").getValue() != 0) {
    float r = 80;
    g.noFill();
    g.stroke(255, 0, 0);
    g.line(0, 0, 0, r, 0, 0);
    g.stroke(0, 255, 0);
    g.line(0, 0, 0, 0, r, 0);
    g.stroke(0, 0, 255);
    g.line(0, 0, 0, 0, 0, r);
  }

  if (cp5.getController("isOccluded").getValue() != 0) {
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

void drawOverheadAnnotations(PGraphics g) {
  PVector boxOneCameraPos = getCameraPosFromBox(boxOne);
  PVector boxTwoCameraPos = getCameraPosFromBox(boxTwo);
  PVector sceneOneCameraPos = getSceneOneCameraPos();
  PVector sceneTwoCameraPos = getSceneTwoCameraPos();

  // Background circle
  float radius = 1.7 * CAMERA_DISTANCE;
  g.strokeWeight(3);
  g.stroke(64);
  g.fill(32);
  g.pushMatrix();
  g.translate(0, -CAMERA_DISTANCE, 0);
  g.rotateX(PI/2);
  g.ellipseMode(RADIUS);
  g.ellipse(0, 0, radius, radius);
  g.popMatrix();

  // Box and camera positions
  g.stroke(192);
  g.rectMode(CENTER);
  drawLineAndMarker(g, boxOneCameraPos, "rect");
  drawLineAndMarker(g, boxTwoCameraPos, "rect");
  drawLineAndMarker(g, sceneOneCameraPos, "ellipse");
  drawLineAndMarker(g, sceneTwoCameraPos, "ellipse");
}

void drawLineAndMarker(PGraphics g, PVector pos, String markerType) {
  g.line(0, 0, 0, pos.x, pos.y, pos.z);
  g.pushMatrix();
  g.translate(pos.x, pos.y, pos.z);
  g.rotateX(PI/2);

  switch (markerType) {
    case "rect":
      g.rect(0, 0, MARKER_SIZE, MARKER_SIZE);
      break;
    case "ellipse":
      g.ellipse(0, 0, MARKER_SIZE, MARKER_SIZE);
      break;
  }

  g.popMatrix();
}

void controlEvent(ControlEvent theEvent) {
  println("got a control event from controller with id " + theEvent.getController().getId());
  
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
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}