public class Drawing {
  File [] files;
  String fName;
  int idx;
  XML xml;
  float factor;
  boolean drawn;

  public Drawing() {
    factor = 16.0;
    files = getFiles();
    Arrays.sort(files);
    drawn = false;
  }

  File [] getFiles() {
    File [] fs;
    File dir = new File(dataPath(""));
    fs = dir.listFiles(new FilenameFilter() {
      public boolean accept(File d, String n) {
        return n.toLowerCase().endsWith(".xml");
      }
    }
    );
    return fs;
  }

  void setFile(int i) {
    fName = files[i-1].getName();
    xml = loadXML(fName);
    drawn = true;
  }

  void drawChar(PVector o, float s) {
    if (!drawn) 
      return;
    XML [] strokes = xml.getChildren("stroke");
    pushStyle();
    stroke(0);
    for (XML x : strokes) {
      XML [] pts = x.getChildren("point");
      if (pts.length < 2) 
        continue;
      for (int i=0; i<pts.length-1; i++) {
        XML pt1 = pts[i];
        XML pt2 = pts[i+1];
        float x1 = pt1.getChild("x").getFloatContent();
        float y1 = pt1.getChild("y").getFloatContent();
        float x2 = pt2.getChild("x").getFloatContent();
        float y2 = pt2.getChild("y").getFloatContent();
        float w1 = pt1.getChild("w").getFloatContent();
        strokeWeight(w1*factor);
        line(x1*s+o.x, y1*s+o.y, x2*s+o.x, y2*s+o.y);
      }
    }
    popStyle();
  }

  void clear() {
    drawn = false;
  }
}