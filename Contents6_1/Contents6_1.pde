int y = 0;
int moji_size = 5;
char moji;
 
void setup() {
  size(300, 300); //ウィンドウサイズを300x300にする
  background(0); //背景を黒にする
}
 
void draw() {
  y++; //文字位置のy軸を下へずらす
  textSize(moji_size); //文字サイズを10にする
  for(int x = 0;x <= 60; x++){
    if(int(random(4)) == 1){ //文字の出現を1/4にする（乱数は0~3）
      moji = char(int(random(97,122))); //ASCIIコード33~126に対応する文字を表示
      fill(0,255,0); //文字を緑色に設定
      text(moji, x*moji_size, y*moji_size); //文字を描写
    }
  }
  if(y >= 60){
    y = 0; //文字位置のy軸を戻す
    background(0); //画面全体を黒でクリアする
  }
}
