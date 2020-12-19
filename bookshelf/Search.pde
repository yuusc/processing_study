class loadbooks {
  int ddlist;
  String sinput;

  loadbooks(int _d, String _s) {
    ddlist = _d;
    sinput = _s;
  }

  void load() {
    page = 1;
    searchresult = new StringList();

    like = "title";
    if (ddlist == 0) {
      like = "isbn";
      println("ddlist == 0");
    } else if (ddlist == 1) {
      like = "title";
      println("ddlist = 1");
    } else if (ddlist == 2) {
      like = "author";
      println("ddlist = 2");
    } else {
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
        println(String.format(format, rs.getString("isbn"), rs.getString("title"), rs.getString("author")));
        searchtitle.put(rs.getString("isbn"), rs.getString("title"));
        println("st");
        searchresult.append(rs.getString("isbn"));
        println("sr");

        //print("name: " + rs.getString("name"));
        //println(", id: " + rs.getInt("id"));
        println("成功");
      }
      searchresult.sort();
      println("SELECT isbn,purchase,finish FROM date WHERE "+like+" LIKE '%"+simput+"%';");
      ResultSet rs2 = statement.executeQuery("SELECT isbn,purchase,finish FROM date WHERE "+like+" LIKE '%"+simput+"%';");
      while (rs2.next()) { // ResultSetに読み込まれたデータを表示する
        // read the result set
        String format = "isbn:%s,purchase:%s, finish: %s";
        println(String.format(format, rs2.getString("isbn"), rs2.getString("purchase"), rs2.getString("finish")));

        List<String> datelist = new ArrayList<String>();
        datelist.add(rs2.getString("purchase"));  //
        datelist.add(rs2.getString("finish"));
        datedetail.put(rs2.getString("isbn"), datelist);
        println("成功");
      }


      //println(searchresult);
    }
    catch( ClassNotFoundException e) {
      e.printStackTrace();
      println("エラー　ClassNotFoundException");
    } 
    catch( SQLException e ) {
      e.printStackTrace();
      println("エラー　SQLException");
    }
    finally {
      //DBをクローズする
      dbClose();
      allpage = ceil(searchresult.size()/8)+1;
      hit = searchresult.size();
      fill(0);
      text("ヒット件数:"+hit, 1140, 200);
      text("検索条件:"+like+"="+simput, 1140, 180);
      noFill();
    }
    println("処理が終了しました");
    loadcsv();
    if (setup == true) {
      imgdownload();
    } else {
      showimages();
    }
    println("ロード完了");
    return;
  }
  void imgdownload() {
    for (int i = 0; i < searchresult.size(); i ++) {
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
      showimages();
      return;
    }
  }
  void loadcsv() {
    Table csvData = loadTable("detail.csv", "csv");
    try {
      for (int i = 0; i < csvData.getRowCount(); i++) {
        List<String> csvlist = new ArrayList<String>();
        csvlist.add(csvData.getString(i, 1));
        csvlist.add(csvData.getString(i, 2));
        csvdetail.put(csvData.getString(i, 0), csvlist);
      }
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
}
