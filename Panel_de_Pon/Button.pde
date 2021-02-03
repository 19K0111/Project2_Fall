// 参考：https://tofgame.hatenablog.com/entry/2019/07/18/175359
class Button {
  float x, y;
  float sizeX, sizeY;
  int state;

  color baseCol;
  float nb;
  float sb;
  float pb;

  String str;

  Button(float x, float y, float sizeX, float sizeY, color baseCol, String str) {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
    this.baseCol = baseCol;
    this.str = str;

    nb = 1; //normalBrightness
    sb = 0.8; //selectBrightness
    pb = 0.6; //pushBrightness
  }

  void run() {
    rogic();
    display();
  }

  void display() {
    noStroke();
    changeColor();
    rect(x, y, sizeX, sizeY);

    fill(0, 0, 100);
    textSize(30);
    text(str, x, y);
  }

  void rogic() {
    state = checkState();
  }

  //===================================================================
  boolean isPush() {
    if (checkState() == 2) return true;
    return false;
  }

  int checkState() {
    if (!checkInMouse()) return 0;
    if (!mousePressed) return 1;
    return 2;
  }

  boolean checkInMouse() {
    if (mouseX > x - sizeX / 2 && mouseX < x + sizeX / 2) {
      if (mouseY > y - sizeY / 2 && mouseY < y + sizeY / 2) {
        return true;
      }
    }
    return false;
  }

  void changeColor() {
    switch (state) {
    case 0:
      fill(hue(baseCol), saturation(baseCol), brightness(baseCol) * nb);
      break;

    case 1:
      fill(hue(baseCol), saturation(baseCol), brightness(baseCol) * sb);
      break;

    case 2:
      fill(hue(baseCol), saturation(baseCol), brightness(baseCol) * pb);
      break;

    default:
      fill(0, 0, 0);
      break;
    }
  }
}