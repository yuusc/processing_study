// 12/15追記　コメントを追加　以前のコメントの削除(長すぎるため) //<>//
// SQLiteを使用　Search,SecondApplet内にもSQLを扱う部分があるが他とは取り扱いが異なるため要注意
// data内の画像は必要以上に削除しないこと　正常に動作しなくなる可能性がある　どうにかすべきだとは思うが毎回ダウンロードするわけにはいかない．毎回ダウンロードするとダウンロードが完了する前に他のコードが実行されてしまい空欄が出てしまう&フリーズが多発する．こわいお
// 現状ではテスト用のDBを使用している．本番環境ではString dbName = sketchPath("test.db");のファイル名を修正すること
// 書籍の除去とdateテーブルの操作にはSQLの実行エリアより行うこと．SQLiteより直接操作も可能
// csvファイルは現状では手書き追記・修正のみ
// bookshelf.pde , SecondApplet.pdeによってウィンドウの描画　登録ウィンドウでは稀にカメラが起動しないことがあるためその時はリロードをする
// バーコードの読み取りができなかった場合，30~60秒ほどカメラがフリーズする．待機するかリロードで直る
// 12/19追記　SQL周辺を修正，コード量の削減と安定性の改善
// 終了時に出る警告が消せない．>> WARNING: no real random source present !

import java.util.TreeMap;
import java.util.Map;
import java.awt.*;
import java.awt.Canvas;
import javax.swing.*;
import java.sql.*;
import processing.video.*;
import ZxingP5.*;
import controlP5.*;
import java.util.List;
import java.util.Arrays;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;

SecondApplet second;
Connection connection = null;
EANReader Reader;
Capture camera; // ライブカメラの映像をあつかうCapture型の変数
ControlP5 cp5;
ControlP5 Button;
JLayeredPane pane;
JTextField fieldisbn, fieldsearch;
JTextArea area;



int myCurrentIndex = 0;
String[] tokens;
String[] book;
String title;
Boolean confirmyn= false;
PImage image0, image1, image2, image3, image4, image5, image6, image7, wood, wood2, woodv, bkbd;
boolean error = false;
String isbn="";
String simput= "";
int ddlist ;
String isbnfromtext="9784065132500";
boolean readisbn= false;
boolean inputcapture = false;
StringList searchresult;
StringList searchdate;
int page = 1;
int clicktime;
boolean timer = false;
int pagemax;
boolean setup = true;
String selectitem="";
String sql;
Map<String, String> searchtitle = new TreeMap<String, String>();
Map<String, List> csvdetail = new TreeMap<String, List>();
Map<String, List> datedetail = new TreeMap<String, List>();
boolean keypress = false;
String[] detailarr;
int allpage;
boolean selectbackcolor = false;
int indicatorx, indicatory = 0;
int predx= 35;
int predy = 470;
String location, purchase, finish, impression;
boolean purfin = false;
int hit;
String like="";
void settings() {
  size(1920, 1080);
}

void setup() {
  second = new SecondApplet(this);
  background(255);
  wood = loadImage("wood.png");
  wood2 = loadImage("wood2.png");
  woodv = loadImage("woodv.png");
  bkbd = loadImage("blackboard.png");
  PFont font = createFont("MS Gothic", 20, true);//文字の作成
  textFont (font);
  textSize(20);




  cp5 = new ControlP5(this);
  tokens = new String[10];
  tokens[0] = "ISBN";
  tokens[1] = "TITLE";
  tokens[2] = "AUTHOR";

  List l = Arrays.asList(tokens[0], tokens[1], tokens[2]);

  cp5.addScrollableList("searchindex")
    .setPosition(1420, 100)
    .setSize(400, 200)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(l)
    .setBarHeight(50)
    .setItemHeight(50)
    .setColorActive(color(181, 113, 79)) //押したときの色
    .setColorBackground(color(155, 90, 39)) //通常時の色
    .setColorForeground(color(135, 68, 41)) //マウスを乗せた時の色
    .setColorCaptionLabel(color(255)) //テキストの色

    //.setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
    ;

  Button = new ControlP5(this);
  Button.addButton("searchitems")
    .setLabel("search")//テキスト
    .setPosition(1590, 320)
    .setSize(80, 40)
    .setColorActive(color(240, 113, 79, 40)) //押したときの色
    .setColorBackground(color(191, 50, 24, 50)) //通常時の色
    .setColorForeground(color(191, 50, 24, 20)) //マウスを乗せた時の色
    .setColorCaptionLabel(color(255)); //テキストの色

  //showbooks();


  Canvas canvas = (Canvas) surface.getNative();
  pane = (JLayeredPane) canvas.getParent().getParent();

  // 1行のみのテキストボックスを作成
  fieldsearch = new JTextField();
  fieldsearch.setBounds(1420, 320, 150, 30);
  pane.add(fieldsearch);




  loadbooks setbooks = new loadbooks(0, "");
  setbooks.load();
  showimages();
  allpage = ceil(searchresult.size()/8)+1;
  hit = searchresult.size();
  text("ヒット件数:"+hit, 1140, 200);
  setup = false;
}

void draw() {
  textSize(40);
  fill(255);
  rect(440, 10, 180, 50);
  fill(0);
  text("書籍一覧", 440, 50);
  textSize(20);
  fill(0);
  text("ヒット件数:"+hit, 1140, 200);
  text("検索条件:"+like+"=%"+simput+"%", 1140, 180);
  noFill();
  noStroke();
  fill(255);

  rect(1420, 100, 400, 200);
  //background(255);
  //showimages();
  //if (myCurrentIndex >= 0) {
  //   text(tokens[myCurrentIndex], 200, 40); 
  //}
  //println(isbnfromtext);
  image(wood, 0, 470, 1080, 25);
  image(wood2, 0, 940, 1080, 25);
  image(woodv, 1079, 0, 36, 1080);
  //fill(180,102,65,80);
  ////triangle(0,495,20,505,20,495);
  // rect(0,495,1079,10);
  ////triangle(0,985,20,995,20,985);
  //rect(0,985,1079,10);
  noFill();
  stroke(0);
  line(0, 595, 1079, 595);
  //line(270,0,270,980);
  //line(540,0,540,980);
  //line(810,0,810,980);
  //line(1080,0,1080,980);
  //println(mouseX,mouseY);
  rect(1140, 230, 50, 50);
  rect(1300, 230, 50, 50);
  fill(0);
  triangle(1150, 255, 1180, 240, 1180, 270);
  triangle(1310, 240, 1310, 270, 1340, 255);
  text(page+"ページ目/全"+allpage+"ページ", 1160, 310);
  fill(255, 0, 0);
  noStroke();
  if (selectbackcolor == true) {
    rect(indicatorx, indicatory, 200, 20);
  } else {
    image(bkbd, 1140, 450);
  }
  noStroke();
  noFill();
  if (mousePressed == true) {
    if (keypress == false) {
      keypress = true;
      println("keypress = true");

      if (mouseX>1140 && mouseX < 1190 && mouseY > 230 && mouseY < 280 && page > 1) {
        page --;

        detailarr = null;
        showimages();
        selectbackcolor = false;
        return;
      } else if (mouseX>1300 && mouseX < 1350 && mouseY > 230 && mouseY < 280 && page < allpage) {
        page ++;
        detailarr = null;
        selectbackcolor = false;
        showimages();
      }

      try {
        noStroke();
        if (mouseY<595) {
          if (mouseX<270) {
            selectitem = searchresult.get((page-1)*8+0);
            selectbackcolor = true;
            indicatorx = 35;
            indicatory = 140;
            fill(255);
            rect(predx, predy, 200, 20);
            noFill();
            predx = indicatorx;
            predy = indicatory;
          } else if (mouseX>270 && mouseX < 540) {

            selectitem = searchresult.get((page-1)*8+1);
            selectbackcolor = true;
            indicatorx =305;
            indicatory = 140;
            fill(255);
            rect(predx, predy, 200, 20);
            noFill();
            predx = indicatorx;
            predy = indicatory;
          } else if (mouseX>540 && mouseX < 810) {

            selectitem = searchresult.get((page-1)*8+2);
            selectbackcolor = true;
            indicatorx =575;
            indicatory = 140;
            fill(255);
            rect(predx, predy, 200, 20);
            noFill();
            predx = indicatorx;
            predy = indicatory;
          } else if (mouseX>810 && mouseX < 1080) {

            selectitem = searchresult.get((page-1)*8+3);
            selectbackcolor = true;
            indicatorx =845;
            indicatory = 140;
            fill(255);
            rect(predx, predy, 200, 20);
            noFill();
            predx = indicatorx;
            predy = indicatory;
          }
        } else {
          if (mouseX<270) {

            selectitem = searchresult.get((page-1)*8+4);
            selectbackcolor = true;
            indicatorx =35;
            indicatory = 605;
            fill(255);
            rect(predx, predy, 200, 20);
            noFill();
            predx = indicatorx;
            predy = indicatory;
          } else if (mouseX>270 && mouseX < 540) {

            selectitem = searchresult.get((page-1)*8+5);
            selectbackcolor = true;
            indicatorx =305;
            indicatory = 605;
            fill(255);
            rect(predx, predy, 200, 20);
            noFill();
            predx = indicatorx;
            predy = indicatory;
          } else if (mouseX>540 && mouseX < 810) {

            selectitem = searchresult.get((page-1)*8+6);
            selectbackcolor = true;
            indicatorx =575;
            indicatory = 605;
            fill(255);
            rect(predx, predy, 200, 20);
            noFill();
            predx = indicatorx;
            predy = indicatory;
          } else if (mouseX>810 && mouseX < 1080) {

            selectitem = searchresult.get((page-1)*8+7);
            selectbackcolor = true;
            indicatorx =845;
            indicatory = 605;
            fill(255);
            rect(predx, predy, 200, 20);
            noFill();
            predx = indicatorx;
            predy = indicatory;
          }
        }
        stroke(0);
        println(selectitem);
        Detail detail = new Detail(selectitem);
        detail.getdetail();
        detail.showdetail();
      }
      catch(Exception e) {
        selectitem = null;
        //e.printStackTrace();
      }
    }
  }
  if (mousePressed == false) {
    keypress = false;
  }
}

void searchindex(int n) {
  ddlist = n;
  println(n);  
  myCurrentIndex = n;
}
void searchitems() {
  simput = fieldsearch.getText();
  loadbooks search = new loadbooks(ddlist, simput);
  search.load();
}





void showimages() {
  String imageurl;
  String imageisbn;
  fill(255);
  noStroke();
  rect(0, 0, width, height);
  rect(predx, predy, 200, 50);
  fill(0);
  if (searchresult.size()-8*(page-1)<8) {
    if (searchresult.size()-8*(page-1)==0) {
      text("検索条件に該当する書籍はありません．", 440, 440);
    } else {
      pagemax = searchresult.size();
    }
  } else {
    pagemax = 8;
  }
  for (int i = 0; i < pagemax; i ++) {
    println((page-1)*8+i);
    try {
      //println(searchresult.get((page-1)*8+i)+".jpg");
      //image0 = image(searchresult.get(i)+".jpg",20.0,20.0);
      imageurl = searchresult.get((page-1)*8+i)+".jpg";
      image0 = loadImage(imageurl);
      imageisbn = searchresult.get((page-1)*8+i);
      println(searchtitle.get(imageisbn));
      if (i < 4) {
        image(image0, 30+270*i, 180);
        text(searchtitle.get(imageisbn), 30+270*i, 510, 230, 100);
      } else {
        image(image0, 30+270*(i-4), 630);
        text(searchtitle.get(imageisbn), 30+270*(i-4), 970, 230, 100);
      }
    }
    catch(Exception e) {
      //e.printStackTrace();
    }
  }
}
