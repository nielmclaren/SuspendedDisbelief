
boolean isDrawBoxOne;
boolean isDrawBoxTwo;
boolean isDrawHud;
boolean isOccluding;

int tileMargin = 16;

FileNamer fileNamer;

void setup() {
  fullScreen(P3D);

  isDrawBoxOne = true;
  isDrawBoxTwo = true;
  isDrawHud = false;
  isOccluding = true;

  reset();

  fileNamer = new FileNamer("output/export", "png");
}

void reset() {
  background(0);
  drawSmallMultiples(g, 64);
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

void drawSmallMultiples(PGraphics g, int approxTileSize) {
  int size = getSize(approxTileSize, width, height, tileMargin);
  int outerWidth = size + tileMargin;
  int outerHeight = size + 2 * tileMargin;
  int innerWidth = outerWidth - tileMargin;
  int innerHeight = outerHeight - 2 * tileMargin;
  int numCols = floor(width / outerWidth);
  int numRows = floor(height / outerHeight);

  PGraphics perspectiveBuffer = createGraphics(innerWidth, innerHeight, P3D);

  Box boxOne = new Box(100, 0, 0);

  for (int col = 0; col < numCols; col++) {
      float yaw = map(floor(col / 2) * 2, 0, numCols, PI/16, PI/2);

    for (int row = 0; row < numRows; row++) {
      float pitch = map(row, 0, numRows, PI/8, PI/4);
      Box boxTwo = new Box(100, yaw, pitch);
      
      if (col % 2 == 0) {
        if (isDrawBoxOne) {
          drawSceneTo(perspectiveBuffer, boxOne, boxTwo, "boxOne");
          g.image(perspectiveBuffer, col * outerWidth + tileMargin, row * outerHeight + tileMargin, innerWidth, innerHeight);
        }
      } else if (isDrawBoxTwo) {
        drawSceneTo(perspectiveBuffer, boxOne, boxTwo, "boxTwo");
        g.image(perspectiveBuffer, col * outerWidth, row * outerHeight + tileMargin, innerWidth, innerHeight);
      }

      if (isDrawHud) {
        g.text("yaw: " + floor(degrees(yaw)) + ", pitch: " + floor(degrees(pitch)),
          col * outerWidth + 6, row * outerHeight + 16);
      }
    }
  }
}

int getSize(int approxTileSize, int canvasWidth, int canvasHeight, int margin) {
  float tileOuterWidth = approxTileSize + margin;
  float tileOuterHeight = approxTileSize + 2 * margin;

  if (canvasWidth / (2 * tileOuterWidth) < canvasHeight / tileOuterHeight) {
    // number of columns is the limiting factor.
    int numCols = floor(canvasWidth / (2 * tileOuterWidth));
    return floor((float)canvasWidth / (2 * numCols)) - margin;
  }

  // number of rows is the limiting factor.
  int numRows = floor(canvasHeight / tileOuterHeight);
  return floor((float)canvasHeight / numRows) - 2 * margin;
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

  g.stroke(#7fbf7a); // green
  drawBox(g, boxOne);

  g.stroke(#af8dc3); // purple
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
    case '1':
      isDrawBoxOne = true;
      isDrawBoxTwo = false;
      reset();
      break;
    case '2':
      isDrawBoxOne = false;
      isDrawBoxTwo = true;
      reset();
      break;
    case '3':
      isDrawBoxOne = true;
      isDrawBoxTwo = true;
      reset();
      break;
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