class Timer {
    // millis()はプレイ中に時刻を変えるとバグ
  private int h;
  private int m;
  private int s;
  private int ms;
  private int sf; // 開始時のフレーム位置
  private int fps;
  private boolean countdown; 

  private boolean flag;

  public int ending_ms;
  public int current;
  Timer(int currentframe, int framerate) {
    this.h=0;
    this.m=0;
    this.s=0;
    this.ms=0;
    this.sf=currentframe;
    this.fps=framerate;
    this.countdown=false;
    this.ending_ms=-1;
    // this.current=0;
  }
  Timer(int currentframe, int framerate, int hour, int minute, int second) {
    this.h=hour;
    this.m=minute;
    this.s=second;
    this.ms=0;
    this.sf=currentframe;
    this.fps=framerate;
    this.countdown=true;
    this.ending_ms=frameCount-currentframe+1000*(second+60*minute+3600*hour);
    // this.current=0;
  }

  public void start() {
    flag=true;
  }

  public void stop() {
    flag=false;
  }

  public String toString() {
    // int cur_h=0;
    // int cur_m=0;
    // int cur_s=0;
    // int cur_ms=0;
    if (flag) {
      if (countdown) {
        if (ending_ms-(frameCount-sf)*1000/fps>=0) {
          h=((ending_ms-(frameCount-sf)*1000/fps)/3600000);// hour()-h;
          m=((ending_ms-(frameCount-sf)*1000/fps)/60000)%60;// minute()-m;
          s=((ending_ms-(frameCount-sf)*1000/fps)/1000)%60;// second()-s;
          ms=((ending_ms-(frameCount-sf)*1000/fps))%1000;
        } else {
          h=0;
          m=0;
          s=0;
          ms=0;
        }
      } else {
        h=(((frameCount-sf)*1000/fps-sf)/3600000);// hour()-h;
        m=(((frameCount-sf)*1000/fps-sf)/60000)%60;// minute()-m;
        s=(((frameCount-sf)*1000/fps-sf)/1000)%60;// second()-s;
        ms=(((frameCount-sf)*1000/fps-sf))%1000;
      }
    }else{
        
    }
    return h+":"+String.format("%02d", m)+"\'"+String.format("%02d", s)+"\'\'"+String.format("%03d", ms);
  }
}
