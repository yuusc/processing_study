import ddf.minim.*;
import ddf.minim.effects.*;
 
//読み込む音声データのサンプリング周波数に合わせる
float FS = 48000.0;
float DELAY_TIME = 0.2;
float DELAY_LEVEL = 0.3;
int FEEDBACK = 12;
 
//Minimクラスのオブジェクト変数minimの宣言
Minim minim;
//AudioPlayerクラスのオブジェクト変数playerの宣言
AudioPlayer player;
//EchoClass(後で作成する関数)のオブジェクト変数echoの宣言
EchoClass echo;
 
void setup()
{
  size(600, 200);
  strokeWeight(2);
  // minim の初期化
  minim = new Minim(this);
  //再生する音源の指定
  player = minim.loadFile("cat1a.mp3", 1024);
  //echoの初期化
  echo = new EchoClass(FS, DELAY_TIME, DELAY_LEVEL, FEEDBACK);
  //エフェクトを追加する
  player.addEffect(echo);
  //作成した音の再生
  player.play();
}
 
void draw()
{
  background(0);
  stroke(255);
  //音に対応したグラフの作成
  for(int i = 0; i < player.left.size()-1; i++)
  {
    line(i, 50 + player.left.get(i)*50, i+1, 50 + player.left.get(i+1)*50);
    line(i, 150 + player.right.get(i)*50, i+1, 150 + player.right.get(i+1)*50);
  }
}
// プログラム終了時の処理を定める
void stop()
{
  //プログラムの終了処理
  player.close();
  minim.stop();
  super.stop();
}
