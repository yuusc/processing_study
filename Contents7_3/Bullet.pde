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
    if (timea+60<=time){
      if((mouseX+5>tx-5 && mouseX-5 < tx+5)&&(mouseY +5 > ty-5 && mouseY -5 < ty +5 )){
      is_alive = false;
      SE1.play();
    SE1.rewind();
        SE1.play(0);  //衝突音の再生
        hp-=1;
        timea = time;
      return ;
    }
    
     
    }
if(key == ENTER){
       is_alive = false;
       return;
     }
    //fill(31,186,255);
    //stroke(255);
    int bulletcolor = int(random(1,4));
    switch(bulletcolor){
    case 1:
    image(bulletimg1,(float)tx-13, (float)ty-13,30,30);
    break;
    case 2:
    image(bulletimg2,(float)tx-13, (float)ty-13,30,30);
    break;
    case 3:
    image(bulletimg3,(float)tx-13, (float)ty-13,30,30);
    break;
    
    }
    if (debug == true){
      ellipse((float)tx, (float)ty, (float)tr, (float)tr);
    }
    //noFill();
    
  }
}
