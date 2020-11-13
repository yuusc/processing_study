import processing.video.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
 
Movie myMovie;
Minim minim;
AudioPlayer type,jan,yes,no;
String tmp; //文字列を格納する
String ans = "University of Tsukuba"; //問題の答え
PFont font; //フォントを指定するための変数
int time,miss;
int x = 1920, y = 1080;//ウィンドウサイズ
int moji_size;//文字サイズ
 
void setup() {
  size(1920, 1080);//動画サイズの設定
  myMovie = new Movie(this, "door_a.mp4");//動画の読み込み
  myMovie.play();
  tmp = "";
  time = 0;
  miss = 0;
  moji_size = x/20; //文字サイズを設定
  font = createFont("ＭＳ ゴシック",moji_size); //フォントの変更
  minim = new Minim( this );
  type = minim.loadFile("type.mp3"); //効果音読込
  yes = minim.loadFile("yes.mp3");
  no = minim.loadFile("no.mp3");
}
 
void draw() {
  time++; //動画の再生位置を示す
  image(myMovie, 0, 0);
  if(time > 300){ //動画を停めて問題を出題する ※開錠のタイミングが合わない場合はここを調整してください
    miss = 0;
    myMovie.pause();
    textFont(font);
    text("Q.筑波大学の英語表記は?", x/2-moji_size*6, y/2-moji_size);//問題内容
    text(tmp, x/2-moji_size*6, y/2+moji_size);
  }
  else if(miss == 1){
    text("答えが違います", x/2-moji_size*3, y/2-moji_size);
  }
  if(time == -1){
    exit();
  }
} 
 
void movieEvent(Movie m) {
  m.read();
}
 
void keyPressed() {
  background(0);
  println("key pressed key=" + key + ",keyCode=" + keyCode);
  if (keyCode == 8) {
    if (tmp.length() >= 1) {
      tmp = tmp.substring(0, tmp.length()-1);
    }
  } 
  else if (keyCode == 16){
  }
  else if (keyCode == 10){ //回答を入力してEnterを押した時の処理
    if(ans.equals(tmp)){ //入力された回答と問題の答えが一致するかを調べる
      myMovie.play();
      time = -200; //if(time > 300)の判定が再度出ないようにしている
      yes.rewind();
      yes.play();
    }
    else{
      time = 0;
      miss = 1; //誤答のフラグを立てる
      tmp="";
      no.rewind();
      no.play();
    }
  }
  else {
    type.rewind();
    type.play();
    tmp += key;
  }
}
 
void stop(){
  type.close();
  yes.close();
  no.close();
  minim.stop();
  super.stop();
}
