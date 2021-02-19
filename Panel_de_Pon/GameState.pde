public class GameState extends State {
  /// TODO:
  /// 同時消しのバグ　L字型(5)に消えない -> おそらく治った
  /// 新しいパネル生成　よりよい乱数 -> 3つ連続で同じパネルが出現することもある。
  /// 連鎖の判定
  /// せり上げボタンの配置を決める。
  /// 19.3秒に1段最低せり上がる。(最高0.2秒に1段)
  /// スコアとタイム、ポーズ・リセット、開始前のカウントダウン
  /// パネルを消すアルゴリズム(横の判定 -> 縦の判定、上から見ていく)
  /// for y = 12 to 1
  ///   for x = 0 to 3
  ///     if 現在見ているパネルと1つ右のパネルが同じ
  ///       if 現在見ているパネルと2つ右のパネルが同じ
  ///         cells[y][x]==1, cells[y][x+1]==1, cells[y][x+2]==1
  /// for x = 0 to 5
  ///   for y = 12 to 2
  ///     if 現在見ているパネルと1つ下のパネルが同じ
  ///       if 現在見ているパネルと2つ下のパネルが同じ
  ///         cells[y][x]==1, cells[y+1][x]==1, cells[y+2][x]==1
  ///
  /// 揃ったときの点滅6回
  /// 点滅時にcellsの値を毎フレーム1増やす
  /// cellsが60くらいになったら消す
  /// 
  /// 落下のアルゴリズム -> 下から見ていく -> 見ているパネルが透明-> 1つ上のパネルを下に(1つ上のパネルと交換)
  /// 
  /// 全消しボーナス：1500(GBA), 3000(DS)
  /// 
  /// 基本消し : 30
  /// 同時消し4 : 100+40
  /// 同時消し5 : 240+50
  /// 同時消し6 : 390+60
  /// 同時消し7 : 550+70
  /// 同時消し8 : 720+80
  /// 同時消し9 : 900+90
  /// 同時消しn : 5*(n-3)*(n+24)
  /// 同時消し15から連鎖数関係なく表示
  ///
  /// 2連鎖 : 50+30=80 (50)
  /// 3連鎖 : 160+30=190 (80)
  /// 4連鎖 : 340+30=370 (150)
  /// 5連鎖 : 670+30=700 (300)
  /// 6連鎖 : 1100+30=1130 (400)
  /// 7連鎖 : 1630+30=1660 (500)
  /// 8連鎖 : 2360+30=2390 (700)
  /// 9連鎖 : 3290+30=3320 (900)
  /// 10連鎖 : 4420+30=4450 (1100)
  /// 11連鎖 : 5750+30=5780 (1300)
  /// 12連鎖 : 7280+30=3320 (1500)
  /// 13連鎖以降 : (1800)
  ///

  // final int PANEL_SIZE = 50;
  // final int MARGIN_X = 80;
  // final int MARGIN_Y = 275;
  // final int FRAME_RATE=60;
  // final boolean DEBUG =true;
  // final int FALL_SPEED_PER_FR=3; // 落下速度を決める
  // final String PERFECT_TEXT="Perfect";
  // PImage cursor;
  // int cx;
  // int cy;

  // PImage[] panels = new PImage[6];
  // // PImage panel1;
  // // PImage panel2;
  // // PImage panel3;
  // // PImage panel4;
  // // PImage panel5;

  // PImage[][] cells_img = new PImage[13][6];
  // int[][] cells_type=new int[13][6]; // パネルの情報
  // // cells_type == 0 : 
  // // cells_type == 1 : ♡
  // // cells_type == 2 : ○
  // // cells_type == 3 : △
  // // cells_type == 4 : ☆
  // // cells_type == 5 : ♢
  // int[][] cells = new int[13][6];
  // // cells == 0      : 通常
  // // cells == 1      : 揃った
  // // cells == 2 ~ 60 : 消している
  // // cells == 70     : 消えた
  // // cells == 80     : 落下
  // // cells == 90     : 落下し終わる
  // int[][] cells_chain = new int[13][6]; // 連鎖数を格納

  // boolean pcf;// Panel Changed Flag
  // boolean up, down, left, right;
  // boolean ccf=false; // chains changed flag 連鎖が増えたときtrue
  // boolean manualflag; // 手動でパネルを動かしたらtrue(連鎖の判定で用いる)
  // boolean startflag=false;
  // boolean gameover;
  // boolean zerobonus;

  // int timer=0;
  // int chains=0; // 連鎖
  // int score=0;
  // int highscore;
  // int fieldpanels=0;

  // Timer gameTimer;
  // int h;
  // int m;
  // int s;
  // int millsec;

  // SE se;
  // int ready_cnt;

  // int speedLv=1;

  // int arrtime; // 揃ってから消すまでインクリメント

  // void setup() {
  //   size(600, 900);
  //   // background(230);
  //   // background(#11cf55);
  //   frameRate(FRAME_RATE);
  //   strokeWeight(1);
  //   PFont font;
  //   font = loadFont("MeiryoUI-48.vlw");
  //   cursor = loadImage("cursor.png");
  //   panels[0] = loadImage("panel0.png");
  //   panels[1] = loadImage("panel1.png");
  //   panels[2] = loadImage("panel2.png");
  //   panels[3] = loadImage("panel3.png");
  //   panels[4] = loadImage("panel4.png");
  //   panels[5] = loadImage("panel5.png");
  //   // panel1=loadImage("panel1.png");
  //   // panel2=loadImage("panel2.png");
  //   // panel3=loadImage("panel3.png");
  //   // panel4=loadImage("panel4.png");
  //   // panel5=loadImage("panel5.png");
  //   cx = MARGIN_X - 5 + PANEL_SIZE * 2;
  //   cy = MARGIN_Y - 5 + PANEL_SIZE * 6;
  //   timer=0;
  //   score=0;
  //   h=0;
  //   m=0;
  //   s=0;
  //   frameCount=0;
  //   startflag=false;
  //   gameover=false;
  //   zerobonus=false;
  //   dispFlag=false;
  //   se=new SE();
  //   ready_cnt=3;
  //   speedLv=1;
  //   for (int y = 12; y >= 0; y--) {
  //     for (int x = 0; x < 6; x++) {
  //       // パネルの初期化 それぞれに空のパネルを配置
  //       cells_img[y][x] = panels[0];
  //       cells_type[y][x]=0;
  //     }
  //   }
  //   for (int y = 5; y >= 0; y--) {
  //     for (int x = 0; x < 6; x++) {
  //       cells_img[y][x] = panels[(x + y) % 5 + 1];
  //       cells_type[y][x]=(x + y) % 5 + 1;
  //       cells[y][x]=0;
  //     }
  //   }
  //   for (int y = 12; y >= 0; y--) {
  //     for (int x = 0; x < 6; x++) {
  //       if(cells_img[y][x]==panels[0]){
  //         cells[y][x]=70;
  //       }
  //     }
  //   }
  // }

  void drawState() {
    textAlign(LEFT, BASELINE);
    rectMode(CORNER);
    stage();

    if (cooldown > 0) {
      cooldown--;
    }
    if (startflag && seriagetimer % ((21 - speedLv)) == 0 && cooldown == 0) {
      seriagebar++;
      if (seriagebar > 100) {
        seriage();
        seriagebar = 0;
      }
    }
    // せり上げバー描画
    if (!gameover) {
      fill(255, 165, 0);
      // rect(MARGIN_X, MARGIN_Y-5, ((float)frameCount/21%PANEL_SIZE*6),5);
      rect(MARGIN_X, MARGIN_Y - 5, ((float)seriagebar / 100 * PANEL_SIZE * 6), 5);
    }
    // startflag=false;
    if (frameCount > FRAME_RATE * 3 && !startflag) {
      startflag = true;
    } else if (frameCount <= FRAME_RATE * 3 && !startflag) {
      // 開始前カウントダウン
      float alpha = 255 - float(((frameCount - 1) % FRAME_RATE) * 255 / (FRAME_RATE - 1));
      fill(0, 0, 0, int(alpha));
      // println(alpha);
      textSize(90);
      text("READY\n    " + ready_cnt, MARGIN_X, MARGIN_Y + PANEL_SIZE * 3);
      if (frameCount % FRAME_RATE == 0) {
        ready_cnt -= 1;
      }
      if (frameCount % FRAME_RATE == 1) {
        se.play("ready");
      }
    }
    if (startflag && timer == 0) {
      // println("start");
      frameCount = 0;
      se.play("start");
      if (mode == GAMEMODE.TimeAttack) {
        gameTimer = new Timer(timer, FRAME_RATE, TA_HOUR, TA_MINUTE, TA_SECOND);
      } else {
        gameTimer = new Timer(timer, FRAME_RATE);
      }
      gameTimer.start();
    }
    if (mode == GAMEMODE.TimeAttack && gameTimer != null) {
      if (gameTimer.isTimeUp() && !gameover) {
        gameover = true;
        PrintWriter output = createWriter(String.valueOf(mode));
        output.println(highscore);
        output.flush();
        output.close();
      }
    }

    if (gameover) {
      gameTimer.stop();
      cx = 1000;
      cy = 1000;
      fill(0);
      textSize(105);
      if (gameTimer.isTimeUp()) {
        // text("TIME\nOVER", MARGIN_X, MARGIN_Y+PANEL_SIZE*3+sin(frameCount/(FRAME_RATE/3))*PANEL_SIZE/2);
        text("TIME\nOVER", MARGIN_X, MARGIN_Y + PANEL_SIZE * 3 + sin((frameCount % (4 * FRAME_RATE)) * (float)Math.PI / (2 * FRAME_RATE)) * PANEL_SIZE / 2);
      } else {
        // text("GAME\nOVER", MARGIN_X, MARGIN_Y+PANEL_SIZE*3+sin(frameCount/(FRAME_RATE/3))*PANEL_SIZE/2);
        text("GAME\nOVER", MARGIN_X, MARGIN_Y + PANEL_SIZE * 3 + sin((frameCount % (4 * FRAME_RATE)) * (float)Math.PI / (2 * FRAME_RATE)) * PANEL_SIZE / 2);
      }
    }
    if (startflag) {
      checkPanel();
      timer += 1;
      seriagetimer += 1;
      // println(gameTimer.toString());
      // h=hour();
      // m=minute();
      // s=second();
      // millsec=millis();
      // String timetostring=h+":"+m+":"+s+"\'"+millsec;
      // println(timetostring);
    }
    if (dispFlag) {
      if (!dispTimer.isTimeUp()) {
        if (ischain){
          // 連鎖用表示設定
          fill(0, 166, 212);
        } else {
          // 同時消し用表示設定
          fill(255, 125, 0);
        }
        textSize(100);
        text(dispNum, MARGIN_X + PANEL_SIZE * 7, MARGIN_Y + PANEL_SIZE);
        dispTimer.toString();
      } else {
        dispFlag = false;
      }
    }

    textAlign(CENTER, CENTER);
    rectMode(CENTER);
    back_button = new Button(550, 860, 100, 80, color(5, 192, 50), "Back");
    back_button.run();
    if (back_button.isPush()) {
      println("Back");
      gamelv = GAMELEVEL.IDLE;
    }

  }

  void mousePressedState() {
    if (DEBUG) {
      if (mouseX > MARGIN_X && mouseX<MARGIN_X + PANEL_SIZE * 6 && mouseY>MARGIN_Y && mouseY < MARGIN_Y + PANEL_SIZE * 13) {
        int panelX, panelY;
        panelX = (mouseX - MARGIN_X) / PANEL_SIZE;
        panelY = 12 - (mouseY - MARGIN_Y) / PANEL_SIZE;
        println("(" + panelX + ", " + panelY + "), cells_type[" + panelY + "][" + panelX + "] = " + cells_type[panelY][panelX]);
        // println("cells_img["+panelY+"]["+panelX+"] = "+cells_img[panelY][panelX]);
        println("cells[" + panelY + "][" + panelX + "] = " + cells[panelY][panelX]);
        println("cells_chain[" + panelY + "][" + panelX + "] = " + cells_chain[panelY][panelX] + ", chain = " + chains);
        println("isDeleting: " + isDeleting + ", chainkeeper: " + chainkeeper + ", fallflag: " + fallflag);
      }
    }
  }

  void stage() {
    background(12, 12, 51);
    fill(255);
    for (int j = 0; j < 12; j++) {
      for (int i = 0; i < 6; i++) {
        // rect(MARGIN_X + PANEL_SIZE * i, MARGIN_Y + PANEL_SIZE * j, PANEL_SIZE, PANEL_SIZE);
      }
    }
    //   println("("+mouseX+", "+mouseY+")");
    if (startflag) {
      switch (getMaxPanelHeight()) {
      case 10:
        fill(255, 255, 0, 127);
        break;
      case 11:
        fill(255, 140, 0, 127);
        break;
      case 12:
        fill(178, 34, 34, 127);
        break;

      default:
        fill(255);
        break;
      }
    }
    rect(MARGIN_X, MARGIN_Y, PANEL_SIZE * 6, PANEL_SIZE * 12);
    txt();
    placePanel();
    fill(0, 0, 0, 127);
    rect(MARGIN_X, MARGIN_Y + PANEL_SIZE * 12, PANEL_SIZE * 6, PANEL_SIZE);
    image(cursor, cx, cy, PANEL_SIZE * 2 * 1.12, PANEL_SIZE * 1.22);
  }

  void txt() {
    fill(#ff55dd);
    textSize(48);
    if (gameTimer == null) {
      if (mode == GAMEMODE.TimeAttack) {
        text("TIME: " + String.format("%01d", TA_HOUR) + ":" + String.format("%02d", TA_MINUTE) + "'" + String.format("%02d", TA_SECOND) + "''000\nHIGH SCORE: " + highscore + "\n  SCORE: " + score, 80, 80);
      } else {
        text("TIME: 0:00'00''000\nHIGH SCORE: " + highscore + "\n  SCORE: " + score, 80, 80);
      }
    } else {
      text("TIME: " + gameTimer.toString() + "\nHIGH SCORE: " + highscore + "\n  SCORE: " + score, 80, 80);
    }
    //   println("("+mouseX+", "+mouseY+")");
  }

  void checkPanel() {
    boolean chaincombo = false; // 同時消しを含む連鎖
    for (int y = 1; y < 12; y++) {
      for (int x = 0; x < 6; x++) {
        if (cells_img[y][x] == panels[0] && !(0 < cells[y][x] && cells[y][x] < 70)) {
          // 空いてる場所を70にする
          cells[y][x] = 70;
        }
      }
    }

    // /* boolean */fallflag = false;
    boolean loopflag = true;
    for (int x = 0; x < 6; x++) {
      for (int y = 1; y <= 11; y++) {
        if (cells[y][x] == 70 && cells_type[y][x] == 0 && cells[y + 1][x] != 70 && cells_type[y + 1][x] != 0) {
          fallflag = true;
          loopflag = false;
          break;
        } else if (x == 5 && y == 11 && loopflag){
          // fallflag = false;
        }
      }
      if (!loopflag) {
        break;
      }
    }

    // for (int x = 0; x < 6; x++) {
    //   for (int y = 1; y <= 12; y++) {
    //     // 揃ったパネルから上を連鎖可能性リストに
    //     if (cells[y][x] == 70) {
    //       fallflag = true;
    //     }
    //     // if(!ccf){
    //     //   ccf=true;
    //     //   chains+=1;
    //     // }
    //     if (fallflag) {
    //       cells_chain[y][x] = chains + 1;
    //     }
    //   }
    // }

    for (int y = 1; y < 12; y++) {
      for (int x = 0; x < 6; x++) {
        // 落下 
        // 1つ上で点滅しているとき、点滅してるパネルは落下しない
        if (cells[y][x] == 70) {
          if (!(0 < cells[y + 1][x] && cells[y + 1][x] < 70) && frameCount % FALL_SPEED_PER_FR == 0) {
            int tmp_cell;
            tmp_cell = cells[y][x];
            cells[y][x] = cells[y + 1][x];
            cells[y + 1][x] = tmp_cell;
            int tmp_cell_type;
            tmp_cell_type = cells_type[y][x];
            cells_type[y][x] = cells_type[y + 1][x];
            cells_type[y + 1][x] = tmp_cell_type;
            PImage tmp_cell_img;
            tmp_cell_img = cells_img[y][x];
            cells_img[y][x] = cells_img[y + 1][x];
            cells_img[y + 1][x] = tmp_cell_img;
            if ((cells[y - 1][x] <= 60 || cells[y - 1][x] == 80) && cells_img[y][x] != panels[0] && (cells[y][x] == 70)) {
              cells[y][x] = 80; // 落下し終わった
            }
            // fallflag = true;
            tmp_cell_img = null;
          }
        }
      }
    }
    // 落下し終わったか
    for (int y = 1; y < 12; y++) {
      for (int x = 0; x < 6; x++) {
      }
    }
    // 横で揃っているか
    boolean judge = true; // 2枚以上のパネルが同時に落下するときに判定しないようにする
    for (int y = 12; y > 0; y--) {
      for (int x = 0; x < 4; x++) {
        if (cells_type[y][x] != 0 && cells_img[y][x] == cells_img[y][x + 1] && (cells[y][x] <= 1 || cells[y][x] == 80) && (cells[y][x + 1] <= 1 || cells[y][x + 1] == 80) && frameCount % FALL_SPEED_PER_FR == 0) {
          if (cells_img[y][x] == cells_img[y][x + 2] && (cells[y][x + 2] <= 1 || cells[y][x + 2] == 80) && frameCount % FALL_SPEED_PER_FR == 0) {
            for (int yy = y; yy > 0; yy--) {
              if ((cells[yy][x] == 70 || cells[yy][x + 1] == 70 || cells[yy][x + 2] == 70)) {
                judge = false;
                break;
              }
            }
            if (judge) {
              cells[y][x] = 1;
              cells[y][x + 1] = 1;
              cells[y][x + 2] = 1;
              if (!chaincombo && fallflag /*&& !manualflag*/){
                println("横連鎖");
                chains += 1;
                chainkeeper = true;
                chaincombo = true;
              }
              manualflag = false;
              cells_chain[y][x] = chains;
              cells_chain[y][x + 1] = chains;
              cells_chain[y][x + 2] = chains;
              for (int yy = y; yy <= 12; yy++) {
                cells_chain[yy][x] = chains;
                cells_chain[yy][x + 1] = chains;
                cells_chain[yy][x + 2] = chains;                
              }
            }
          }
        }
      }
    }
    // 縦で揃っているか
    for (int x = 0; x < 6; x++) {
      for (int y = 12; y > 2; y--) {
        if (cells_type[y][x] != 0 && cells_img[y][x] == cells_img[y - 1][x] && (cells[y][x] <= 1 || cells[y][x] == 80) && (cells[y - 1][x] <= 1 || cells[y - 1][x] == 80) && frameCount % FALL_SPEED_PER_FR == 0) {
          if (cells_img[y][x] == cells_img[y - 2][x] && (cells[y - 2][x] <= 1 || cells[y - 2][x] == 80 && frameCount % FALL_SPEED_PER_FR == 0)) {
            cells[y][x] = 1;
            cells[y - 1][x] = 1;
            cells[y - 2][x] = 1;
            if (!chaincombo && fallflag /*&& !manualflag*/){
              println("縦連鎖");
              chains += 1;
              chainkeeper = true;
              chaincombo = true;
            }
            manualflag = false;
            cells_chain[y][x] = chains;
            cells_chain[y - 1][x] = chains;
            cells_chain[y - 2][x] = chains;
            for (int yy = y; yy <= 12; yy++) {
              cells_chain[yy][x] = chains;
              cells_chain[yy][x] = chains;
              cells_chain[yy][x] = chains;                
            }
          }
        }
      }
    }
    
    loopflag = true;
    for (int x = 0; x < 6; x++) {
      for (int y = 1; y <= 11; y++) {
        if (cells[y][x] == 70 && cells_type[y][x] == 0 && cells[y + 1][x] != 70 && cells_type[y + 1][x] != 0) {
          fallflag = true;
          loopflag = false;
          break;
        } else if (x == 5 && y == 11 && loopflag){
          fallflag = false;
        }
      }
      if (!loopflag) {
        break;
      }
    }

    int combo = 0;
    ccf = false;
    loopflag = true;
    for (int y = 12; y > 0; y--) {
      for (int x = 0; x < 6; x++) {
        // 揃ったパネルの数を数える
        if (cells[y][x] == 1) {
          combo += 1;
          ep += 1;
          // せり上げ関連の処理
          if (speedLv < 15) {
            if (ep > 15) {
              ep = 0;
              speedLv += 1;
            }
          } else if (speedLv < 20) {
            if (ep > speedLv) {
              ep = 0;
              speedLv += 1;
            }
          } else {
            ep = 0;
          }

          // if (!manualflag) {
          // if (ccf) {
          //   cells_chain[y][x] = chains;
          // } else {
          //   cells_chain[y][x] = chains + 1;
          //   chains = cells_chain[y][x];
          //   ccf = true;
          // }
          // }
        }
        // 揃ったときの時間猶予　点滅エフェクト向け
        if (cells[y][x] > 0 && cells[y][x] < FRAME_RATE + 1) {
          cells[y][x] += 1;
          if ((cells[y][x] - 1) % 5 == 0) {
            cells_img[y][x] = panels[cells_type[y][x]];
            // println("5の倍数");
          }
          if ((cells[y][x] - 1) % 10 == 0) {
            cells_img[y][x] = panels[0];
            // println("10の倍数");
          }
          if ((cells[y][x] - 1) % FRAME_RATE == 0) {
            cells_img[y][x] = panels[0];
            // println("60の倍数");
            cells[y][x] = 70;
          }
          isDeleting = true;
          loopflag = false;
        } else {
          if (x == 5 && y == 1 && loopflag) {
            isDeleting = false;
          }
        }
      }
    }
    if (combo == 0) {
      // 消えるパネルがないとき、
      // boolean isDeleting = false;
      loopflag = true;
      for (int y = 1; y <= 12; y++) {
        for (int x = 0; x < 6; x++) {
          // パネルが消えてる途中か落下中か
          if ((0 < cells[y][x] && cells[y][x] < 70)/* || cells[y][x] == 80*/) {
            isDeleting = true;
            loopflag = false;
            // println("deleting: ("+x+", "+y+")");
            break;
          } //else {
            if (x == 5 && y == 12 && loopflag) {
        if (!fallflag && !isDeleting /*&& chainkeeper && chains < 2*/){
          // println("途切れる"+ chains);
          chains = 1;
          chainkeeper = false;
        }
              // chains = 0;
              isDeleting = false;
            //}
          }
          // if (chains>0) {
          // }
          // if (cells[y][x]==80) {
          //   cells[y][x]=0;
          // }
          // if(cells[y][x]==70 && cells_type[y][x]==0){
          //   cells[y][x]=0;
          // }
        }
        if (isDeleting) {
          break;
        }
      }
    } else {
      // chains+=1;
      for (int y = 1; y < 12; y++) {
        for (int x = 0; x < 6; x++) {
          // 連鎖チェック
          // if (chains>0) {
          // }
          if (cells[y][x] == 80) {
            cells[y][x] = 0;
          }
          // if(cells[y][x]==70 && cells_type[y][x]==0){
          //   cells[y][x]=0;
          // }
        }
      }
    }

    // 全消し判定
    fieldpanels = 12 * 6;
    for (int y = 12; y > 0; y--) {
      for (int x = 0; x < 6; x++) {
        if (cells_img[y][x] == panels[0] && cells_type[y][x] != 0 && !(0 < cells[y][x] && cells[y][x] < 70)) {
          cells_type[y][x] = 0;
        }
        if (cells_img[y][x] == panels[0] && cells_type[y][x] == 0 && cells[y][x] == 70) {
          fieldpanels -= 1;
        }

        // if (cells_img[y][x]==panels[0]&&cells_type[y][x]!=0&&!(0<cells[y][x]&&cells[y][x]<70)) {
        //   cells_type[y][x]=0;
        // }
        // if (cells_img[y][x]!=panels[0]&&cells_type[y][x]!=0&&cells[y][x]<70) {
        //   fieldpanels+=1;
        // }
        // if (chains==0&&(true)) {
        //   cells_chain[y][x]=0;
        // }
      }
    }
    if (fieldpanels == 0 && !zerobonus && !gameover) {
      zerobonus = true;
      score += 3000;
      if (highscore < score) {
        highscore = score;
      }
    } else if (zerobonus && !gameover) {
      fill(60, 179, 113);
      textSize(90);
      text(PERFECT_TEXT, MARGIN_X, MARGIN_Y + PANEL_SIZE * 3);
    }
    // 後処理
    for (int y = 12; y > 0; y--) {
      for (int x = 0; x < 6; x++) {
        if (cells_img[y][x] == panels[0] && cells_type[y][x] != 0 && !(0 < cells[y][x] && cells[y][x] < 70)) {
          cells_type[y][x] = 0;
        }
        if (cells_img[y][x] != panels[0]) {
          fieldpanels += 1;
        }
        // if (chains==0&&(true)) {
        //   cells_chain[y][x]=0;
        // }
      }
    }
    if (combo != 0) {
      score += calculateScore(chains, combo);
      if (highscore < score) {
        highscore = score;
      }
      if (cooldown < 2 * FRAME_RATE) {
        cooldown = 2 * FRAME_RATE;
      }
      if (combo > 3) {
        dispTimer = new Timer(timer, FRAME_RATE, 0, 0, 4);
        dispTimer.start();
        dispFlag = true;
        ischain = chains >= 2 && combo < 15 ? true : false;
        dispNum = chains >= 2 && combo < 15 ? chains : combo;
        cooldown = 5 * FRAME_RATE;
      } else if (chains >= 2){
        dispTimer = new Timer(timer, FRAME_RATE, 0, 0, 4);
        dispTimer.start();
        dispFlag = true;
        ischain = chains >= 2 && combo < 15 ? true : false;
        dispNum = chains >= 2 && combo < 15 ? chains : combo;        
      }
      println(chains + "連鎖 " + combo + "同時消し");
    }
  }

  void keyPressedState() {
    if (key == CODED) {
      // カーソルを動かす(UP, DOWN, LEFT, RIGHT)
      if (keyCode == UP) {
        if (cy >= MARGIN_Y) {
          cy -= PANEL_SIZE;
        }
      } else if (keyCode == DOWN) {
        if (cy <= MARGIN_Y + PANEL_SIZE * 10) {
          cy += PANEL_SIZE;
        }
      } else if (keyCode == LEFT) {
        if (cx >= MARGIN_X) {
          cx -= PANEL_SIZE;
        }
      } else if (keyCode == RIGHT) {
        if (cx <= MARGIN_X + PANEL_SIZE * 3) {
          cx += PANEL_SIZE;
        }
      } else if (keyCode == CONTROL) {
        if (!pcf && startflag) {
          seriage();
          pcf = true;
        }
      }
    } else if (key == ENTER || key == ' ') {
      // パネルの交換
      if (startflag && !pcf && !gameover) {
        if ((cells[getCursorY()][getCursorX()] == 0 || cells[getCursorY()][getCursorX()] == 70 || cells[getCursorY()][getCursorX()] == 80) && (cells[getCursorY()][getCursorX() + 1] == 0 || cells[getCursorY()][getCursorX() + 1] == 70 || cells[getCursorY()][getCursorX() + 1] == 80)) {
          PImage tmp_img;
          tmp_img = cells_img[getCursorY()][getCursorX()];
          cells_img[getCursorY()][getCursorX()] = cells_img[getCursorY()][getCursorX() + 1];
          cells_img[getCursorY()][getCursorX() + 1] = tmp_img;
          int tmp_panel;
          tmp_panel = cells_type[getCursorY()][getCursorX()];
          cells_type[getCursorY()][getCursorX()] = cells_type[getCursorY()][getCursorX() + 1];
          cells_type[getCursorY()][getCursorX() + 1] = tmp_panel;
          cells_img[getCursorY()][getCursorX() + 1] = tmp_img;
          int tmp_cell;
          tmp_cell = cells[getCursorY()][getCursorX()];
          cells[getCursorY()][getCursorX()] = cells[getCursorY()][getCursorX() + 1];
          cells[getCursorY()][getCursorX() + 1] = tmp_cell;

          tmp_img = null;

          manualflag = true;
          pcf = true;
        }
      }
    } else if (key == '2' && DEBUG) {
      // 4秒経過したら消える
      // 連鎖用表示設定
      fill(0, 166, 212);
      textSize(100);
      text(int(random(3, 15)), MARGIN_X + PANEL_SIZE * 7, MARGIN_Y + PANEL_SIZE);

      // 同時消し用表示設定
      fill(255, 125, 0);
      textSize(100);
      text(int(random(3, 15)), MARGIN_X + PANEL_SIZE * 7, MARGIN_Y + PANEL_SIZE);
    } else if (key == 'r') {
      println("Reset");
      try {
        gameTimer.stop();
        gameTimer.reset();
      }
      catch (Exception ex) {
      }
      initialize();
    } else if (key == 's') {
      saveFrame("Panel_de_Pon.png");
    }
  }

  void keyReleasedState() {
    if (key == CODED) {
      if (keyCode == CONTROL) {
        pcf = false;
      }
    } else if (key == ENTER || key == ' ') {
      pcf = false;
    }
  }


  void placePanel() {
    // パネル：左上 = (0, 12)
    for (int y = 12; y >= 0; y--) {
      for (int x = 0; x < 6; x++) {
        image(cells_img[y][x], MARGIN_X + PANEL_SIZE * x, MARGIN_Y + PANEL_SIZE * (12 - y), PANEL_SIZE, PANEL_SIZE);
      }
    }
  }

  void seriage() {
    // パネルのせり上げ
    generatePanel();
    seriagebar = 0;
    cooldown = 0;
    if (/*getMaxPanelHeight()!=12&&*/!gameover) {
      if (cy >= MARGIN_Y) {
        cy -= PANEL_SIZE;
      }
      // manualflag = true;
    }
  }

  void generatePanel() {
    zerobonus = false;
    boolean erasing = false;
    for (int y = 12; y > 0; y--) {
      for (int x = 0; x < 6; x++) {
        if (0 < cells[y][x] && cells[y][x] < 70) {
          erasing = true;
        }
      }
    }
    for (int x = 0; x < 6; x++) {
      if (getMaxPanelHeight() == 12 && !erasing) {
        gameover = true;
        PrintWriter output = createWriter(String.valueOf(mode));
        output.println(highscore);
        output.flush();
        output.close();
        println("Game Over");
      }
    }
    if (getMaxPanelHeight() != 12 && !gameover) {
      int[] new_panel;
      new_panel = new int[6];
      for (int y = 12; y > 0; y--) {
        for (int x = 0; x < 6; x++) {
          // パネルの初期化 それぞれに空のパネルを配置
          cells_img[y][x] = cells_img[y - 1][x];
          cells_type[y][x] = cells_type[y - 1][x];
          cells[y][x] = cells[y - 1][x];
          cells_chain[y][x] = cells_chain[y - 1][x];
        }
      }
      for (int x = 0; x < 6; x++) {
        new_panel[x] = (int)random(5) + 1;
        cells_img[0][x] = panels[new_panel[x]];
        cells_type[0][x] = new_panel[x];
        cells[0][x] = 0;
        // cells_chain[0][x] = 0;
      }
    }
  }

  int getMaxPanelHeight() {
    int c = 0;
    for (int x = 0; x <= 5; x++) {
      for (int y = 1; y <= 12; y++) {
        if ((cells[y][x] < 70 || cells[y][x] == 80) && c < y) {
          c = y;
        }
      }
    }
    return c;
  }

  int calculateScore(int chains, int combo) {
    int rtn = 0;
    // 連鎖分だけ加算
    switch (chains) {
    case 0:
      break;
    case 1:
      break;
    case 2:
      rtn += 50;
      break;
    case 3:
      rtn += 80;
      break;
    case 4:
      rtn += 150;
      break;
    case 5:
      rtn += 300;
      break;
    case 6:
      rtn += 400;
      break;
    case 7:
      rtn += 500;
      break;
    case 8:
      rtn += 700;
      break;
    case 9:
      rtn += 900;
      break;
    case 10:
      rtn += 1100;
      break;
    case 11:
      rtn += 1300;
      break;
    case 12:
      rtn += 1500;
      break;
    default:
      rtn += 1800;
      break;
    }

    // 同時消しの分だけ加算
    if (combo == 3) {
      rtn += 30;
    } else {
      rtn += 5 * (combo - 3) * (combo + 24);// -10*combo+10*combo;
    }

    return rtn;
  }

  int getCursorX() {
    return cx / PANEL_SIZE - 1;
  }

  int getCursorY() {
    return (height - cy) / PANEL_SIZE;
  }

  void dispose() {
    // PrintWriter output=createWriter("endless");
    PrintWriter output = createWriter(String.valueOf(mode));
    output.println(highscore);
    output.flush();
    output.close();
  }

  State decideState() {
    switch (gamelv) {
    case IDLE:
      gameTimer = null;
      initialize();

      state = new MenuExtendState();
      return state;

    default:
      break;
    }
    return this;
  }
}
