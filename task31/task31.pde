PImage myPhoto;
float d = 10; 
 
void setup() {
  size(500, 500); // 自分の画像に合わせてサイズを決めてください
  myPhoto = loadImage("yui.jpg"); // 同じフォルダにある画像を読み取ります
  myPhoto.resize(500, 500); //画像のサイズはウインドウに合うように、リサイズするのがおすすめです
}
 
void draw() {
  myPhoto.loadPixels();  
  // 10ピクセルごとに画像を再描画します
  for(int i = 0; i < myPhoto.width; i += d)
  {
    for(int j = 0; j < myPhoto.height; j += d)
    {
      fill(myPhoto.pixels[i*myPhoto.width + j]);
      ellipse(j, i, d, d);
    }
  }
}