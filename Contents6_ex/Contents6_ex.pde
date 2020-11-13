import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
Minim minim;
AudioPlayer yes, no;
String tmp;
PFont font;
int Q = 0, enter = 0, Rrgb, Rwrite, Rx, Ry, first = 1, ans = -1, time = 600, correct = 0, wrong = 0, k = 1, textsize, degree,tslx,tsly;
int [][] rgb = {{255, 0, 0}, {0, 255, 0}, {0, 0, 255}};
String [] write = {"red", "blue", "green"};
void setup() {
  size(300, 220);
  background(0);
  font = createFont("VL Gothic", 24);
  textFont(font);
  tmp = "";
  minim = new Minim( this );
  yes = minim.loadFile( "yes.mp3" );
  no = minim.loadFile( "no.mp3" );
}
void draw() {
  if (time < 0) {
    fill(0);
    rect(0, 0, 300, 220);
    fill(255);
    text("正解数："+str(correct), 100, 110);
    text("不正解数："+str(wrong), 100, 134);
    text("Enterで終了", 10, 24);
    if (enter == 1) {
      exit();
    }
  } else if (Q == 0) {
    fill(255, 255, 255);
    text("Enterでスタート", 10, 24);
    text("制限時間内で", 10, 48);
    text("書いてある色を答えよ", 10, 72);
    text("HARDMODEはここをクリック", 10, 96);
    if (mouseY >= 72 && mouseY <= 96 && mousePressed == true) {
      Q = 2;
      fill(0);
      rect(0, 0, 300, 220);
      first = 1;
    }
    if (enter == 1) {
      Q++;
      enter = 0;
      fill(0);
      rect(0, 0, 300, 220);
      first = 1;
    }
  } else if (Q == 1) {
    time--;
    fill(255);
    rect(0, 0, int(time/2), 24);
    if (first == 1) {
      Rrgb = int(random(3));
      Rwrite = int(random(3));
      Rx = int(random(150));
      Ry = int(random(100));
      first = 0;
    }
    fill(rgb[Rrgb][0], rgb[Rrgb][1], rgb[Rrgb][2]);
    text(write[Rwrite], 200 - Rx, 150 - Ry);
    if (ans == Rwrite) {
      correct++;
      first = 1;
      ans = -1;
      fill(0);
      rect(0, 0, 300, 220);
      yes.rewind();
      yes.play();
      k = 1;
    } else if (k == 0) {
        k = 1;
        wrong++;
        no.rewind();
        no.play();
      }
  }else if (Q == 2) {
      time--;
      fill(255);
      rect(0, 0, int(time/2), 24);
      if (first == 1) {
        Rrgb = int(random(3));
        Rwrite = int(random(3));
        Rx = int(random(150));
        Ry = int(random(100));
        textsize = int(random(18, 30));
        first = 0;
        degree = int(random(360));
        tslx=300/2;
        tsly=220/2;
      }
       hard();
      if (ans == Rwrite) {
        correct++;
        first = 1;
        ans = -1;
        fill(0);
        rect(0, 0, 300, 220);
        yes.rewind();
        yes.play();
        k = 1;
      } else if (k == 0) {
        k = 1;
        wrong++;
        no.rewind();
        no.play();
      }
  }
    fill(255, 255, 255);
    textFont(font);
    text("あか(1) あお(2) みどり(3)", 12, 200);
  }
  void hard(){
    fill(rgb[Rrgb][0], rgb[Rrgb][1], rgb[Rrgb][2]);
      translate(tslx,tsly);
      rotate(radians(degree));
      textSize(textsize);
      text(write[Rwrite], 200 - Rx, 150 - Ry);
  }
  void keyPressed(){
    background(0);
    println("key pressed key=" + key + ",keyCode=" + keyCode);
    if (keyCode == 8) { // backspace.
      if (tmp.length() >= 1) {
        tmp = tmp.substring(0, tmp.length()-1);
      }
    } else if (keyCode == 10) {
      enter = 1;
    } else if (keyCode == 49) {
      ans = 0;
      k = 0;
    } else if (keyCode == 50) {
      ans = 1;
      k = 0;
    } else if (keyCode == 51) {
      ans = 2;
      k = 0;
    }
  }
  void stop() {
    yes.close();
    no.close();
    minim.stop();
    super.stop();
  }
