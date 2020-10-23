import ddf.minim.*;
import ddf.minim.signals.*;
 
Minim minim;
AudioInput in;      //マイクを使う場合は必ず宣言
 
void setup()
{
  size(600, 200);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 1024);   //マイクを使う場合は必ず実行　第一引数でモノかステレオかを設定　第二引数でバッファサイズ
}
 
void draw()
{
  background(0);
  stroke(0, 255, 0);
  strokeWeight(2);
  
  for (int i = 0; i < in.bufferSize() - 1; i++)
  {
    //オーディオ入力のバッファの中身を取り出し描画
    line( i, 100  - in.mix.get(i)*50,  i+1, 100  - in.mix.get(i+1)*50 );
  }
}
