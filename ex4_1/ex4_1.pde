import ddf.minim.*;
import ddf.minim.ugens.*;
 
//クラスの宣言
Minim       minim;    //Minimを使う場合は必ず宣言
AudioOutput out;    //スピーカーから音を出す場合は必ず宣言
Oscil wave;       //関数Oscilを利用する場合は必ず宣言
 
void setup()
{
  size(512, 200, P3D);
    
  minim = new Minim(this);            //Minimを使う場合は必ず実行
  out = minim.getLineOut();           //スピーカーから音を出す場合は必ず実行
  
  //波形を生成  Oscil(周波数, 振幅, 波形の形状)
  wave = new Oscil( 440, 1, Waves.SINE );   //Sin波
  //wave = new Oscil( 440, 1, Waves.TRIANGLE ); //三角波
  //wave = new Oscil( 440, 1, Waves.SQUARE ); //方形波
  
  //波形waveをAudioOutputに接続
  wave.patch( out );
}
 
void draw()
{
  background(0);
  stroke(255);
  strokeWeight(1);
  
  for(int i = 0; i < out.bufferSize() - 1; i++)
  {
    //左のスピーカーを駆動するバッファの中身を取り出し描画
    line( i, 50  - out.left.get(i)*50,  i+1, 50  - out.left.get(i+1)*50 );
    //左のスピーカーを駆動するバッファの中身を取り出し描画
    line( i, 150 - out.right.get(i)*50, i+1, 150 - out.right.get(i+1)*50 );
  }
}
