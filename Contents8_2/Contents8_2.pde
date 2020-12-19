import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
 
import controlP5.*;
 
Minim minim;
AudioOutput out;
LiveInput in;
Delay delay;
 
ControlP5 cp5;
 
void setup(){
  size(512, 350);
  //Minim のインスタンスを生成
  minim = new Minim(this);
  //minim オブジェクトからAudioのInputを参照出来るようにする
  out = minim.getLineOut();
  //マイクの音声を拾ってくる
  AudioStream inputStream = minim.getInputStream(
                            out.getFormat().getChannels(),
                            out.bufferSize(),
                            out.sampleRate(),
                            out.getFormat().getSampleSizeInBits());
  //LiveInputのインスタンスを生成
  in = new LiveInput(inputStream);
  //Delayのインスタンスを生成（これがエコーになる）
  delay = new Delay(1.0, 1.0, true);
  //入力音声(in) -> エコーの遅れてくる音声(delay)
  in.patch(delay);
  //音声出力
  delay.patch(out);
  
  //ControlP5のインスタンスを生成
  cp5 = new ControlP5(this);
  //Knobの半径
  float knobRadius = 40;
  //遅れてくる音の時間のパラメータを変化させるKnob
  //Knobの名前
  cp5.addSlider("setDelayTime")
     //表示されるラベル名
     .setLabel("dekay time")
     //パラメータの値の範囲
     .setRange(0.0, 2.0)
     //パラメータ初期値
     .setValue(1.0)
     //配置する位置と大きさ(半径)
     .setPosition(width / 3.0 * 1.0 - knobRadius, 250 - knobRadius)
     //.setRadius(knobRadius);
     .setSize(100,20);
  //遅れてくる音の大きさのパラメータを変化させるKnob
  cp5.addSlider("setDelayAmp")
     .setLabel("delay amp")
     .setRange(0.0, 1.0)
     .setValue(0.5)
     .setPosition(width / 3.0 * 2.0 - knobRadius, 250 - knobRadius)
     //.setRadius(knobRadius); 
     .setSize(100,20);
}
 
//Knob[setDelayTime](時間)の値を変化させたときに出力に反映
void setDelayTime(float value){
  delay.setDelTime(value);
}
 
////Knob[setDelayAmp](大きさ)の値を変化させたときに出力に反映
void setDelayAmp(float value){
  delay.setDelAmp(value);
}
 
//(ステレオ)音の波形の描画
void draw(){
  background(128);
  stroke(255);
  for(int i = 0; i < out.bufferSize() - 1; i++){
    //左チャンネルの波形
    line(i, 50 + out.left.get(i) * 50, i + 1,  50 + out.left.get(i + 1) * 50);
    //右チャンネルの波形
    line(i, 150 + out.right.get(i) * 50, i + 1,  150 + out.right.get(i + 1) * 50);
  }
}
