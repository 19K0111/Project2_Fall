State state;
GAMEMODE mode;
GAMELEVEL gamelv;

final int PANEL_SIZE = 50;
final int MARGIN_X = 80;
final int MARGIN_Y = 275;
final int FRAME_RATE=60;
final boolean DEBUG =true;
int FALL_SPEED_PER_FR=3; // 落下速度を決める
final String PERFECT_TEXT="Perfect";
final int TA_HOUR = 0;
final int TA_MINUTE = 2;
final int TA_SECOND = 0;
PImage cursor;
int cx;
int cy;

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
int[][] cells_chain = new int[13][6]; // 連鎖数を格納

boolean pcf;// Panel Changed Flag
boolean up, down, left, right;
boolean ccf=false; // chains changed flag 連鎖が増えたときtrue
boolean manualflag; // 手動でパネルを動かしたらtrue(連鎖の判定で用いる)
boolean startflag=false;
boolean gameover;
boolean zerobonus;
boolean menukey;

int timer=0;
int chains=0; // 連鎖
int score=0;
int highscore;
int fieldpanels=0;

Timer gameTimer;
int h;
int m;
int s;
int millsec;

Timer dispTimer;
boolean dispFlag;
int dispNum;

SE se;
int ready_cnt;

int speedLv=1;

int arrtime; // 揃ってから消すまでインクリメント


void setup() {
  size(600, 900);
  mode=GAMEMODE.IDLE;
  gamelv=GAMELEVEL.IDLE;

  initialize();
  state=new MenuState();
}

void draw() {
  state=state.doState();
}

void mousePressed() {
  state.mousePressedState();
}

void keyPressed() {
  state.keyPressedState();
}

void keyReleased() {
  state.keyReleasedState();
}

void initialize() {
  // background(230);
  // background(#11cf55);
  frameRate(FRAME_RATE);
  strokeWeight(1);
  PFont font;
  font = loadFont("MeiryoUI-48.vlw");
  cursor = loadImage("cursor.png");
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
  cx = MARGIN_X - 5 + PANEL_SIZE * 2;
  cy = MARGIN_Y - 5 + PANEL_SIZE * 6;
  timer=0;
  score=0;
  h=0;
  m=0;
  s=0;
  frameCount=0;
  startflag=false;
  gameover=false;
  zerobonus=false;
  dispFlag=false;
  se=new SE();
  ready_cnt=3;
  speedLv=1;
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
      cells[y][x]=0;
    }
  }
  for (int y = 12; y >= 0; y--) {
    for (int x = 0; x < 6; x++) {
      if (cells_img[y][x]==panels[0]) {
        cells[y][x]=70;
      }
    }
  }
}
