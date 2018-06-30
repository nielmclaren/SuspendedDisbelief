
import org.apache.commons.lang3.ArrayUtils;

class Box {
  public float size;
  public float yaw;
  public float pitch;

  Box() {
    size = 0;
    yaw = 0;
    pitch = 0;
  }

  Box(float sizeArg, float yawArg, float pitchArg) {
    size = sizeArg;
    yaw = yawArg;
    pitch = pitchArg;
  }

  PVector[] getPoints() {
    PVector[] points = new PVector[8];
    points[0] = getPoint(-1, -1, -1);
    points[1] = getPoint(-1, -1,  1);
    points[2] = getPoint(-1,  1, -1);
    points[3] = getPoint(-1,  1,  1);
    points[4] = getPoint( 1, -1, -1);
    points[5] = getPoint( 1, -1,  1);
    points[6] = getPoint( 1,  1, -1);
    points[7] = getPoint( 1,  1,  1);
    return points;
  }

  int getNumFaces() {
    return 6;
  }

  PVector [] getFacePoints(int faceIndex) {
    switch (faceIndex) {
      case 0: return getFacePoints(-1,  0,  0);
      case 1: return getFacePoints( 1,  0,  0);
      case 2: return getFacePoints( 0, -1,  0);
      case 3: return getFacePoints( 0,  1,  0);
      case 4: return getFacePoints( 0,  0, -1);
      case 5: return getFacePoints( 0,  0,  1);

      default: return getFacePoints(-1, 0, 0);
    }
  }

  // One of dx, dy, dz should be positive or negative one. Others must be zero.
  private PVector[] getFacePoints(int dx, int dy, int dz) {
    if (dx != 0) {
      return new PVector[]{ getPoint(dx, -1, -1), getPoint(dx, -1, 1), getPoint(dx, 1, 1), getPoint(dx, 1, -1) };
    } else if (dy != 0) {
      return new PVector[]{ getPoint(-1, dy, -1), getPoint(-1, dy, 1), getPoint(1, dy, 1), getPoint(1, dy, -1) };
    } else if (dz != 0) {
      return new PVector[]{ getPoint(-1, -1, dz), getPoint(-1, 1, dz), getPoint(1, 1, dz), getPoint(1, -1, dz) };
    }
    return null;
  }

  int getNumEdges() {
    return 12;
  }

  PVector[] getEdgePoints(int edgeIndex) {
    switch (edgeIndex) {
      case 0: return new PVector[]{ getVertexPoint(0), getVertexPoint(1) };
      case 1: return new PVector[]{ getVertexPoint(2), getVertexPoint(3) };
      case 2: return new PVector[]{ getVertexPoint(4), getVertexPoint(5) };
      case 3: return new PVector[]{ getVertexPoint(6), getVertexPoint(7) };

      case 4: return new PVector[]{ getVertexPoint(0), getVertexPoint(2) };
      case 5: return new PVector[]{ getVertexPoint(1), getVertexPoint(3) };
      case 6: return new PVector[]{ getVertexPoint(4), getVertexPoint(6) };
      case 7: return new PVector[]{ getVertexPoint(5), getVertexPoint(7) };

      case 8: return new PVector[]{ getVertexPoint(0), getVertexPoint(4) };
      case 9: return new PVector[]{ getVertexPoint(1), getVertexPoint(5) };
      case 10: return new PVector[]{ getVertexPoint(2), getVertexPoint(6) };
      case 11: return new PVector[]{ getVertexPoint(3), getVertexPoint(7) };

      default: return null;
    }
  }

  int getNumVertices() {
    return 8;
  }

  PVector getVertexPoint(int vertexIndex) {
    return getPoint(floor(vertexIndex / 4.) % 2 * 2 - 1, floor(vertexIndex / 2.) % 2 * 2 - 1, vertexIndex % 2 * 2 - 1);
  }

  int getRandomVertexIndex() {
    return floor(random(getNumVertices()));
  }

  int[] getAdjacentVertexIndices(int vertexIndex) {
    switch (vertexIndex) {
      case 0: return new int[]{ 1, 2, 4 };
      case 1: return new int[]{ 0, 3, 5 };
      case 2: return new int[]{ 0, 3, 6 };
      case 3: return new int[]{ 1, 2, 7 };
      case 4: return new int[]{ 0, 5, 6 };
      case 5: return new int[]{ 1, 4, 7 };
      case 6: return new int[]{ 2, 4, 7 };
      case 7: return new int[]{ 3, 5, 6 };

      default: return null;
    }
  }

  int getRandomAdjacentVertexIndex(int vertexIndex) {
    int[] indices = getAdjacentVertexIndices(vertexIndex);
    return indices[floor(random(indices.length))];
  }

  int[] getAdjacentVertexIndicesExcept(int vertexIndex, int exceptIndex) {
    int[] indices = getAdjacentVertexIndices(vertexIndex);
    return ArrayUtils.removeElement(indices, exceptIndex);
  }

  int getRandomAdjacentVertexIndexExcept(int vertexIndex, int exceptIndex) {
    int[] indices = getAdjacentVertexIndicesExcept(vertexIndex, exceptIndex);
    return indices[floor(random(indices.length))];
  }

  // Each of dx, dy, dz should be positive or negative one.
  private PVector getPoint(int dx, int dy, int dz) {
    PVector point = new PVector(dx * size/2, dy * size/2, dz * size/2);
    PVector result = new PVector();

    PMatrix3D m = new PMatrix3D();
    m.rotate(yaw, 0, 1, 0);
    m.rotate(pitch, 0, 0, 1);
    m.mult(point, result);

    return result;
  }
}