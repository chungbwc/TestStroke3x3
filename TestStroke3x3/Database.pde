import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.ml.KNearest;
import org.opencv.ml.Ml;
import org.opencv.core.MatOfInt;

public class Database {
  final int W = 3;
  final int TYPE = 2;
  final int NUM_C = 1000;
  final int NUM_D = W*W*2+1;

  String dataFile;
  double [] trainData;
  int [] labels;
  String [] chrNames;
  KNearest knn;
  Mat trainFeatures;
  Mat trainLabels;

  public Database() {
    System.loadLibrary(Core.NATIVE_LIBRARY_NAME);
    dataFile = "charTrain.csv";
    trainData = new double[NUM_C*NUM_D];
    labels = new int[NUM_C];
    chrNames = new String[NUM_C];
    initLabel();
    try {
      readFile();
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
    knn = KNearest.create();
    prepareData();
  }

  void initLabel() {
    for (int i=0; i<labels.length; i++) {
      labels[i] = i+1;
    }
  }

  void readFile() throws IOException {
    BufferedReader reader = createReader(dataFile);
    String line = reader.readLine();
    int idx = 0;

    while (line != null && idx < NUM_C) {
      String [] items = split(line, ',');
      for (int i=0; i<NUM_D; i++) {
        trainData[idx*NUM_D+i] = Float.parseFloat(items[i+1]);
        chrNames[idx] = items[0];
      }
      idx++;
      line = reader.readLine();
    }
    println("Database loaded with " + idx + " characters");
  }

  void prepareData() {
    trainFeatures = new Mat(NUM_C, NUM_D, CvType.CV_32FC1);
    trainLabels = new Mat(NUM_C, 1, CvType.CV_32SC1);
    trainFeatures.put(0, 0, trainData);
    trainLabels.put(0, 0, labels);
    knn.train(trainFeatures, Ml.ROW_SAMPLE, trainLabels);
    println("KNN model trained.");
  }

  float predict(float [] f) {
    Mat test = new Mat(1, NUM_D, CvType.CV_32FC1);
    int K = 1;
    for (int i=0; i<NUM_D; i++) {
      test.put(0, i, f[i]);
    }
    //   println("Test with features " + test.dump());
    Mat results = new Mat();
    Mat dist = new Mat();
    Mat neighbor = new Mat();
    float val = knn.findNearest(test, K, results, neighbor, dist);
    int i = floor(val-1);
    println("Matched character " + chrNames[i]);
    println("Matched distance " + dist.dump());
    println("Trained data ...");
    for (int j=0; j<NUM_D; j++) {
      int k = i*NUM_D + j;
      println(j + ", " + trainData[k]);
    }
    return val;
  }
}