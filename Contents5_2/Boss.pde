class Boss {
  private int tx, ty;
  private double dx, dy;
  private long routine = 0;
  Boss(int x, int y) {
    tx = x;
    ty = y;
    dx = random(-100.0,100.0);
    dy = random(-100.0,100.0);
  }
  void move(){
    tx += dx;
    ty += dy;
    if(tx < 0 || tx > width){
      dx=-dx;
    }
    if(ty < 0 || ty > height){
      dy=-dy;
    }
  }
  void emit(){
    routine++;
    if(routine % 10 == 0){
      move();
    }
    if(routine % 30 == 0){
      danmaku.addAll(this.shot());
    }
  }
  ArrayList<Bullet> shot() {
    ArrayList<Bullet> danmaku = new ArrayList();
    for (int i = 0; i < 360; i+= 10) { 
      double rad = radians(i);
      danmaku.add(new Bullet(this.tx, this.ty, 10, Math.sin(rad), Math.cos(rad)));
    }
    return danmaku;
  }
}
