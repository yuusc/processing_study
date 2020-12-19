class Detail {
  String isbn;
  Detail(String _i) {
    isbn = _i;
  }

  void getdetail() {
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
      detailarr = new String[]{isbn, title, author, publisher, pubdate, cover, series};
      confirmyn = true;
    }
  }
  void showdetail() {
    image(bkbd, 1140, 450);
    noStroke();
    //println(detailarr);
    fill(255);
    text("isbn:"+detailarr[0], 1170, 520);
    text("タイトル:"+detailarr[1], 1170, 545);
    text("著者:"+detailarr[2], 1170, 570);
    text("出版社:"+detailarr[3], 1170, 595);
    text("出版日:"+detailarr[4], 1170, 620);
    text("シリーズ:"+detailarr[6], 1170, 645);
    text("場所:", 1170, 670);
    text("購入日:", 1170, 695);
    text("読了日:", 1170, 720);
    text("感想:", 1170, 745);
    println(csvdetail.get(isbn));
    if (csvdetail.get(isbn)==null) {
      location = "";
      impression = "";
      fill(255);
      text("未入力", 1270, 670);
      text("未入力", 1270, 745);
      noFill();
    } else {

      List<String> csvlist = new ArrayList<String>();
      csvlist=csvdetail.get(isbn);
      location=csvlist.get(0);
      impression = csvlist.get(1);
      fill(255);
      text(location, 1270, 670);
      text(impression, 1270, 745);
      noFill();
      //println(csvdetail.get(detailarr[0]));
      //fieldlocation.set(location);
    }
    if (datedetail.get(isbn)== null) {
      purchase = "";
      finish = "";
      fill(255);
      text("未入力", 1270, 695);
      text("未入力", 1270, 720);
      noFill();

      purfin = true;
    } else {
      List<String> datelist = new ArrayList<String>();
      datelist = datedetail.get(isbn);
      purchase = datelist.get(0);
      finish = datelist.get(1);
      fill(255);
      text(purchase, 1270, 695);
      text(finish, 1270, 720);
      noFill();
      purfin = false;
    }
    if (purfin == false) {
      fill(255, 0, 0);
      text("編集できません", 1620, 695);
      text("編集できません", 1620, 720);
    }
  }
}
