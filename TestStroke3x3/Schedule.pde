import java.util.TimerTask;

public class Schedule extends TimerTask {
  TestStroke3x3 parent;

  public Schedule(TestStroke3x3 p) {
    super();
    parent = p;
  }

  public void run() {
    parent.message();
  }
}