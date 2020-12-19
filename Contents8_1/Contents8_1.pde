import gab.opencv.*;
import processing.video.*;
import java.awt.*;
 
Capture video;
OpenCV opencv;
PImage img;
 
//顔の増幅数
int N = 6;
int Range = 255;
//PCのサイズ
int app_width = 1200;
int app_height = 700;
 
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
    //出力の判定を行って状態を更新する
    if(count > Range * 2)
     {
       count = 0;//0で初期化する
       //新しい位置を決める
       x = random(app_width);
       y = random(app_height);
     }
    //この増加量を変えることで透明度の変わり方が変わる
    count += 10;//カウンターを増やす
  }
};  //Face_gridクラスの宣言の終わり
 
Face_grid[] face;  //Face_gridオブジェクトの宣言
 
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
 
    //キャプチャは半分のサイズにする
    video = new Capture(this, width/2, height/2, cameras[0]);  
    opencv = new OpenCV(this, width/2, height/2);
 
    //顔用のデータをロード  
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    //目のデータをロード
    //opencv.loadCascade(OpenCV.CASCADE_EYE);  
    //口のデータをロード
    //opencv.loadCascade(OpenCV.CASCADE_MOUTH);
 
    video.start();  //キャプチャを開始
  }
}
 
void draw() {
  opencv.loadImage(video);  //ビデオ画像をメモリに展開
  background(0);  //背景黒
  //Debug用
  //image(video, 0, 0 );  //ビデオ画像を表示
  //顔の領域を描画
  //noFill();
  //stroke(0, 255, 0);
  //strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  //複数人いる場合はここの数値が変わる
  //println(faces.length);
 
  //顔検出
  if (0 < faces.length) {
    img = video.get(faces[0].x, faces[0].y, faces[0].width, faces[0].height);
    //rect(eyes[i].x, eyes[i].y, eyes[i].width, eyes[i].height);
    for (int j = 0; j < N; j ++){
      face[j].paint(img);
    }
  }
}
 
void captureEvent(Capture c) {
  c.read();
}
 
//マウスをクリックすると顔の数がランダムで1~10の間で変わる
void mouseClicked(){
  //Nの値は0~9までのランダムな値
  N = (int)random(6);
  //1~10にする
  N += 1;
}
