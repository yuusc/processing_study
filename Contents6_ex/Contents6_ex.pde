import controlP5.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer yes, no, start;
ControlP5 Toggle;
String tmp;
PFont font;
int Q = 0, enter = 0, Rrgb, Rwrite, Rx, Ry, first = 1, ans = -1, time = 1200, starttime = 250, correct = 0, wrong = 0, k = 1, textsize, percent=0,tmpco=0,tmpper=0,score=0,highscore;
int [][] rgb = {{255, 0, 0}, {0, 255, 0}, {0, 0, 255}};
String [] write = {"red", "blue", "green"};
boolean toggleValue;
String rank;
String filename = "highscore.txt";

void setup() {
  size(300, 220);
  background(0);
  font = createFont("ＭＳ ゴシック", 24); //VL Gothic
  textFont(font);
  tmp = "";
  minim = new Minim( this );
  yes = minim.loadFile( "yes.mp3" );
  no = minim.loadFile( "no.mp3" );
  start = minim.loadFile("start.mp3");
  Toggle = new ControlP5(this);
  rectMode(CENTER);
  Toggle.addToggle("toggleValue")
    .setLabel("HARD")
    .setSize(80, 20)
    .setPosition(100, 130)
    .setValue(false)
    .setColorCaptionLabel(color(255)) //テキストの色
    .setMode(ControlP5.SWITCH);
  readFile();
}
void draw() {
  //println("mouseX"+str(mouseX));
  //println("mouseY"+str(mouseY));
  
  //集計
  if (time < 0) {
    if(correct + wrong == 0){
      percent = 0;
    }else{
    percent = correct*100/(correct+wrong);
  }
    //難易度による点数調整
    if (Q == 1){
      tmpco = correct;
      tmpper = percent;
    }else if(Q == 2){
      tmpco = int(correct * 1.9);
      tmpper = percent;
      if (tmpper >= 100){
        tmpper = 100;
      }
    }
    
    //スコアによるランク決定
    if (tmpco > 30) {
      if (tmpper>=80) {
        rank = "S";
      } else if (tmpper < 80 && tmpper >= 50) {
        rank = "A";
      } else if (tmpper < 50 && tmpper >= 20) {
        rank = "B";
      } else {
        rank = "C";
      }
    } else if (tmpco <= 30 && tmpco > 15) {
      if (tmpper>=80) {
        rank = "A";
      } else if (tmpper < 80 && tmpper >= 50) {
        rank = "B";
      } else if (tmpper < 50 && tmpper >= 20) {
        rank = "C";
      } else {
        rank = "D";
      }
    } else {
      if (tmpper>=80) {
        rank = "B";
      } else if (tmpper < 80 && tmpper >= 50) {
        rank = "C";
      } else if (tmpper < 50 && tmpper >= 20) {
        rank = "D";
      } else {
        rank = "E";
      }
    }
    score = tmpper * tmpco;
    fill(0);
    rect(0, 0, 800, 600);
    fill(255);

    text("正解数："+str(correct), 100, 110);
    text("不正解数："+str(wrong), 100, 134);
    text(str(percent)+"%", 150, 158);
    text("ランク:"+rank, 100, 86);
    text("Enterで終了", 10, 24);
    text("スコア:"+score, 100, 48);
    textSize(18);
    if (score >= highscore){
    text("(ハイスコア:"+score+")",70,67);
    }else{
    text("(ハイスコア:"+highscore+")",70,67);
    }
    //scoreがhighscore以上だったら最高記録を記録
    if (score >= highscore){
  PrintWriter output = createWriter(filename);
 int saves = score;
 output.println(saves);
 output.flush();
 output.close();
  }
    if (enter == 1) {
      exit();
    }
  } else if (Q == 0) {
    fill(255, 255, 255);
    text("Enterでスタート", 10, 24);
    text("制限時間内で", 10, 48);
    text("書いてある色を答えよ", 10, 72);
    text("下のスイッチでモード変更", 10, 96);
    if (enter == 1) {
      if (toggleValue==true) {
        Q = 2;
        enter = 0;
        fill(0);
        rect(0, 0, 800, 600);
        first = 1;
        Toggle.setVisible(false);
        start.rewind();
        start.play();
      } else {
        Q = 1;
        enter = 0;
        fill(0);
        rect(0, 0, 800, 600);
        first = 1;
        Toggle.setVisible(false);
        start.rewind();
        start.play();
      }
    }
  } else if (Q == 1) {
    if (starttime <= 250 && starttime > 190) {
      background(0);
      textSize(50);
      text("3", 150, 110);
      starttime--;
    } else if (starttime <= 190 && starttime > 130) {
      background(0);
      textSize(50);
      text("2", 150, 110);
      starttime--;
    } else if (starttime <= 130 && starttime > 70) {
      background(0);
      textSize(50);
      text("1", 150, 110);
      starttime--;
    } else if (starttime <= 70 && starttime > 0) {
      background(0);
      textSize(50);
      text("start", 110, 110);
      starttime--;
    } else {
      background(0);
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
        rect(0, 0, 800, 600);
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
  } else if (Q == 2) {
    if (starttime <= 250 && starttime > 190) {
      background(0);
      textSize(50);
      text("3", 150, 110);
      starttime--;
    } else if (starttime <= 190 && starttime > 130) {
      background(0);
      textSize(50);
      text("2", 150, 110);
      starttime--;
    } else if (starttime <= 130 && starttime > 70) {
      background(0);
      textSize(50);
      text("1", 150, 110);
      starttime--;
    } else if (starttime <= 70 && starttime > 0) {
      background(0);
      textSize(50);
      text("start", 110, 110);
      starttime--;
    } else {
      background(0);
      time = time - 2;
      fill(255);
      rect(0, 0, int(time/2), 24);
      if (first == 1) {
        Rrgb = int(random(3));
        Rwrite = int(random(3));
        Rx = int(random(150));
        Ry = int(random(100));
        textsize = int(random(18, 30));
        first = 0;
      }
      fill(rgb[Rrgb][0], rgb[Rrgb][1], rgb[Rrgb][2]);
      textSize(textsize);
      text(write[Rwrite], 200 - Rx, 150 - Ry);
      if (ans == Rwrite) {
        correct++;
        first = 1;
        ans = -1;
        fill(0);
        rect(0, 0, 800, 600);
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
  }
  fill(255, 255, 255);
  textFont(font);
  text("あか(1) あお(2) みどり(3)", 12, 200);
}
void keyPressed() {
  background(0);
  //println("key pressed key=" + key + ",keyCode=" + keyCode);
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
  start.close();
  minim.stop();
  super.stop();
}

//ハイスコア記録ファイルを読み込み，highscoreに代入
void readFile() {
 BufferedReader reader = createReader(filename);
 String line = null;
 try {
  while ((line = reader.readLine()) != null) {
   highscore = int(line);
  }
  reader.close();
 } catch (IOException e) {
  e.printStackTrace();
 }
} 
