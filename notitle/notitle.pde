import java.awt.Frame;
import java.awt.Insets;
import javax.swing.*;
import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.util.Scanner;
import javax.sound.midi.*;
import controlP5.*;
import java.util.HashMap;
import java.util.Map;

public static final int NOTE_ON = 0x90;
public static final int NOTE_OFF = 0x80;
public static final String[] NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", 
  "F#", "G", "G#", "A", "A#", "B"};


//クラスの宣言
SecondApplet second;
JLayeredPane pane;
JTextArea area;
Sequence sequence;
ControlP5 Button;
float frec = 440;
float phi;
float r;
int width = 1024;
int height = 1024;
float bgcolor = 0;
String path = "";
String rawlyrics = "";
String[] romalyrics;
String[] hiraganalyrics;
String errorcode;

void setup()
{
  background(255);
  colorMode(HSB, 360, 100, 100, 100);
  surface.setResizable(false);//ウィンドウサイズが変更できるかどうか
  surface.setSize(width, height);

  second = new SecondApplet(this);
  size(200, 200); 

  // SmoothCanvasの親の親にあたるJLayeredPaneを取得
  java.awt.Canvas canvas = (java.awt.Canvas) surface.getNative();
  pane = (JLayeredPane) canvas.getParent().getParent();
  area = new JTextArea();
  area.setLineWrap(true);
  area.setWrapStyleWord(true);
  JScrollPane scrollPane = new JScrollPane(area);
  scrollPane.setBounds(10, 150, 1000, 100);
  pane.add(scrollPane);

  area.setText("歌詞を入力してください");


  Button = new ControlP5(this);
  Button.addButton("fileselect")
    .setLabel("ファイル選択")//テキスト
    .setPosition(50, 40)
    .setSize(100, 40);
  Button.addButton("fileload")
    .setLabel("ファイルロード")//テキスト
    .setPosition(180, 40)
    .setSize(100, 40);
  Button.addButton("lyricsload")
    .setLabel("歌詞ロード")//テキスト
    .setPosition(80, 140)
    .setSize(100, 40);
}
void draw()
{
  //background(bgcolor,100,100,1);
  Radian();
  //Changecolor();
  Button1();
  noFill();
  ellipse(width/2, height/2, 200, 200);
  text(path, 1, 1);
}

void Radian() {
  float mx = mouseX - (width/2);
  float my = -mouseY + (height/2);
  phi = atan(my/mx);
  if (mx< 0 ) {
    phi = 3.14 + phi;
  } else if (mx >= 0 && my < 0) {
    phi = 6.28 + phi;
  }
  r = sqrt(mx*mx+my*my);
  //println(phi);
  //println(r);
}

void Changecolor() {
  bgcolor = phi * 180 / 3.14;
}

void Button1() {
  for (int i = 0; i < 12; i++) {
    float nowrad =i*0.523;
    float nowx = 100*cos(nowrad)+512;
    float nowy = -100*sin(nowrad)+512;
    ellipse(nowx, nowy, 35, 35);
  }
  if (mousePressed == true && r >= 85 && r <= 115 ) {
    if ((phi >= 6.08 && phi <= 6.28) || (phi >= 0 && phi <= 0.20)) {
      println("D#");
    } else if (phi >= 0.32 && phi <= 0.72) {
      println("D");
    } else if (phi >= 0.85 && phi <= 1.25) {
      println("C#");
    } else if (phi >= 1.37 && phi <= 1.77) {
      println("C");
    } else if (phi >= 1.89 && phi <= 2.29) {
      println("B");
    } else if (phi >= 2.42 && phi <= 2.82) {
      println("A#");
    } else if (phi >= 2.94 && phi <= 3.34) {
      println("A");
    } else if (phi >= 3.46 && phi <= 3.86) {
      println("G#");
    } else if (phi >= 3.99 && phi <= 4.39) {
      println("G");
    } else if (phi >= 4.51 && phi <= 4.91) {
      println("F#");
    } else if (phi >= 5.03 && phi <= 5.53) {
      println("F");
    } else if (phi >= 5.56 && phi <= 5.96) {
      println("E");
    }
  } else {
  }
}
void keyPressed() {
  if (keyCode==ENTER) {
    area.setText("");
  }
}

void fileselect() {
  selectInput("Select a file to process:", "fileSelected");
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    path = selection.getAbsolutePath();
  }
}

void fileload() {
  try {
    sequence = MidiSystem.getSequence(new File(dataPath(path))); //データはスケッチ以下のdataディレクトリに
    int trackNumber = 0;
    for (Track track : sequence.getTracks()) {
      trackNumber++;
      println("Track "+trackNumber + ": size = "+track.size());
      for (int i=0; i<track.size(); i++) {
        MidiEvent event = track.get(i);
        println("@" + event.getTick()+" ");
        MidiMessage message = event.getMessage();
        if (message instanceof ShortMessage) {
          ShortMessage sm =(ShortMessage) message;
          if (sm.getCommand() == NOTE_ON ) {
            int key = sm.getData1();
            int octave = (key/12)-1;
            int note = key %12;
            String noteName = NOTE_NAMES[note];
            int velocity = sm.getData2();
            println("Note on, " + noteName + octave + " key=" + key + " velocity: " + velocity);
          } else if (sm.getCommand() == NOTE_OFF) {
            int key = sm.getData1();
            int octave = (key / 12)-1;
            int note = key % 12;
            String noteName = NOTE_NAMES[note];
            int velocity = sm.getData2();
            println("Note off, " + noteName + octave + " key=" + key + " velocity: " + velocity);
          } else {
            println("Command:" + sm.getCommand());
          }
        } else {
          println("Other message: " + message.getClass());
        }
      }
    }
  }
  catch(Exception ex) {
    println(ex.getMessage());
  }
}

void lyricsload() {
  if (area.getText().matches("^[\\u3040-\\u309F]+$")) {
    println("全てひらがなです");
    //Hira2RomaMap henkan = new Hira2RomaMap;
    //henkan.main();
  } else {
    println("ひらがな以外を含めることはできません．");
  }
}


// http://3846masa.blog.jp/archives/1038375725.html
//http://turtley-fms.hatenablog.com/entry/2017/12/02/165458
//https://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q10208221990
//https://mandarake.cocolog-nifty.com/oyajidangi/2017/05/java-midi-3ec5.html
//https://news.mynavi.jp/article/20080225-makingmidi/9
