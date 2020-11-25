import ddf.minim.*;
 
Minim minim;  //Minim型変数であるminimの宣言
AudioPlayer BGM;  //サウンドデータ格納用の変数
AudioPlayer SE1;  //サウンドデータ格納用の変数
AudioPlayer SE2;
Bullet bullet;
private Boss boss = new Boss(100, 150);
private ArrayList<Bullet> danmaku = new ArrayList<Bullet>();
PImage bulletimg1;
PImage bulletimg2;
PImage bulletimg3;
PImage bossimg;
PImage airshipimg;
PImage hpimg;

int enemy_x[]=new int[10],enemy_y[]=new int[10];  //敵機のx,y座標
int enemy_speed[]=new int[10];  //敵機の速さ
int hp = 3;  //自機の体力
String scene = "title";  //シーンを指定する文字列
int time = 0; //時間
int score = 0;  //生存時間表示用変数
int bosshp;
int bosshpnow;
int timea=0;
boolean debug = false;
  
void setup(){
  size(1000,1000);  //画面サイズ
  frameRate(30);
  bullet = new Bullet(width/2, height/2, 10, 0, 0 );
  minim = new Minim(this);
  BGM = minim.loadFile("BGM.mp3"); //mp3ファイルを指定する
  SE1 = minim.loadFile("bomb.mp3"); //mp3ファイルを指定する
  SE2 = minim.loadFile("WAV_20201030_171337544.wav");
  bosshp = 180;
  bosshpnow = bosshp;
  bulletimg1 = loadImage("bullet1.png");
  bulletimg2 = loadImage("bullet2.png");
  bulletimg3 = loadImage("bullet3.png");
  bossimg = loadImage("boss.png");
  airshipimg = loadImage("airship.png");
  hpimg = loadImage("heart.png");
}
  
void draw(){  
  time++;  //timeは1/30秒ごとに1増える
   
  //scene変数の番号によって関数呼び出し
  switch(scene){
    case "title":
      title_scene();
      break;
    case "play":
      play_scene();
      break;
    case "gameover":
      gameover_scene();
      break;
     case "clear":
       clear_scene();
       break;
  }  
}
 
//タイトル画面での処理
void title_scene(){
  background(0);  //0は黒の背景　255は白の背景
  textSize(100);  //テキストサイズを指定
  text("Start",350,500); //座標350,500にStartを表示
  textSize(50);  //テキストサイズを指定
  text("Press left click",300,600);  //座標300,600にPress left clickを表示
    
  
  if (mouseButton == RIGHT){
    debug = true;
    hp=20;
    time = 0;  //時間をリセット
    BGM.play(0);  //プレイ画面中のBGM再生
    scene = "play";
  }
  //左クリックされたらプレイ画面へ
  if(mouseButton == LEFT){
    time = 0;  //時間をリセット
    BGM.play(0);  //プレイ画面中のBGM再生
    scene = "play";
  }
}
 
//プレイ画面での処理
void play_scene(){
  background(0);  //0は黒の背景　255は白の背景
  for(int i = 0;i < hp;i++){
    image(hpimg,900+i*20,30,20,20);
  }
  image(bossimg,bossx,bossy,40,40);
  if (timea+60<=time){
  image(airshipimg,mouseX-20,mouseY-20,40,40);
  }else{
    if((time-timea)%30<7){
      image(airshipimg,mouseX-20,mouseY-20,40,40);
    }else if((time-timea)%30>=14 &&(time-timea)%30< 21){
      image(airshipimg,mouseX-20,mouseY-20,40,40);
    }
  }
  //fill(255,0,0);
  ellipse(mouseX,mouseY,16,16);  //自機
  //noFill();
  
  boss.emit();
  for (int i = danmaku.size() -1; i  >= 0; i--) {
    Bullet b = (Bullet)danmaku.get(i);
    if (!b.isAlive()) {
      danmaku.remove(i);
      continue;
    }
    b.update();
  }
  //自機の撃墜（ゲームオーバー画面へ）
  if(hp<=0){
    BGM.close();  //プレイ中のBGMを終了
    score = time;  //時間が増え続けてしまうのでscoreに格納
    scene = "gameover";
  }
  text("Time:"+time/30,30,50);  //画面に時間を表示
  println(bossx,bossy);
  fill(255);
  rect(0,0,width*bosshpnow/bosshp,10);
  noFill();
  stroke(0,200,200);
  strokeWeight(6);
  line(mouseX,mouseY-10,mouseX,0);
  strokeWeight(1);
  attack();
  if (bosshpnow <= 0){
    BGM.close();  //プレイ中のBGMを終了
    score = time;
    scene = "clear";
  }
}
 
//ゲームオーバー画面での処理
void gameover_scene(){
  background(0);  //0は黒の背景　255は白の背景
  textSize(100); //テキストサイズを指定
  text("Game Over",250,500); //座標250,500にGame Overを表示 
  textSize(50);
  text("Time:"+score/60,400,600);
}
void clear_scene(){
  background(0);  //0は黒の背景　255は白の背景
  textSize(100); //テキストサイズを指定
  text("Game Clear!",250,500); //座標250,500にGame Overを表示 
  textSize(50);
  text("Time:"+score/60,400,600);
}

void attack(){
  if (mouseX-3 < bossx+15 && mouseX + 3 > bossx-15&&bossy+15 < mouseY){
    bosshpnow--;
    SE2.play(0);
  }
}
