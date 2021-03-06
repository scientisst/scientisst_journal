abstract class ControllerInterface {
  final int bufferSizeSeconds;

  ControllerInterface({this.bufferSizeSeconds = 5});

  Stream listen();

  void record({String path});

  void stop();

  //void dispose();
}
