import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;

// オーディオ入力の変数を用意する
AudioInput in;

// FFTの変数を用意する
FFT fft;

int fftSize;

// プログラム開始時の事前準備
void setup()
{
  // キャンバスサイズの指定
  size(1024, 600);
  colorMode(HSB,360,100,100,100);
  fftSize=512;

  // Minim の初期化
  minim = new Minim(this);

  // ステレオオーディオ入力を取得
  in = minim.getLineIn(Minim.STEREO, 512);

  // ステレオオーディオ入力を FFT と関連づける
  fft = new FFT(in.bufferSize(), in.sampleRate());
}

// 描画内容を定める
void draw()
{
  background(0);
strokeWeight(2.0);
fft.forward( in.mix );
for(int i =0; i < fft.specSize(); i++)
{
float x = map(i,0,fft.specSize(),0,width);
float y = map(fft.getBand(i),0,5.0,height,0);
float h = map(i,0,fft.specSize(),0,180);
stroke(h,100,100);
line(x,height,x,y);
}
}

// プログラム終了時の処理を定める
void stop()
{
  minim.stop();
  super.stop();
}
