import processing.sound.*;
class SE {
  SoundFile ready, start;
  SE() {
    ready=new SoundFile(Panel_de_Pon.this, "se_ready.mp3");
    start=new SoundFile(Panel_de_Pon.this, "se_start.mp3");
  }

  void play(String name) {
    switch (name) {
    case "ready":
      ready.play();
      break;
    case "start":
      start.play();
      break;

    default:
      break;
    }
  }
}
