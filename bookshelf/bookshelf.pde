
import java.util.HashMap;
import java.util.Map;
import java.awt.*;
import java.awt.Canvas;
//import java.awt.image.BufferedImage;
import javax.swing.*;
import java.sql.*;
import processing.video.*; // Videoを扱うライブラリをインポート
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
JTextField fieldisbn,fieldsearch;
JTextArea area;


int myCurrentIndex = 0;
String[] tokens;
String[] book;
String title;
Boolean confirmyn= false;
PImage image0, image1, image2, image3, image4, image5, image6, image7;
boolean error = false;
String isbn="";
String simput= "";
int ddlist ;
String isbnfromtext="9784065132500";
boolean readisbn= false;
boolean inputcapture = false;
StringList searchresult;
int page = 1;
int clicktime;
boolean timer = false;
void settings() {
  size(1920, 1080);
}

void setup() {
  second = new SecondApplet(this);
  background(255);
  PFont font = createFont("MS Gothic", 36, true);//文字の作成
  textFont (font);
  textSize(36);
  cp5 = new ControlP5(this);
  tokens = new String[10];
  tokens[0] = "ISBN";
  tokens[1] = "TITLE";
  tokens[2] = "AUTHOR";

  List l = Arrays.asList(tokens[0], tokens[1],tokens[2]);

  cp5.addScrollableList("search")
    .setPosition(1420, 100)
    .setSize(400, 200)
    .setBarHeight(20)
    .setItemHeight(20)
    .addItems(l)
    .setBarHeight(50)
    .setItemHeight(50)
     //.setType(ScrollableList.LIST) // currently supported DROPDOWN and LIST
    ;
    
    Button = new ControlP5(this);
  Button.addButton("searchitems")
    .setLabel("search")//テキスト
    .setPosition(1590, 320)
    .setSize(80, 40)
    .setColorActive(color(50, 40)) //押したときの色
    .setColorBackground(color(0)) //通常時の色
    .setColorForeground(color(150)) //マウスを乗せた時の色
    .setColorCaptionLabel(color(255)); //テキストの色
    
    //showbooks();
   

  Canvas canvas = (Canvas) surface.getNative();
  pane = (JLayeredPane) canvas.getParent().getParent();

  // 1行のみのテキストボックスを作成
  fieldsearch = new JTextField();
  fieldsearch.setBounds(1420, 320, 150, 30);
  pane.add(fieldsearch);
  loadbooks();
  
}

void draw() {
  background(255);
  //if (myCurrentIndex >= 0) {
  //   text(tokens[myCurrentIndex], 200, 40); 
  //}
  
  //println(isbnfromtext);
} //<>//

void search(int n) {
  ddlist = n;
  println(n);  
  myCurrentIndex = n;
}
void searchitems(){
  simput = fieldsearch.getText();
  loadbooks();
}
void loadbooks() {
  searchresult = new StringList();
   String like = "title";
   if (ddlist == 0){
     like = "isbn";
     println("ddlist == 0");
   }else if (ddlist == 1){
    like = "title";
    println("ddlist = 1");
  }else if (ddlist == 2){
    like = "author";
    println("ddlist = 2");
  }else{
    return;
  }
  String dbName = sketchPath("test.db");
  println("dbName = test.db");
    try {
      //JDBCドライバを明示的にロードする
      Class.forName("org.sqlite.JDBC");
      //DBをOPENする
      connection = DriverManager.getConnection( "jdbc:sqlite:" + dbName );
      Statement statement = connection.createStatement();
      statement.setQueryTimeout(30); // set timeout to 30 sec
      println("search");
      println("SELECT isbn,title,author FROM book WHERE "+like+" LIKE '%"+simput+"%' ORDER BY isbn ASC;");
      ResultSet rs = statement.executeQuery("SELECT isbn,title,author FROM book WHERE "+like+" LIKE '%"+simput+"%';");
      while (rs.next()) { // ResultSetに読み込まれたデータを表示する
        // read the result set
        String format = "isbn:%s, title: %s, author: %s";
        println(String.format(format, rs.getString("isbn"),rs.getString("title"), rs.getString("author")));
        searchresult.append(rs.getString("isbn"));
        //print("name: " + rs.getString("name"));
        //println(", id: " + rs.getInt("id"));
        println("成功");
      }
      searchresult.sort();
      println(searchresult);
      //println(searchresult.size());
      //println(searchresult.get(0));
    } 
    catch( ClassNotFoundException e) {
      e.printStackTrace();
      println("エラー　ClassNotFoundException");
    } 
    catch( SQLException e ) {
      e.printStackTrace();
      println("エラー　SQLException");
    }finally {
      //DBをクローズする
      dbClose();
    }
    println("処理が終了しました");
    imgdownload();
    println("ロード完了");
    return;
  }
  void showimgs(){
    println("画像描画開始");
    image(image0,20,20);
    image(image1,120,20);
    image(image2,20,20);
    image(image3,20,20);
    image(image4,20,20);
    image(image5,20,20);
    image(image6,20,20);
    image(image7,20,20);
  }
  void imgdownload(){
    for(int i = 0; i < searchresult.size(); i ++){
    try {
      URL url = new URL("https://cover.openbd.jp/"+searchresult.get(i)+".jpg");
      HttpURLConnection conn =
          (HttpURLConnection) url.openConnection();
      conn.setAllowUserInteraction(false);
      conn.setInstanceFollowRedirects(true);
      conn.setRequestMethod("GET");
      conn.connect();

      int httpStatusCode = conn.getResponseCode();
      if (httpStatusCode != HttpURLConnection.HTTP_OK) {
        throw new Exception("HTTP Status " + httpStatusCode);
      }

      String contentType = conn.getContentType();
      System.out.println("Content-Type: " + contentType);

      // Input Stream
      DataInputStream dataInStream
          = new DataInputStream(
          conn.getInputStream());

      // Output Stream
      DataOutputStream dataOutStream
          = new DataOutputStream(
          new BufferedOutputStream(
              new FileOutputStream("C:/WorkSpace/processing/git/processing_study/bookshelf/data/"+searchresult.get(i)+".jpg")));

      // Read Data
      byte[] b = new byte[4096];
      int readByte = 0;

      while (-1 != (readByte = dataInStream.read(b))) {
        dataOutStream.write(b, 0, readByte);
      }

      // Close Stream
      dataInStream.close();
      dataOutStream.close();

    } catch (FileNotFoundException e) {
      e.printStackTrace();
    } catch (ProtocolException e) {
      e.printStackTrace();
    } catch (MalformedURLException e) {
      e.printStackTrace();
    } catch (IOException e) {
      e.printStackTrace();
    } catch (Exception e) {
      System.out.println(e.getMessage());
      e.printStackTrace();
    }
    }
  }
  




//http://mslabo.sakura.ne.jp/WordPress/make/processing%E3%80%80%E9%80%86%E5%BC%95%E3%81%8D%E3%83%AA%E3%83%95%E3%82%A1%E3%83%AC%E3%83%B3%E3%82%B9/sqlite%E3%82%92%E4%BD%BF%E3%81%86%EF%BC%88%E6%A4%9C%E7%B4%A2%EF%BC%89/
//https://qiita.com/hoshi_shiitake/items/48d34491fb494ae1ca71
