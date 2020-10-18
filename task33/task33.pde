import processing.video.*;
 
Movie movie; //新しい動画像を定義します
int d = 20;  
 
void setup() {
  size(1280, 720);//自分の動画像のサイズをチェックしてみてここを変更してください
  background(0);
  movie = new Movie(this, "Akihabara.mp4"); //動画像を読み取ります。ここの名称を変更してください
  movie.loop();//動画像をリピート再生させます
}
 
void movieEvent(Movie m) {
  m.read();
}
 
void draw() {
  image(movie, 0, 0, movie.width, movie.height);//フレームごとに処理します
  movie.loadPixels();
  for (int i = 0; i< movie.width; i+=d)
  {
     for(int j = 0; j< movie.height; j+=d)
     {
         float r = red(movie.pixels[i + j*movie.width]); // 動画像の色を抽出します
         float g = green(movie.pixels[i + j*movie.width]);      
         float b = blue (movie.pixels[i + j*movie.width]); 
         color c = movie.pixels[i + j*movie.width];
         if(mousePressed)//マウスボタンの判定
        {
            fill(0,saturation(c),brightness(c)); // RGB->BGR
            stroke(200,120,120); // 全体見やすいように線の色も変わります
            rect(i,j,d,d);//正方形でフレームを再描画します
        }
        else
        {
            fill(r,g,b);
            stroke(0,120,120);
          rect(i,j,d,d);
        }
     }
  }
  updatePixels();
}