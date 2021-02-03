Button easy_button;
Button nml_button;
Button hard_button;

Button back_button;

public class MenuExtendState extends State {
  void drawState() {
    background(#0c0c33);

    textSize(60);
    fill(255, 255, 255);
    textAlign(LEFT);
    text(String.valueOf(mode), 150, 80);
    /*
    text("Panel de Pon", 110, 80);
     textSize(40);
     text(String.valueOf(mode), 150, 130);
     */

    textAlign(CENTER, CENTER);
    rectMode(CENTER);
    easy_button = new Button(width * 3 / 4, 200, 200, 80, color(240, 100, 55), "Easy");
    nml_button = new Button(width * 3 / 4, 400, 200, 80, color(240, 100, 55), "Normal");
    hard_button = new Button(width * 3 / 4, 600, 200, 80, color(240, 100, 55), "Hard");
    // el_button=new Button(width/2, 200,200,80,color(240,100,55),"Endless");

    back_button = new Button(50, 860, 100, 80, color(5, 192, 50), "Back");


    easy_button.run();
    nml_button.run();
    hard_button.run();

    back_button.run();

    if (easy_button.isPush()) {
      println("Easy");
      gamelv = GAMELEVEL.Easy;
      FALL_SPEED_PER_FR = 9;
    }
    if (nml_button.isPush()) {
      println("Normal");
      gamelv = GAMELEVEL.Normal;
      FALL_SPEED_PER_FR = 6;
    }
    if (hard_button.isPush()) {
      println("Hard");
      gamelv = GAMELEVEL.Hard;
      FALL_SPEED_PER_FR = 3;
    }
    if (back_button.isPush()) {
      println("Back");
      gamelv = GAMELEVEL.BACK;
    }
  }
  State decideState() {
    switch (gamelv) {
    case Easy:
      frameCount = 0;
      state = new GameState();
      break;
    case Normal:
      frameCount = 0;
      state = new GameState();
      break;
    case Hard:
      frameCount = 0;
      state = new GameState();
      break;
    case IDLE:
      gamelv = GAMELEVEL.IDLE;
      break;
    case BACK:
      mode = GAMEMODE.BACK;
      gamelv = GAMELEVEL.IDLE;
      state = new MenuState();
      break;

    default:
      break;
    }

    return state;
  }

  void keyPressedState() {
    if (key == 'e' && !menukey) {
      menukey = true;
      gamelv = GAMELEVEL.Easy;
      FALL_SPEED_PER_FR = 9;
    } else if (key == 'n' && !menukey) {
      menukey = true;
      gamelv = GAMELEVEL.Normal;
      FALL_SPEED_PER_FR = 6;
    } else if (key == 'h' && !menukey) {
      menukey = true;
      gamelv = GAMELEVEL.Hard;
      FALL_SPEED_PER_FR = 3;
    } else if (key == 'b' && !menukey) {
      menukey = false;
      gamelv = GAMELEVEL.BACK;
    }
  }
  void keyReleasedState() {
    if (key == 'e' && menukey) {
      menukey = false;
    } else if (key == 'n' && menukey) {
      menukey = false;
    } else if (key == 'h' && menukey) {
      menukey = false;
    } else if (key == 'b' && menukey) {
      menukey = false;
    }
  }
}

public enum GAMEMODE {
  Endless,
  TimeAttack,
  Puzzle,
  VSCom,

  IDLE,
  BACK
}

public enum GAMELEVEL {
  Easy,
  Normal,
  Hard,

  IDLE,
  BACK
}
