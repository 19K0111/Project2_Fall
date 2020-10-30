/// TODO:
/// 落下の際のバグ　2行で点滅しているパネル(3個と3個など)　に落下する
/// 新しいパネル生成　よりよい乱数 -> 3つ連続で同じパネルが出現することもある。
/// せり上げボタンの配置を決める。
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

final int PANEL_SIZE = 50;
final int MARGIN_X = 80;
final int MARGIN_Y = 275;
final int FRAME_RATE=60;
final boolean DEBUG =true;
PImage cursol;
int cx = MARGIN_X - 5 + PANEL_SIZE * 2;
int cy = MARGIN_Y - 5 + PANEL_SIZE * 6;

PImage[] panels = new PImage[6];
// PImage panel1;
// PImage panel2;
// PImage panel3;
// PImage panel4;
// PImage panel5;

PImage[][] cells_img = new PImage[13][6];
int[][] cells_type=new int[13][6]; // パネルの情報
// cells_type == 0 : 
// cells_type == 1 : ♡
// cells_type == 2 : ○
// cells_type == 3 : △
// cells_type == 4 : ☆
// cells_type == 5 : ♢
int[][] cells = new int[13][6];
// cells == 0      : 通常
// cells == 1      : 揃った
// cells == 2 ~ 60 : 消している
// cells == 70     : 消えた
// cells == 80     : 落下
// cells == 90     : 落下し終わる

boolean pcf;// Panel Changed Flag
boolean up, down, left, right;

int timer=0;

int arrtime; // 揃ってから消すまでインクリメント

void setup() {
  size(600, 900);
  background(230);
  // background(#11cf55);
  frameRate(30);
  strokeWeight(1);
  PFont font;
  font = loadFont("MeiryoUI-48.vlw");
  cursol = loadImage("cursol.png");
  panels[0] = loadImage("panel0.png");
  panels[1] = loadImage("panel1.png");
  panels[2] = loadImage("panel2.png");
  panels[3] = loadImage("panel3.png");
  panels[4] = loadImage("panel4.png");
  panels[5] = loadImage("panel5.png");
  // panel1=loadImage("panel1.png");
  // panel2=loadImage("panel2.png");
  // panel3=loadImage("panel3.png");
  // panel4=loadImage("panel4.png");
  // panel5=loadImage("panel5.png");
  for (int y = 12; y >= 0; y--) {
    for (int x = 0; x < 6; x++) {
      // パネルの初期化 それぞれに空のパネルを配置
      cells_img[y][x] = panels[0];
      cells_type[y][x]=0;
    }
  }
  for (int y = 5; y >= 0; y--) {
    for (int x = 0; x < 6; x++) {
      cells_img[y][x] = panels[(x + y) % 5 + 1];
      cells_type[y][x]=(x + y) % 5 + 1;
    }
  }
}

void draw() {
  stage();
  checkPanel();
}

void mousePressed() {
  if (DEBUG) {
    if (mouseX>MARGIN_X&&mouseX<MARGIN_X+PANEL_SIZE*6&&mouseY>MARGIN_Y&&mouseY<MARGIN_Y+PANEL_SIZE*13) {
      int panelX, panelY;
      panelX=(mouseX-MARGIN_X)/PANEL_SIZE;
      panelY=12-(mouseY-MARGIN_Y)/PANEL_SIZE;
      println("("+panelX+", "+panelY+")");
      // println("cells_img["+panelY+"]["+panelX+"] = "+cells_img[panelY][panelX]);
      println("cells_type["+panelY+"]["+panelX+"] = "+cells_type[panelY][panelX]);
      println("cells["+panelY+"]["+panelX+"] = "+cells[panelY][panelX]+"\n");
    }
  }
}

void stage() {
  background(230);
  fill(255);
  for (int j = 0; j < 12; j++) {
    for (int i = 0; i < 6; i++) {
      // rect(MARGIN_X + PANEL_SIZE * i, MARGIN_Y + PANEL_SIZE * j, PANEL_SIZE, PANEL_SIZE);
    }
  }
  //   println("("+mouseX+", "+mouseY+")");
  txt();
  placePanel();
  fill(0, 0, 0, 127);
  rect(MARGIN_X, MARGIN_Y+PANEL_SIZE*12, PANEL_SIZE*6, PANEL_SIZE);
  image(cursol, cx, cy, PANEL_SIZE * 2 * 1.12, PANEL_SIZE * 1.22);
}

void txt() {
  fill(#ff55dd);
  textSize(48);
  text("TIME: 0:00'00''00\nHIGH SCORE: 0\n  SCORE: 0", 80, 80);
  //   println("("+mouseX+", "+mouseY+")");
}

void checkPanel() {
  for (int y=12; y>0; y--) {
    for (int x=0; x<4; x++) {
      if (cells_type[y][x]!=0&&cells_img[y][x]==cells_img[y][x+1] && (cells[y][x]<=1||cells[y][x]==80)&& (cells[y][x+1]<=1||cells[y][x+1]==80)) {
        if (cells_img[y][x]==cells_img[y][x+2]&&(cells[y][x+2]<=1||cells[y][x+2]==80)) {
          cells[y][x]=1;
          cells[y][x+1]=1;
          cells[y][x+2]=1;
        }
      }
    }
  }
  for (int x=0; x<6; x++) {
    for (int y=12; y>2; y--) {
      if (cells_type[y][x]!=0&&cells_img[y][x]==cells_img[y-1][x]&& (cells[y][x]<=1||cells[y][x]==80)&& (cells[y-1][x]<=1||cells[y-1][x]==80)) {
        if (cells_img[y][x]==cells_img[y-2][x]&& (cells[y-2][x]<=1||cells[y-2][x]==80)) {
          cells[y][x]=1;
          cells[y-1][x]=1;
          cells[y-2][x]=1;
        }
      }
    }
  }

  int dp=0;
  for (int y=12; y>0; y--) {
    for (int x=0; x<6; x++) {
      // 揃ったパネルの数を数える
      if (cells[y][x]==1) {
        dp+=1;
      }
      // 揃ったときの時間猶予　点滅エフェクト向け
      if (cells[y][x]>0&&cells[y][x]<FRAME_RATE+1) {
        cells[y][x]+=1;
        if ((cells[y][x]-1)%5==0) {
          cells_img[y][x]=panels[cells_type[y][x]];
          // println("5の倍数");
        }
        if ((cells[y][x]-1)%10==0) {
          cells_img[y][x]=panels[0];
          // println("10の倍数");
        }
        if ((cells[y][x]-1)%FRAME_RATE==0) {
          cells_img[y][x]=panels[0];
          // println("60の倍数");
          cells[y][x]=70;
        }
      }
    }
  }
  if (dp!=0) {
    println(dp);
  }
  for (int y=1; y<12; y++) {
    for (int x=0; x<6; x++) {
      // 落下 
      // 1つ上で点滅しているとき、点滅してるパネルは落下しない
      if (cells[y][x]==70) {
        if (!(0<cells[y+1][x]&&cells[y+1][x]<70)) {
          int tmp_cell;
          tmp_cell=cells[y][x];
          // cells[y][x]=cells[y+1][x];
          cells[y+1][x]=tmp_cell;
          int tmp_cell_type;
          tmp_cell_type=cells_type[y][x];
          cells_type[y][x]=cells_type[y+1][x];
          cells_type[y+1][x]=tmp_cell_type;
          PImage tmp_cell_img;
          tmp_cell_img=cells_img[y][x];
          cells_img[y][x]=cells_img[y+1][x];
          cells_img[y+1][x]=tmp_cell_img;
          if ((cells[y-1][x]<=60||cells[y-1][x]==80) && cells_img[y][x]!=panels[0]&&(cells[y][x]==70)) {
            cells[y][x]=80; // 落下し終わった
          }
        }
      }
    }
  }
}

void keyPressed() {
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
    } else if (keyCode==CONTROL) {
      if (!pcf) {
        // パネルのせり上げ
        generatePanel();
        pcf=true;
      }
    }
  } else if (key == ENTER || key == ' ') {
    // パネルの交換
    if (!pcf) {
      if ((cells[getCursolY()][getCursolX()]==0||cells[getCursolY()][getCursolX()]==70||cells[getCursolY()][getCursolX()]==80)&&(cells[getCursolY()][getCursolX()+1]==0||cells[getCursolY()][getCursolX()+1]==70||cells[getCursolY()][getCursolX()+1]==80)) {
        PImage tmp_img;
        tmp_img = cells_img[getCursolY()][getCursolX()];
        cells_img[getCursolY()][getCursolX()] = cells_img[getCursolY()][getCursolX() + 1];
        cells_img[getCursolY()][getCursolX() + 1] = tmp_img;
        int tmp_panel;
        tmp_panel = cells_type[getCursolY()][getCursolX()];
        cells_type[getCursolY()][getCursolX()] = cells_type[getCursolY()][getCursolX() + 1];
        cells_type[getCursolY()][getCursolX() + 1] = tmp_panel;
        cells_img[getCursolY()][getCursolX() + 1] = tmp_img;
        int tmp_cell;
        tmp_cell = cells[getCursolY()][getCursolX()];
        cells[getCursolY()][getCursolX()] = cells[getCursolY()][getCursolX() + 1];
        cells[getCursolY()][getCursolX() + 1] = tmp_cell;

        pcf = true;
      }
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode==CONTROL) {
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

void generatePanel() {
  int[] new_panel;
  new_panel= new int[6];
  for (int y = 12; y > 0; y--) {
    for (int x = 0; x < 6; x++) {
      // パネルの初期化 それぞれに空のパネルを配置
      cells_img[y][x] = cells_img[y-1][x];
      cells_type[y][x]=cells_type[y-1][x];
      cells[y][x]=cells[y-1][x];
    }
  }
  for (int x=0; x<6; x++) {
    new_panel[x]=(int)random(5)+1;
    cells_img[0][x] =panels[new_panel[x]];
    cells_type[0][x]=new_panel[x];
    cells[0][x]=0;
  }
}

int getCursolX() {
  return cx / PANEL_SIZE - 1;
}

int getCursolY() {
  return (height - cy) / PANEL_SIZE;
}
