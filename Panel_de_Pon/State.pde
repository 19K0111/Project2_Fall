// 参考：http://www2.kobe-u.ac.jp/~tnishida/misc/processing-state.html
abstract class State {
  State doState() {
    drawState();
    return decideState();
  }

  abstract void drawState();
  abstract State decideState();

  void mousePressedState() {
  }

  void keyPressedState() {
  }

  void keyReleasedState() {
  }
}
