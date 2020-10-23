import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
 
//クラスの宣言
Minim minim;
AudioInput in;
AudioOutput out;
AudioRecorder recorder;
FilePlayer player;
Gain gain;
TickRate rateControl;
Delay delay;
Pan pan;
 
void setup(){
  size(500, 200);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 1024);
  out = minim.getLineOut();
}
 
void draw(){
  if(recorder != null && recorder.isRecording()){
    background(255, 0, 0);
  } else {
    background(0, 0, 0);
  }
}
 
void mousePressed(){
  if(recorder != null && recorder.isRecording()){
    recorder.endRecord();
  } else {
    recorder = minim.createRecorder(in, "record.wav");
    recorder.beginRecord();
  }
}
 
void keyPressed(){
  if(recorder != null){
    //効果の設定
    rateControl = new TickRate(0.8);
    gain = new Gain(10);
    delay = new Delay( 0.4, 0.5, true);
    pan = new Pan(1);
    
    player = new FilePlayer(recorder.save());
    //効果を連結
    player.patch(gain).patch(out);
    player.play();
  }
}
