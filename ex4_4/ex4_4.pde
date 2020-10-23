import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
 
Minim minim;
AudioInput in;
AudioRecorder recorder;       //AudioRecorderを利用する際は必ず宣言
FilePlayer player;;
 
void setup()
{
  size(500, 200);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 1024);
}
 
void draw()
{
  //録音が開始されると背景の色を変更
  if(recorder != null && recorder.isRecording()){
    background(255, 0, 0);
  } else {
    background(0, 0, 0);
  }
}
 
//マウスをクリックすると録音開始，もう一度マウスをクリックすると録音終了
void mousePressed()
{
  if(recorder != null && recorder.isRecording()){
    recorder.endRecord();                 //録音終了
  } else {
    recorder = minim.createRecorder(in, "record.wav");      //AudioInputと保存ファイル名を指定
    recorder.beginRecord();                 //録音開始
  }
}
