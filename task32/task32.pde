PImage myPhoto;
float d = 50; 

void setup() {
	size(500, 500); // 自分の画像に合わせてサイズを決めてください
	colorMode(HSB); //色区間はHSBにします
	myPhoto = loadImage("yui.jpg"); // 同じフォルダにある画像を読み取ります
	myPhoto.resize(500, 500); //画像のサイズはウインドウに合うように、リサイズするのがおすすめです
}

void draw() {
	myPhoto.loadPixels();
	// マウスを動かしながらピクセルの色を抽出した丸で画像を再描画します
	int x = constrain(mouseX, 0, myPhoto.width - 1); //マウスの位置をウインドウ内に制限します
	int y = constrain(mouseY, 0, myPhoto.height - 1); 
	color myPhotoColor = myPhoto.pixels[y * myPhoto.width + x];
	fill(hue(myPhotoColor), 40, brightness(myPhotoColor)); // HSBの値を変更します
	ellipse(x, y, d, d);
	if (mousePressed) //マウスのボタンがクリックされるかどうかを判断します
	 {
	 if ((mouseButton == LEFT) && (d<100)) //丸のサイズが大きくなり、上限は100です
	 {
	    d +=2; //2ごとに大きくなります
	 }
	 if ((mouseButton == RIGHT) && (d>0)) //丸のサイズが小さくなり、下限は0です
	 {
	    d -=2; //2ごとに小さくなります
	 }
	}
}