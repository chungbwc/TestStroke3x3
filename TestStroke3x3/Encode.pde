public class Encode {
  final int W = 3;
  final int SIZE = W*W;
  final int TYPE = 2;
  final float MIN_LEN = 0.0001;

  float [] features;
  Grid [] grids;
  float nStrokes;
  ChinChar chr;

  public Encode() {
    nStrokes = 0;
    features = new float[SIZE*TYPE+1];
    for (int i=0; i<features.length; i++) {
      features[i] = 0.0;
    }
    grids = new Grid[SIZE];
    for (int i=0; i<grids.length; i++) {
      grids[i] = new Grid();
    }
  }

  int getLength() {
    return features.length;
  }

  void procChar(ChinChar c) {
    chr = c;
    nStrokes = 0;
    for (Grid g : grids) {
      g.reset();
    }

    nStrokes = chr.strokes.size();
    for (Stroke s : chr.strokes) {
      if (s.points.size() < 2) 
        continue;
      for (int i=0; i<s.points.size()-1; i++) {
        int j = i+1;
        accumAngles(s.points.get(i), s.points.get(j));
      }
    }
  }

  void accumAngles(PVector p1, PVector p2) {
    float step = 1.0/W;
    int x = constrain(floor(p1.x/step), 0, W-1);
    int y = constrain(floor(p1.y/step), 0, W-1);
    int idx = y*W+x;
    PVector v = PVector.sub(p2, p1);
    if (v.mag() > MIN_LEN) 
      grids[idx].accumAngles(v);
  }

  void prepareData() {
    float mi = Float.MAX_VALUE;
    float mx = Float.MIN_VALUE;
    for (Grid g : grids) {
      float v = g.angles.mag();
      if (v < mi) {
        mi = v;
      }
      if (v > mx) {
        mx = v;
      }
    }
    float range = mx - mi;
    features[0] = nStrokes/10.0;

    for (int i=0; i<grids.length; i++) {
      float len = grids[i].angles.mag();
      len = (len - mi)/range;
      float ang = degrees(grids[i].angles.heading());
      if (ang < 0) {
        ang += 360;
      }
      features[i+1] = len;
      features[i+grids.length+1] = ang/360.0;
    }
  }

  float [] getFeatures() {
    return features;
  }
}