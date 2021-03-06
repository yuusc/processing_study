class SecondApplet extends PApplet {
  PApplet parent;
  SecondApplet(PApplet _parent) {
    super();
    // set parent
    this.parent = _parent;
    //// init window
    try {
      java.lang.reflect.Method handleSettingsMethod =
        this.getClass().getSuperclass().getDeclaredMethod("handleSettings", null);
      handleSettingsMethod.setAccessible(true);
      handleSettingsMethod.invoke(this, null);
    } 
    catch (Exception ex) {
      ex.printStackTrace();
    }

    PSurface surface = super.initSurface();
    surface.placeWindow(new int[]{0, 0}, new int[]{0, 0});

    this.showSurface();
    this.startSurface();
  }
  JPanel panel = new JPanel();    //パネルを作成
  BoxLayout layout = new BoxLayout( panel, BoxLayout.Y_AXIS );    //メッセージのレイアウトを決定

  int dialogyn;



  void settings() {
    size(1000, 500);
  }

  void setup() {
    panel.setLayout(layout);    //panelにlayoutを適用
    panel.add( new JLabel( "本を追加しますか？" ) );    //メッセージ内容を文字列のコンポーネントとしてパネルに追加
    String[] cameras = Capture.list();
    camera = new Capture(this, 640, 480, cameras[0]);
    camera.start();
    Canvas canvas = (Canvas) surface.getNative();
    pane = (JLayeredPane) canvas.getParent().getParent();
    fieldisbn = new JTextField();
    fieldisbn.setBounds(680, 10, 150, 30);
    pane.add(fieldisbn);
    text("ISBN", 650, 30);
    area = new JTextArea();
    area.setLineWrap(true);
    area.setWrapStyleWord(true);
    JScrollPane scrollPane = new JScrollPane(area);
    scrollPane.setBounds(650, 50, 300, 100);
    pane.add(scrollPane);
    Button = new ControlP5(this);
    Button.addButton("inputisbn")
      .setLabel("add")//テキスト
      .setPosition(840, 10)
      .setSize(50, 30)
      .setColorActive(color(0, 40)) //押したときの色
      .setColorBackground(color(255)) //通常時の色
      .setColorForeground(color(255)) //マウスを乗せた時の色
      .setColorCaptionLabel(color(0)); //テキストの色

    Button.addButton("capture")
      .setLabel("capture")//テキスト
      .setPosition(890, 10)
      .setSize(50, 30)
      .setColorActive(color(0, 40)) //押したときの色
      .setColorBackground(color(255)) //通常時の色
      .setColorForeground(color(255)) //マウスを乗せた時の色
      .setColorCaptionLabel(color(0)); //テキストの色

    Button.addButton("run")
      .setLabel("run")//テキスト
      .setPosition(840, 160)
      .setSize(50, 30)
      .setColorActive(color(0, 40)) //押したときの色
      .setColorBackground(color(255)) //通常時の色
      .setColorForeground(color(255)) //マウスを乗せた時の色
      .setColorCaptionLabel(color(0)); //テキストの色

    fill(255);
    noStroke();
    rect(650, 200, 300, 100);
    fill(0);
    text("book:isbn (TEXT), title (TEXT), author (TEXT), publisher (TEXT), pubdate (TEXT), cover (TEXT), series (TEXT), PRIMARY KEY(isbn)", 660, 200, 300, 50);
    text("date:isbn (TEXT), purchase (TEXT), finish (TEXT),UNIQUE(isbn),FOREIGN KEY(isbn) REFERENCES book(isbn)", 660, 250, 300, 50);
    text("SQLite3", 760, 180);
    noFill();
  }

  void draw() {

    isbnfromtext = fieldisbn.getText();
    if (readisbn) {
      readisbn = false;
      isbn = isbnfromtext;
      getjson();
      if (error == false) {
        //image(pImage, 0, 0);
        dialogyn = JOptionPane.showConfirmDialog( 
          null, //親フレームの指定
          panel, //パネルの指定
          title, //タイトルバーに表示する内容
          JOptionPane.YES_NO_OPTION, //オプションタイプをYES,NOにする
          JOptionPane.INFORMATION_MESSAGE   //メッセージタイプをInformationにする
          );
      }


      if (confirmyn == true) {
        if ( dialogyn == 0 ) {
          confirmyn = false;
          println("addbook");
          addbook();
        } else if ( dialogyn == 1 ) {
          confirmyn = false;
          println("book = null");
          book = null;
          return;
        }
      }
    }



    if (camera.available() == true) {
      camera.read();
      image(camera, 0, 0);
    }
    if (inputcapture) {
      inputcapture = false;
      barcode();
      if (error == false) {
        //image(pImage, 0, 0);
        dialogyn = JOptionPane.showConfirmDialog( 
          null, //親フレームの指定
          panel, //パネルの指定
          title, //タイトルバーに表示する内容
          JOptionPane.YES_NO_OPTION, //オプションタイプをYES,NOにする
          JOptionPane.INFORMATION_MESSAGE   //メッセージタイプをInformationにする
          );
      }
      if (confirmyn == true) {
        if ( dialogyn == 0 ) {
          confirmyn = false;
          println("addbook");
          addbook();
        } else if ( dialogyn == 1 ) {
          confirmyn = false;
          println("book = null");
          book = null;
          return;
        }
      }
    } else {
      error = false;
      return;
    }
  }
  void inputisbn() {
    readisbn = true;
  }
  void capture() {
    inputcapture = true;
  }
  void run() {
    SQL runsql = new SQL(area.getText());
    runsql.Runsql();
  }
  void barcode() {
    //バーコード画像取得
    //pImage  = loadImage("ean13Sample.png");

    Reader = new EANReader(this);

    //isbn = Reader.decode(pImage, false, true );
    isbn = Reader.decode(camera, false, true );
    //char isbninitial =isbn.charAt(1);
    //if(isbninitial != 9){
    //  return;
    //}
    println(isbn);
    if (isbn== null) {
      error = true;
      return;
    }
    getjson();
  }
}
void getjson() {

  String URL= "https://api.openbd.jp/v1/get?isbn=";
  String title, author, publisher, pubdate, cover, series;
  JSONArray jarray;
  if ( isbn != null ) {
    fieldisbn.setText(isbn);
    jarray= loadJSONArray(URL+isbn);
    try {
      jarray.getJSONObject(0).getJSONObject("summary");
    }
    catch(RuntimeException e) {
      println("この本の情報は存在しませんでした");
      error = true;
      return;
    }

    println(jarray);
    JSONObject job = jarray.getJSONObject(0);
    JSONObject jobsummary = job.getJSONObject("summary");
    //println(jobsummary);
    isbn = jobsummary.getString("isbn");
    title =jobsummary.getString("title");
    author =jobsummary.getString("author");
    publisher =jobsummary.getString("publisher");
    pubdate =jobsummary.getString("pubdate");
    cover =jobsummary.getString("cover");
    series =jobsummary.getString("series");
    book = new String[]{isbn, title, author, publisher, pubdate, cover, series};
    confirmyn = true;
  }
}

void addbook() {
  println(book[0]);
  String dbName = sketchPath("test.db");
  try {
    //JDBCドライバを明示的にロードする
    Class.forName("org.sqlite.JDBC");
    //DBをOPENする
    connection = DriverManager.getConnection( "jdbc:sqlite:" + dbName );
    Statement statement = connection.createStatement();
    statement.setQueryTimeout(30); // set timeout to 30 sec

    //statement.executeUpdate("drop table if exists book");
    // 新たにTableを作成するためのSQL文を送信
    //statement.executeUpdate("create table book(title, author, series, publisher, pubdate, cover)");

    // 作成したTableにデータをInsertしてみる
    statement.executeUpdate("insert into book values('"+book[0]+"','"+book[1]+"','"+book[2]+"','"+book[3]+"','"+book[4]+"','"+book[5]+"','"+book[6]+"')");

    // Tableの中身をすべてSelectし、Resultsetクラスに読み込む
    ResultSet rs = statement.executeQuery("select * from book");
    while (rs.next()) { // ResultSetに読み込まれたデータを表示する
      // read the result set
      String format = "isbn: %s,title: %s, author: %s,publisher : %s, pubdate : %s, cover : %s,series: %s";
      println(String.format(format, rs.getString("isbn"), rs.getString("title"), rs.getString("author"), rs.getString("publisher"), rs.getString("pubdate"), rs.getString("cover"), rs.getString("series")));
      //print("name: " + rs.getString("name"));
      //println(", id: " + rs.getInt("id"));
    }
  } 
  catch( ClassNotFoundException e) {
    e.printStackTrace();
  } 
  catch( SQLException e ) {
    e.printStackTrace();
    println("追加できませんでした");
  }
  finally {
    imgdownload();
    //DBをクローズする
    dbClose();
  }
  println("処理が終了しました");
}
void imgdownload() {
  try {
    URL url = new URL("https://cover.openbd.jp/"+isbn+".jpg");
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
      new FileOutputStream("C:/WorkSpace/processing/git/processing_study/bookshelf/data/"+isbn+".jpg")));

    // Read Data
    byte[] b = new byte[4096];
    int readByte = 0;

    while (-1 != (readByte = dataInStream.read(b))) {
      dataOutStream.write(b, 0, readByte);
    }

    // Close Stream
    dataInStream.close();
    dataOutStream.close();
  } 
  catch (FileNotFoundException e) {
    e.printStackTrace();
  } 
  catch (ProtocolException e) {
    e.printStackTrace();
  } 
  catch (MalformedURLException e) {
    e.printStackTrace();
  } 
  catch (IOException e) {
    e.printStackTrace();
  } 
  catch (Exception e) {
    System.out.println(e.getMessage());
    e.printStackTrace();
  }
  fill(255);
  rect(0, 0, width, height);
  return;
}
void dbClose() {
  try {
    if (connection != null) {
      connection.close();
    }
  } 
  catch (SQLException e) {
    e.printStackTrace();
  }
}
