class SQL {
  String sql;

  SQL(String _s) {
    sql = _s;
  }
  void Runsql() {
    if (sql == "" || sql == null) {
      return;
    }
    String dbName = sketchPath("test.db");
    try {
      //JDBCドライバを明示的にロードする
      Class.forName("org.sqlite.JDBC");
      //DBをOPENする
      connection = DriverManager.getConnection( "jdbc:sqlite:" + dbName );
      Statement statement = connection.createStatement();
      statement.setQueryTimeout(30); // set timeout to 30 sec
      statement.executeUpdate(sql);
    } 
    catch( ClassNotFoundException e) {
      e.printStackTrace();
    } 
    catch( SQLException e ) {
      e.printStackTrace();
      println("追加できませんでした");
    }
    finally {
      //DBをクローズする
      dbClose();
    }
    println("処理が終了しました");
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
}
