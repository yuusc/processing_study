import ddf.minim.*;
import ddf.minim.ugens.*;
import java.awt.Frame;
import java.awt.Insets;

 
//クラスの宣言
Minim       minim;    //Minimを使う場合は必ず宣言
AudioOutput out;    //スピーカーから音を出す場合は必ず宣言
Oscil wave;       //関数Oscilを利用する場合は必ず宣言
SecondApplet second;
float frec = 440;
float phi;
float r;
int windoww = 1024;
int windowh = 1024;
float bgcolor = 0;

void setup()
{
  colorMode(HSB,360,100,100,100);
  surface.setResizable(true);
  surface.setSize(windoww, windowh);
    
  minim = new Minim(this);            //Minimを使う場合は必ず実行
  out = minim.getLineOut();           //スピーカーから音を出す場合は必ず実行
     //波形を生成  Oscil(周波数, 振幅, 波形の形状)
  wave = new Oscil( frec, 1, Waves.SINE );   //Sin波
  //波形waveをAudioOutputに接続
  //wave.patch( out );
  
  second = new SecondApplet(this);
}
void draw()
{
  background(bgcolor,100,100,1);
  Radian();
  Changecolor();
  Button1();
  noFill();
  ellipse(windoww/2,windowh/2,200,200);
}

void Radian(){
    float mx = mouseX - (windoww/2);
  float my = -mouseY + (windowh/2);
    phi = atan(my/mx);
  if (mx< 0 ){
      phi = 3.14 + phi;
  }else if(mx >= 0 && my < 0){
      phi = 6.28 + phi;
  }
  r = sqrt(mx*mx+my*my);
  println(phi);
  println(r);
}

void Changecolor(){
  bgcolor = phi * 180 / 3.14;
}

void Button1(){
  for (int i = 0; i < 12; i++){
     float nowrad =i*0.523;
     float nowx = 100*cos(nowrad)+512;
     float nowy = -100*sin(nowrad)+512;
     ellipse(nowx,nowy,35,35);
  }
  if(mousePressed == true && r >= 85 && r <= 115 ){
    if ((phi >= 6.08 && phi <= 6.28) || (phi >= 0 && phi <= 0.20)){
      println("D#");
    }else if (phi >= 0.32 && phi <= 0.72){
      println("D");
    }else if (phi >= 0.85 && phi <= 1.25){
      println("C#");
    }else if (phi >= 1.37 && phi <= 1.77){
      println("C");
    }else if (phi >= 1.89 && phi <= 2.29){
      println("B");
    }else if (phi >= 2.42 && phi <= 2.82){
      println("A#");
    }else if (phi >= 2.94 && phi <= 3.34){
      println("A");
    }else if (phi >= 3.46 && phi <= 3.86){
      println("G#");
    }else if (phi >= 3.99 && phi <= 4.39){
      println("G");
    }else if (phi >= 4.51 && phi <= 4.91){
      println("F#");
    }else if (phi >= 5.03 && phi <= 5.53){
      println("F");
    }else if (phi >= 5.56 && phi <= 5.96){
      println("E");
    }
    
  }else{
  }
}

// http://3846masa.blog.jp/archives/1038375725.html
