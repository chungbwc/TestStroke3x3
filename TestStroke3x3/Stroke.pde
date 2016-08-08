public class Stroke {
  final float MIN_DIST = 0.2; 
  final int MAX_POINT = 2000;
  final float LEFT_MARGIN = 0.0;
  final float RIGHT_MARGIN = 0.0;
  final float TOP_MARGIN = 0.0;
  final float BOTTOM_MARGIN = 0.0;

  PVector mn;
  PVector mx;
  ChinChar parent;
  ArrayList<PVector> points;

  public Stroke(ChinChar p) {
    parent = p;
    mn = new PVector(width, height);
    mx = new PVector(0, 0);
    points = new ArrayList<PVector>();
  }

  PVector norm(PVector p) {
    PVector t = new PVector();
    float xRange = mx.x - mn.x;
    float yRange = mx.y - mn.y;
    float xScale = 1.0 - LEFT_MARGIN - RIGHT_MARGIN;
    float yScale = 1.0 - TOP_MARGIN - BOTTOM_MARGIN;
    float xOffset = 0.0;
    float yOffset = 0.0;
    if (xRange > yRange) {
      yScale = yRange * xScale / xRange;
      yOffset = (xScale - yScale) / 2;
      //yOffset = (xRange - yRange) / 2;
    } else {
      xScale = xRange * yScale / yRange;
      xOffset = (yScale - xScale) / 2;
      //xOffset = (yRange - xRange) / 2;
    }

    t.x = (p.x - mn.x) / xRange;
    t.y = (p.y - mn.y) / yRange;
    t.x = t.x * xScale + LEFT_MARGIN + xOffset;
    t.y = t.y * yScale + TOP_MARGIN + yOffset;
    return t;
  }

  void addPoint(PVector p) {
    if (points.size() > MAX_POINT) 
      return;
    if (p.x < mn.x) {
      mn.x = p.x;
    }
    if (p.y < mn.y) {
      mn.y = p.y;
    }
    if (p.x > mx.x) {
      mx.x = p.x;
    }
    if (p.y > mx.y) {
      mx.y = p.y;
    }

    if (points.size()==0) {
      points.add(p);
    } else {
      float d = p.dist(points.get(points.size()-1));
      if (d > MIN_DIST) {
        points.add(p);
      }
    }
    parent.adjustMinMax(mn, mx);
  }

  void drawPoints() {
    pushStyle();
    noFill();
    stroke(255, 255, 255, 100);
    for (int i=0; i<points.size()-1; i++) {
      PVector p1 = points.get(i);
      PVector p2 = points.get(i+1);
      line(p1.x, p1.y, p2.x, p2.y);
    }
    popStyle();
  }

  ArrayList<PVector> getNormList() {
    ArrayList<PVector> l = new ArrayList<PVector>();
    if (points.size() < 2) {
      return null;
    } else {
      for (int i=0; i<points.size(); i++) {
        l.add(norm(points.get(i)));
      }
      return l;
    }
  }

  void drawNorm() {
    pushStyle();
    noFill();
    stroke(255, 255, 0);
    ArrayList<PVector> list = getNormList();
    if (list!=null) {
      for (int i=0; i<list.size()-1; i++) {
        PVector p1 = list.get(i);
        PVector p2 = list.get(i+1);
        line(p1.x*half, p1.y*height, p2.x*half, p2.y*height);
      }
    }
    popStyle();
  }

  void clear() {
    points.clear();
  }

  void adjustMinMax(PVector pn, PVector px) {
    if (pn.x < mn.x) {
      mn.x = pn.x;
    }
    if (pn.y < mn.y) {
      mn.y = pn.y;
    }
    if (px.x > mx.x) {
      mx.x = px.x;
    }
    if (px.y > mx.y) {
      mx.y = px.y;
    }
  }
}