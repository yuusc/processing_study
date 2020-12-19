import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import gab.opencv.*;
import processing.video.*;
import java.awt.*;
 
import controlP5.*;
 
Minim minim;
AudioOutput out;
LiveInput in;
Delay delay;
Capture video;
OpenCV opencv;
PImage img;
Rectangle[] faces;
 
//顔の増幅数
int N = 10;
int Range = 255;
//PCのサイズ
int app_width = 1200;
int app_height = 700;
//顔のサイズを変更するパラメータ
float size;
int img_width,img_height,re_width,re_height;
 
public class Face_grid
{
  //フィールド
  float x;//位置
  float y;
  int count;//カウンター
  
  Face_grid(float _x, float _y, int _count)//コンストラクタ
  {
    x = _x;
    y = _y;
    count = _count;
  }
  void paint(PImage fImage)//描画メソッド
  {
    int col;
    //countがRangeより大きくなったら減衰させる
    if(count >= Range)
      col = Range * 2 - count;
    else
      col = count;
    //imageを出力
    tint(255,255,255,col);//透明度を調節
    image(fImage, x, y);
    //出力の判定を行って新初期状態を更新する
    if(count > Range * 2)
     {
       count = 0;//0で初期化する
       //新しい位置を決める
       x = random(app_width);
       y = random(app_height);
     }
    //この増加量を変えることで透明度の変わり方が変わる
    count += 5;//カウンターを増やす
  }
};  //Face_gridクラスの宣言の終わり
 
Face_grid[] face;  //Face_gridオブジェクトの宣言
 
ControlP5 cp5;
 
void setup() {
  size(1200, 700);
  frameRate(30);
  face = new Face_grid[N];//Face_gridオブジェクトの箱をN個作る
  for(int i = 0; i < N; i++)
  { //以下は初めの設定
    float x = random(app_width);//位置
    float y = random(app_height);
    int count = (int)random(Range);//カウンター
    face[i] = new Face_grid(x, y, count);//それぞれのCircleオブジェクトを作る
  }
  
  //使用できるカメラのリスト
  String[] cameras = Capture.list();
 
  //カメラがなかった場合
  if (cameras.length == 0) {
 
    println("no camera");
    exit();  //終了
  } else {
 
    //カメラがあった場合は、リストを出力
    println("Cameras are");
    for (int i = 0; i < cameras.length; i++) println(cameras[i]);
 
    //キャプチャ
    video = new Capture(this, width/2, height/2, cameras[0]);  
    opencv = new OpenCV(this, width/2, height/2);
 
    //顔用のデータをロード  
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    //目のデータをロード
    //opencv.loadCascade(OpenCV.CASCADE_EYE);  
    //口のデータをロード
    //opencv.loadCascade(OpenCV.CASCADE_MOUTH);
 
    video.start();  //キャプチャを開始
    re_width = 10;    //横幅
re_height = 10;  //縦幅
  }
  minim = new Minim(this);
  out = minim.getLineOut();
  AudioStream inputStream = minim.getInputStream(
                            out.getFormat().getChannels(),
                            out.bufferSize(),
                            out.sampleRate(),
                            out.getFormat().getSampleSizeInBits());
  in = new LiveInput(inputStream);
  delay = new Delay(1.0, 1.0, true);
  in.patch(delay);
  delay.patch(out);
  
  cp5 = new ControlP5(this);
  float knobRadius = 40;
  cp5.addKnob("setDelayTime")
     .setLabel("dekay time")
     .setRange(0.0, 2.0)
     .setValue(1.0)
     .setPosition(width / 3.0 * 1.0 - knobRadius, 250 - knobRadius)
     .setRadius(knobRadius);
  cp5.addKnob("setDelayAmp")
     .setLabel("delay amp")
     .setRange(0.0, 1.0)
     .setValue(0.5)
     .setPosition(width / 3.0 * 2.0 - knobRadius, 250 - knobRadius)
     .setRadius(knobRadius); 
}
 
void setDelayTime(float value){
  delay.setDelTime(value);
  N = (int)(value * 5);
}
 
void setDelayAmp(float value){
  delay.setDelAmp(value);
  size = value+0.5;
  println(size);
  img_width = img.width;    //横幅
img_height = img.height;  //縦幅
  re_width = round((img_width * size+1)*10)/10;
re_height = round((img_height * size+1)*10)/10;
println(img_width,img_height);
}
 
void draw() {
  //println(re_width);
  //println(re_height);
  opencv.loadImage(video);  //ビデオ画像をメモリに展開
  background(0);
  //image(video, 0, 0 );  //表示
  
  //顔の領域を検出
  Rectangle[] faces = opencv.detect();
 
  //顔検出
  //顔検出
  if (0 < faces.length) {
    img = video.get(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
    img.resize((int)(re_width), (int)(re_height));
    for (int j = 0; j < N; j ++){
      face[j].paint(img);
    }
  }
}
 
void captureEvent(Capture c) {
  c.read();
}
