import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
Minim minim;
AudioPlayer song;
 
String tmp; //文字列を格納する変数
int y = 0;
int moji_size = 10;
char moji;
 
void setup() {
  size(300, 300);
  background(0);
  tmp = ""; //文字列の初期化
  minim = new Minim( this ); 
  song = minim.loadFile( "type.mp3" );
}
 
void draw() {
  y++; //文字位置のy軸を下へずらす
  textSize(moji_size); //文字サイズを10にする
  for(int x = 0;x <= 30; x++){
    if(int(random(3)) == 1){ //文字の出現を1/4にする（乱数は0~3）
      moji = char(int(random(33,127))); //ASCIIコード33~126に対応する文字を表示
      fill(0,255,0); //文字を緑色に設定
      text(moji, x*moji_size, y*moji_size); //文字を描写
    }
  }
  if(y >= 30){
    y = 0; //文字位置のy軸を戻す
    background(0); //画面全体を黒でクリアする
  }
  textSize(30);
  fill(0,0,255);
  text(tmp, 4, 30); //文字列tmpを描画
}
 
void keyPressed() { //キーボードが入力された際の動作
  background(0); //常に描画を更新するため一度画面をクリアする
  println("key pressed key=" + key + ",keyCode=" + keyCode); //コンソールにキーとASCIIコードを表示
  if (keyCode == 8) { // backspaceの処理
    if (tmp.length() >= 1) {
      tmp = tmp.substring(0, tmp.length()-1); //文字列変数の一番最後のASCIIコードを0(null)に書き換え
    }
  } 
  else if (keyCode == 16){ //Shiftキーが文字列として入力されるのを防ぐ
  }
  else { //上記以外のキーが押された時の動作
    song.rewind();
    song.play();
    tmp += key; //入力されたキーのASCIIコードを文字列変数tmpに追加
  }
}
void stop(){ //minimの停止処理
  song.close();
  minim.stop();
  super.stop();
}
