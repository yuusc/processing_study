import ddf.minim.*; //<>//
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import controlP5.*;
 
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
ControlP5 slider;
ControlP5 button;
Slider s1;
Slider s2;
Slider s3;
Slider s4;
Slider s5;
Button b1;
Button b2;
float gainvalue;
float panvalue;
float delaytvalue;
float delayavalue;
float ratevalue;
int mxy = 350;
Table dataArray;
String fileData;
PrintWriter file;
 
void setup(){
  size(500, 500);
  colorMode(RGB,256);
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 1024);
  out = minim.getLineOut();
  slider = new ControlP5(this);
  s1=slider.addSlider("gainvalue")
    .setLabel("volume")
    .setRange(0.01, 10)
    .setValue(5)//初期値
    .setPosition(433, 10)//位置
    .setSize(24, 200)//スライダの大きさ
    .setColorActive(color(255, 0, 0))//スライダの色
    .setColorBackground(color(255, 0, 0, 120)) //スライダの背景色 
    .setColorCaptionLabel(color(0)) //キャプションラベルの色
    .setColorForeground(color(255, 0, 0)) //スライダの色(マウスを離したとき)
    .setColorValueLabel(color(0)) //数値の色
    .setSliderMode(Slider.FIX);//スライダーの形
    
   s2=slider.addSlider("delayavalue")
    .setLabel("delay_amplitude")
    .setRange(0.01, 1)
    .setValue(0.36)//初期値
    .setPosition(10, 413)//位置
    .setSize(200, 24)//スライダの大きさ
    .setColorActive(color(125,122,255))//スライダの色
    .setColorBackground(color(207, 205, 255, 120)) //スライダの背景色 
    .setColorCaptionLabel(color(0)) //キャプションラベルの色
    .setColorForeground(color(125,122,255,120)) //スライダの色(マウスを離したとき)
    .setColorValueLabel(color(0)) //数値の色
    .setSliderMode(Slider.FIX);//スライダーの形
    
   s3=slider.addSlider("delaytvalue")
    .setLabel("delay_time")
    .setRange(0.01, 1)
    .setValue(0.25)//初期値
    .setPosition(10, 383)//位置
    .setSize(200, 24)//スライダの大きさ
    .setColorActive(color(125,122,255))//スライダの色
    .setColorBackground(color(207, 205, 255, 120)) //スライダの背景色 
    .setColorCaptionLabel(color(0)) //キャプションラベルの色
    .setColorForeground(color(125,122,255,120)) //スライダの色(マウスを離したとき)
    .setColorValueLabel(color(0)) //数値の色
    .setSliderMode(Slider.FIX);//スライダーの形
    
    s4=slider.addSlider("panvalue")
    .setLabel("pan")
    .setRange(-1, 1)
    .setValue(0)//初期値
    .setPosition(10, 443)//位置
    .setSize(200, 24)//スライダの大きさ
    .setColorActive(color(54,205,255))//スライダの色
    .setColorBackground(color(158,239,255, 120)) //スライダの背景色 
    .setColorCaptionLabel(color(0)) //キャプションラベルの色
    .setColorForeground(color(54,205,255,120)) //スライダの色(マウスを離したとき)
    .setColorValueLabel(color(0)) //数値の色
    .setSliderMode(Slider.FIX);//スライダーの形
    
   s5=slider.addSlider("ratevalue")
    .setLabel("tickrate")
    .setRange(0.01, 5)
    .setValue(1.5)//初期値
    .setPosition(383,10)//位置
    .setSize(24,200)//スライダの大きさ
    .setColorActive(color(255, 0, 0))//スライダの色
    .setColorBackground(color(255, 0, 0, 120)) //スライダの背景色 
    .setColorCaptionLabel(color(0)) //キャプションラベルの色
    .setColorForeground(color(255, 0, 0)) //スライダの色(マウスを離したとき)
    .setColorValueLabel(color(0)) //数値の色
    .setSliderMode(Slider.FIX);//スライダーの形
    
    button = new ControlP5(this);
  b1=button.addButton("SettingsLoad")
    .setLabel("SETTINGS LOAD")//テキスト
    .setPosition(400, 300)
    .setSize(60, 60);
    b2=button.addButton("SettingsSave")
    .setLabel("SETTINGS SAVE")//テキスト
    .setPosition(400, 400)
    .setSize(60, 60);
    
    
   fileData = sketchPath()+"\\settings.csv";
}
 
void draw(){
  if(recorder != null && recorder.isRecording()){
    background(255, 0, 0);
    textSize(20);
    text("NOW RECORDING...",90,250);
    fill(255);
    rect(150,150,50,50);
  } else {
    background(255);
    fill(255,0,0);
    ellipse(175,175,50,50);
    fill(0);
    textSize(15);
    text("CLICK THE BUTTON TO START RECORDING",10,250);
    text("PRESS ANY KEY TO PLAY THE SOUND",20,270);
  }
  fill(212,229,3);
  rect(350,0,150,500);
  rect(0,350,350,150);
}
 
void mousePressed(){
  if (mouseX <= mxy && mouseY <= mxy) {
  if(recorder != null && recorder.isRecording()){
    recorder.endRecord();
  } else {
    recorder = minim.createRecorder(in, "record.wav");
    recorder.beginRecord();
  }
  }
}

void SettingsLoad(){
File file = new File( fileData );
  if( file.exists() == true ){
    dataArray = loadTable(fileData);
     gainvalue = dataArray.getFloat(0, 0);
     panvalue = dataArray.getFloat(0, 1);
     delaytvalue = dataArray.getFloat(0, 2);
     delayavalue = dataArray.getFloat(0, 3);
     ratevalue = dataArray.getFloat(0, 4);
     s1.updateInternalEvents(this);
     s2.updateInternalEvents(this);
     s3.updateInternalEvents(this);
     s4.updateInternalEvents(this);
     s5.updateInternalEvents(this);
  }else{
    text("Don't exist settings.csv",480,480);
  }
}

void SettingsSave(){
  file = createWriter(fileData);
  file.print(gainvalue);
  file.print(",");
  file.print(panvalue);
  file.print(",");
  file.print(delaytvalue);
  file.print(",");
  file.print(delayavalue);
  file.print(",");
  file.println(ratevalue);
  file.flush();
  file.close();
}

void keyPressed(){
  if(recorder != null){
    rateControl = new TickRate(ratevalue);
    gain = new Gain(gainvalue);
    delay = new Delay( delaytvalue, delayavalue, true);
    pan = new Pan(panvalue);
    player = new FilePlayer(recorder.save());
    player.patch(rateControl).patch(gain).patch(delay).patch(pan).patch(out);
    player.play();
  }
}
