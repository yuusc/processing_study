int enemy_x[]=new int[10],enemy_y[]=new int[10];  //敵機のx,y座標
int enemy_speed[]=new int[10];  //敵機の速さ
int hp = 1;  //自機の体力
String scene = "title";  //シーンを指定する文字列
 
void setup(){
  size(1000,1000);  //画面サイズ
   
  for(int i=0;i<10;i++){
    enemy_x[i]=int(random(width)); //widthは画面の幅を表すシステム変数
    enemy_y[i]=-50;
    enemy_speed[i] = int(random(2,10));  //速さをの初期化
    ((java.awt.Canvas) surface.getNative()).requestFocus();
  }
}
 
void draw(){  
  //scene変数の番号によって関数呼び出し
  switch(scene){
    case "title":
      title_scene();
      break;
    case "play":
      play_scene();
      break;
    case "gameover":
      gameover_scene();
      break;
    case "pause":
      pause_scene();
      break;
  }  
}
 
//タイトル画面での処理
void title_scene(){
  background(0);  //0は黒の背景　255は白の背景
  textSize(100);  //テキストサイズを指定
  text("Start",350,500); //座標350,500にStartを表示
  textSize(50);  //テキストサイズを指定
  text("Press left click",300,600);  //座標300,600にPress left clickを表示
   
  //左クリックされたらプレイ画面へ
  if(mouseButton == LEFT){
    scene = "play";
  }
}
 
//プレイ画面での処理
void play_scene(){
  background(0);  //0は黒の背景　255は白の背景
  ellipse(mouseX,mouseY,30,30);  //自機
   
  for(int i=0;i<10;i++){
    ellipse(enemy_x[i],enemy_y[i],50,50);  //敵機
    enemy_y[i] += enemy_speed[i];  //座標を増やす
     
    //当たり判定
    if((mouseX+15>enemy_x[i]-25 && mouseX-15<enemy_x[i]+25)
      && (mouseY+15>enemy_y[i]-25 && mouseY-15<enemy_y[i]+25)){
        enemy_x[i]=int(random(width)); //widthは画面の幅を表すシステム変数
        enemy_y[i]=-50;
        enemy_speed[i] = int(random(2,10));  //速さの初期化 
        hp-=1;
    }
     
    //画面下に出たら
    if(enemy_y[i]-25>height){ 
      enemy_x[i]=int(random(width)); //widthは画面の幅を表すシステム変数
      enemy_y[i]=-50;
      enemy_speed[i] = int(random(2,10));  //速さの初期化
    }
     if(key == ENTER){
         scene = "pause";
     }
  } 
   
  //自機の撃墜（ゲームオーバー画面へ）
  if(hp<=0){
    scene = "gameover";
  }
}
 
//ゲームオーバー画面での処理
void gameover_scene(){
  background(0);  //0は黒の背景　255は白の背景
  textSize(100); //テキストサイズを指定
  text("Game Over",250,500); //座標250,500にGame Overを表示 
  textSize(50);
}

void pause_scene(){
  textSize(100); //テキストサイズを指定
  text("Pause",300,500); //座標250,500にGame Overを表示 
  textSize(50);
}
