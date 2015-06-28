import ddf.minim.*;  //minimライブラリのインポート

int MARGIN = 20;
Clock myClock = new Clock();
Counter myCount = new Counter(100,60);  //メトロノームの初期スピード、ボタンの基準からの距離を初期設定
Minim[] minim = new Minim[2];  //Minim型変数であるminimの宣言
Minim[] kisei = new Minim[10];
AudioPlayer[] player = new AudioPlayer[2];  //サウンドデータ格納用の変数 
AudioPlayer[] kiseip = new AudioPlayer[10];
int bx=0,by=0; //クリックボックスの位置
boolean vf = false;
int tpos = 30;//三角(ボタン)の中心配置
int voicemode = 0;  //誰の声？
float mcount = 0;  //メトロノーム用カウンタ
PImage seno; //おしゃしん
 
void setup() {
  size(300,600);
  stroke(255);
  smooth();
  frameRate(30);
  minim[0] = new Minim(this);  //初期化
  minim[1] = new Minim(this);  //初期化
  for(int i=0 ;i<10;i++){kisei[i] = new Minim(this);}
  player[0] = minim[0].loadFile("pityun.mp3");
  player[1] = minim[1].loadFile("patin.mp3");
  kiseip[0] = kisei[0].loadFile("kiseiSL.mp3");
  kiseip[1] = kisei[1].loadFile("kiseiSH.mp3");
  kiseip[2] = kisei[2].loadFile("kiseiSa.mp3");
  kiseip[3] = kisei[3].loadFile("kiseiKING.mp3");
  seno = loadImage("seno.jpg");
}
 
void draw() {
  background(0);
  myClock.getTime();
  
  pushMatrix();
  bx = width/2-60;
  by = height-120;
  translate(bx,by);
  myCount.draw(screenX(0,0),screenY(0,0));
  popMatrix();
  
  myClock.draw();
  
  //ぽーん
  if (myClock.bm != myClock.m && myClock.m%1 == 0 ){
    myClock.bm = myClock.m;
    //voice(0);
  }
  
  //メトロノーム
  myCount.metro();
  
}
 
void voice(int mode) {
  //PC
   player[mode].rewind();
   player[mode].play();  //再生
} 
 
void Kvoice(int mode) {
  //PC
   kiseip[mode].rewind();
   kiseip[mode].play();  //再生
} 

 
void stop()
{
  player[0].close();  //サウンドデータを終了
  minim[0].stop();
  player[1].close();  //サウンドデータを終了
  minim[1].stop();
  for(int i=0;i<10;i++){
    kiseip[i].close();
    kisei[i].stop();
  }
  super.stop();
} 

void mouseClicked() {
  int mode = myCount.check(mouseX,mouseY); //mode = 1 → 上矢印が押された、2→下矢印が押された
  if (mode == 1){
    myCount.i++;
  } 
  else if (mode == 2){
    myCount.i--;
  }
 //メトロノームボタン 
 else if (mode == 3){
   myCount.mflag = !myCount.mflag;
   println(myCount.mflag);
 }  
 //呼び出しボタン
 else if (mode == 4){
   println(frameRate);
   myCount.voiceset();
   Kvoice(myCount.vmode);
 }
}

class Counter {
  float tpos; //基準点から三角の中心までの距離
  float gposx,gposy; //グローバルな座標
  float utx,uty,dtx,dty; //三角形それぞれの中心座標
  float bmx,bmy,bcx,bcy;  //それぞれのボタンの基準座標(左上)
  boolean mflag = false,bmflag; //メトロノームのon/offフラグ
  int i,vmode=0;  //誰の声?
  
  Counter(int iin, int ipos){
    i = iin;
    tpos = ipos;
    bmflag = mflag;
  }
  
  void draw(float dposx, float dposy){
    gposx = dposx;
    gposy = dposy;
    pushMatrix();
    translate(0,tpos);
    dtx = screenX(0,0);dty = screenY(0,0); //三角のグローバルな中心座標を取得
    triangle(-20,-20,20,-20,0,20);
    translate(0,-tpos*2);
    utx = screenX(0,0);uty = screenY(0,0);//三角のグローバルな中心座標を取得
    triangle(-20,20,20,20,0,-20);
    translate(-8,78);
    textSize(59);
    textAlign(CENTER);
    text("♪" + i,0,0);
    popMatrix();
    
    pushMatrix();
    translate(80,-30);
    fill(int(mflag)*128,0,50);
    bmx = screenX(0,0);bmy = screenY(0,0);
    rect(0,0,60,60);
    fill(64,128,256);
    text("♪",30,50);
    fill(0,128,0);
    bcx = screenX(70,5);bcy = screenY(70,5);
    rect(70,5,50,50);
    pushMatrix();
    translate(70,5);
    scale(0.074,0.083);
    image(seno, 0, 0);
    popMatrix();
    noFill();
    popMatrix();
  }
  
  int check(float mposx,float mposy){
    int a = 0;
    if( (utx - mposx)*(utx - mposx) + (uty - mposy)*(uty - mposy) < 19*19 ){a = 1;}
    else if( (dtx - mposx)*(dtx - mposx) + (dty - mposy)*(dty - mposy) < 19*19){a = 2;}
    else if (mposx - bmx > 0 && mposx - bmx < 60 && mposy - bmy > 0 && mposy - bmy < 60){a = 3;}
    else if (mposx - bcx > 0 && mposx - bcx < 60 && mposy - bcy > 0 && mposy - bcy < 60){a = 4;}
    
    return(a); 
  }
  
  void metro(){
   if(mflag == true){
    if(bmflag != mflag){mcount = 0; bmflag = mflag;}
    mcount += myCount.i / (60*frameRate);
    if(mcount >= 1){
      mcount -= 1;
      voice(1);
    }
   }
  }
  
  void voiceset(){
    vmode = int(random(4));
    println(vmode);
  }
  
}
 
 
 
class Clock {
  float s, m, h,bs,bm,bh;
  Clock(){
    bs = second();
    bm = minute();
    bh = hour()%12;
  }
 
  void getTime(){
    s = second();
    m = minute() + (s/60.0);
    h = hour()%12 + (m/60.0);
  }
 
  void draw(){
    translate(width/2, height/2-60);
    rotate(radians(180));
    pushMatrix();
    fill(128);
    noStroke();
    //文字盤
    for(int i=0; i<60; i++){
      rotate(radians(6));
      ellipse(width/2-MARGIN,0,3,3);
    }
    for(int i=0; i<12; i++){
      rotate(radians(30));
      ellipse(width/2-MARGIN,0,10,10);
    }
    popMatrix();
    noFill();
    stroke(255);
    //秒針
    pushMatrix();
    rotate(radians(s*(360/60)));
    strokeWeight(1);
    line(0,0,0,width/2-MARGIN);
    popMatrix();
    //分針
    pushMatrix();
    rotate(radians(m*(360/60)));
    strokeWeight(2);
    line(0,0,0,width/2-MARGIN);
    popMatrix();
    //時針
    pushMatrix();
    rotate(radians(h*(360/12)));
    strokeWeight(4);
    line(0,0,0,width/3-MARGIN);
    popMatrix();
  }
}
