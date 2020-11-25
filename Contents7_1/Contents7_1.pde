int enemy_x, enemy_y;  //敵機のx,y座標
int enemy_speed;  //敵機の速さ
int hp = 1;  //自機の体力
  
void setup(){
  size(1000,1000);  //画面サイズ
  //enemy_x = int(random(width));  //widthは画面の幅を表すシステム変数
  //enemy_y = -50;
  enemy_x =-50;
  enemy_y = int(random(width));
  enemy_speed = int(random(8,15));  //速さの初期化。15は含まないので8～14になる
}
  
void draw(){
  background(0);  //黒の背景　255は白の背景
  ellipse(mouseX,mouseY,30,30);  //自機
  ellipse(enemy_x,enemy_y,50,50);  //敵機
  //enemy_y += enemy_speed;  //座標を増やす
    enemy_x += enemy_speed;
  //当たり判定
  if((mouseX+15>enemy_x-25 && mouseX-15<enemy_x+25)
    && (mouseY+15>enemy_y-25 && mouseY-15<enemy_y+25)){
      enemy_x=int(random(width));
      enemy_y=-50;
      enemy_speed = int(random(8,15));
      hp-=1;
  }
    
  //自機の撃墜
  if(hp<=0){
   textSize(100); //テキストサイズを指定
   text("Game Over",250,500); //座標250,500にGame Overを表示 
  }
    
  //敵機が画面より下に行ったら
  //if(enemy_y-25>height){ //heightは画面の高さを表すシステム変数
  //   enemy_x=int(random(width));
  //   enemy_y=-50;
  //   enemy_speed = int(random(8,15));        
  //}
  if(enemy_x-25>width){
    enemy_y=int(random(height));
    enemy_x=-50;
    enemy_speed = int(random(8,15));
   }
}
