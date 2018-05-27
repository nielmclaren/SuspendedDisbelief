
boolean isDrawHud;
boolean isOccluding;

FileNamer fileNamer;

void setup() {
  fullScreen(P3D);

  isDrawHud = false;
  isOccluding = true;

  reset();

  fileNamer = new FileNamer("output/export", "png");
}

void reset() {
  background(0);
  drawSmallMultiples(g, 1350, 900);
}

void draw() {
}

long mouseMoveTime = 0;
void mouseMoved() {
  if (millis() - mouseMoveTime > 300) {
    reset();
    mouseMoveTime = millis();
  }
}

void drawSmallMultiples(PGraphics g, int drawWidth, int drawHeight) {
  int numCols = 10;
  int numRows = 6;
  int w = floor(drawWidth / numCols);
  int h = floor(drawHeight / numRows);

  PGraphics perspectiveBuffer = createGraphics(w, h, P3D);

  Box boxOne = new Box(100, 0, 0);

  for (int col = 0; col < numCols; col++) {
      float yaw = map(mouseX, 0, 300, 0, PI/2) + map(floor(col / 2) * 2, 0, numCols, 0, PI/2);

    for (int row = 0; row < numRows; row++) {
      float pitch = map(mouseY, 0, 300, 0, PI/2) + map(row, 0, numRows, PI/8, PI/4);
      Box boxTwo = new Box(100, yaw, pitch);
      
      String perspective = col % 2 == 0 ? "boxOne" : "boxTwo";
      drawSceneTo(perspectiveBuffer, boxOne, boxTwo, perspective);
      g.image(perspectiveBuffer, col * w, row * h, w, h);

      g.noFill();

      g.stroke(128);
      g.strokeWeight(2);
      g.line(col * w, row * h, col * w + w, row * h); // top
      g.line(col * w, row * h + h, col * w + w, row * h + h); // bottom
      if (col % 2 == 0) {
        g.line(col * w, row * h, col * w, row * h + h); // left
      } else {
        g.line(col * w + w, row * h, col * w + w, row * h + h); // right
      }

      if (isDrawHud) {
        g.text("yaw: " + floor(degrees(yaw)) + ", pitch: " + floor(degrees(pitch)) + "\n" + perspective,
          col * w + 6, row * h + 16);
      }
    }
  }
}

void drawSceneTo(PGraphics g, Box boxOne, Box boxTwo, String perspective) {
  PVector cameraPos = getCameraPosFromPerspective(boxOne, boxTwo, perspective);
  drawSceneTo(g, boxOne, boxTwo, cameraPos);
}

PVector getCameraPosFromPerspective(Box boxOne, Box boxTwo, String perspective) {
  switch (perspective) {
    case "boxOne":
      return getCameraPosFromBox(boxOne);
    case "boxTwo":
      return getCameraPosFromBox(boxTwo);
    default:
      return new PVector(200, 0, 50);
  }
}

PVector getCameraPosFromBox(Box box) {
  float r = 200;
  PVector result = new PVector();

  PMatrix3D m = new PMatrix3D();
  m.rotate(box.yaw, 0, 1, 0);
  m.rotate(box.pitch, 0, 0, 1);
  m.mult(new PVector(r, 0, 0), result);

  //result.y = 20;
  println(box.yaw, box.pitch, result);

  return result;
}

void drawSceneTo(PGraphics g, Box boxOne, Box boxTwo, PVector cameraPos) {
  g.beginDraw();
  g.background(0);
  g.camera(cameraPos.x, cameraPos.y, cameraPos.z, 0, 0, 0, 0, -1, 0);
 
  if (isOccluding) {
    g.fill(0);
  } else {
    g.noFill();
  }
  g.strokeWeight(2);

  g.stroke(#7effdb); // green
  drawBox(g, boxOne);

  g.stroke(#b693fe); // purple
  drawBox(g, boxTwo);

  g.endDraw();
}

void drawAxes(PGraphics g) {
  float axisLength = 75;

  g.pushStyle();
  g.strokeWeight(2);
  g.stroke(255, 0, 0);
  g.line(0, 0, 0, axisLength, 0, 0);
  g.stroke(0, 255, 0);
  g.line(0, 0, 0, 0, axisLength, 0);
  g.stroke(0, 0, 255);
  g.line(0, 0, 0, 0, 0, axisLength);
  g.popStyle();
}

void drawBox(PGraphics g, Box box) {
  g.pushMatrix();
  g.rotateY(box.yaw);
  g.rotateZ(box.pitch);
  g.box(box.size);
  g.popMatrix();
}

void keyReleased() {
  switch (key) {
    case 'e':
      reset();
      break;
    case 'h':
      isDrawHud = !isDrawHud;
      reset();
      break;
    case 'o':
      isOccluding = !isOccluding;
      reset();
      break;
    case 'r':
      save(savePath(fileNamer.next()));
      break;
  }
}