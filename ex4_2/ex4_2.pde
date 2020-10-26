import ddf.minim.*;
import ddf.minim.ugens.*;
 
Minim minim;
AudioOutput out;
FilePlayer song;    //FilePlayerを利用するときは必ず宣言
 
void setup()
{
  size(500, 200);
  minim = new Minim( this );
  out = minim.getLineOut();
  song = new FilePlayer(minim.loadFileStream( "tsubasa.wav" )); //wavファイルの読み込み
  song.patch(out);                      //waveファイルをAudioOutputに接続
  song.play();                        //一回再生(.loopで繰り返し再生)
}
 
void draw()
{
}
