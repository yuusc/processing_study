class Bullet {

  private double tx, ty;
  private final double tr;
  private double dx, dy;
  private boolean is_alive = true;
  Bullet(double x, double y, double r, double temp_dx, double temp_dy ) {
    tx = x;
    ty = y;
    tr = r;
    dx = temp_dx;
    dy = temp_dy;
  }
  boolean isAlive(){
    return is_alive;
  }
  void update() { 
    tx = tx+dx;
    ty = ty+dy;
    if(Math.min(tx, ty) < 0){
      is_alive = false;
      return ;
    }
    if(tx > width || ty > height){
      is_alive = false;
      return ;
    }
    if(tx < 170 && tx > 150 && ty>300 && ty<320){
      is_alive = false;
      player.play();
    player.rewind();
      return ;
    }

fill(31,186,255);
    stroke(255);

    ellipse((float)tx, (float)ty, (float)tr, (float)tr);
  }
}
