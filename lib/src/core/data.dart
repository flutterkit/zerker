class Data {
  String? mark;
  double x = 0;
  double y = 0;
  double speed = 0;
  double alpha = 1;
  double radius = 0;
  double angle = 0;
  double value = 0;

  reset() {
    mark = null;
    angle = 0;
    x = 0;
    y = 0;
    speed = 0;
    alpha = 1;
    radius = 0;
    value = 0;
  }

  destroy() {
    reset();
  }
}
