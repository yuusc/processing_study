//サウンド用のライブラリを使用する
import ddf.minim.*;
import ddf.minim.signals.*;
 
//Minimクラスのオブジェクト変数minimの宣言
Minim minim;
//AudioOutputクラスのオブジェクト変数outの宣言
AudioOutput out;
//SineWaveクラスのオブジェクト変数sineの宣言
SineWave sine;
 
// プログラム開始時の事前準備
void setup()
{
  // キャンバスサイズの指定
  size(600, 200);
   
  // フレームレートの設定
  frameRate(60);
   
  // 描画結果をアンチエイリアシングする
  smooth();
   
  // 線幅を 2ピクセルに指定
  strokeWeight(2);
   
  // minim の初期化
  minim = new Minim(this);
   
  // 出力先の変数 out にモノラル(もしくはステレオ(STEREO))のオーディオ出力を指定
  out = minim.getLineOut(Minim.MONO);
   
  // 440 Hz、音量 1.0でサイン波を出力
  sine = new SineWave(440, 1.0, out.sampleRate());
   
  // ポルタメント（音程変化のなめらかさ）を200msecに
  sine.portamento(200);
   
  // 生成したサイン波をオーディオ出力に追加するように指定
  out.addSignal(sine);
}
 
// 描画内容を定める
void draw()
{
  // 波形を表示
  //背景を黒に設定する
  background(0);
  stroke(255, 255, 255);
   
  // Y 座標の原点を画面の中心に移動
  translate(0, height/2);
   
  // バッファーに格納されたサンプル数だけくりかえし
  for (int i = 0; i < out.bufferSize() - 1; i++)
  {
    // サンプル数から、画面の幅いっぱいに波形を表示するようにマッピング
    float x = map(i, 0, out.bufferSize(), 0, width);
     
    // 画面の高さいっぱいになるように、サンプルの値をマッピング
    float y = map(out.mix.get(i), 0, 1.0, 0, height/2);
     
    // 値をプロット
    point(x, y);
  }
}
 
// マウスを操作した時の処理内容を定める
void mouseMoved()
{
  // マウスの X座標を周波数に設定する
  // X座標の(0, width)を、周波数(40, 2000)にマップ
  float freq = map(mouseX, 0, width, 20, 8000);
   
  //sine波の周波数の値を設定する
  sine.setFreq(freq);
   
  // マウスの Y座標を音量に設定する
  // Y座標の(0, height)を、周波数(1.0, 0.0)にマップ
  float amp = map(mouseY, 0, height, 1.0, 0);
   
  //sine波の振幅の値を設定する
  sine.setAmp(amp);
}
 
// プログラム終了時の処理を定める
void stop()
{
  //プログラムの終了処理
  out.close();
  minim.stop();
  super.stop();
}
