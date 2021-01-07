Button el_button;
Button ta_button;
Button pz_button;
Button button4;

class MenuState extends State {
  void drawState() {
    background(#0c0c33);

    textSize(60);
    fill(255, 255, 255);
    textAlign(LEFT);
    text("Panel de Pon", 110, 80);

    textAlign(CENTER, CENTER);
    rectMode(CENTER);
    el_button=new Button(width/4, 200, 200, 80, color(240, 100, 55), "Endless");
    ta_button=new Button(width/4, 400, 200, 80, color(240, 100, 55), "Time Attack");
    pz_button=new Button(width/4, 600, 200, 80, color(240, 100, 55), "Puzzle");
    // el_button=new Button(width/2, 200,200,80,color(240,100,55),"Endless");


    el_button.run();
    ta_button.run();
    pz_button.run();

    if(el_button.isPush()){
      println("Endless");
      mode=GAMEMODE.Endless;
    }
    if(ta_button.isPush()){
      println("Time Attack");
      mode=GAMEMODE.TimeAttack;
    }
  }

  State decideState() {
    switch (mode) {
      case Endless:
      try {
        highscore=int(loadStrings(String.valueOf(mode))[0]);
      } catch (Exception e) {
        //TODO: handle exception
        println(e);
      }
      state=new MenuExtendState();
      break;
        // return state;
      case TimeAttack:
      try {
        highscore=int(loadStrings(String.valueOf(mode))[0]);
      } catch (Exception e) {
        //TODO: handle exception
        println(e);
      }
      state=new MenuExtendState();
      break;  
        // return state;
      case Puzzle:
        
        break;
      case VSCom:
        
        break;
      case BACK:
        // mode=GAMEMODE.IDLE;
        break;
    
      default:
        break;
    }

    return state;
  }
}
