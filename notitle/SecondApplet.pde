import ddf.minim.analysis.*;
import ddf.minim.*;

float angle = 0.0;
String[] moji = {"G","a","b","r","i","e","l","","D","r","o","p","o","u","t","","",""};
int mojisu = moji.length;
int mojino= 0;
//PFont font;

class SecondApplet extends PApplet {
  PApplet parent;

  SecondApplet(PApplet _parent) {
    super();
    // set parent
    this.parent = _parent;
    //// init window
    try {
      java.lang.reflect.Method handleSettingsMethod =
        this.getClass().getSuperclass().getDeclaredMethod("handleSettings", null);
      handleSettingsMethod.setAccessible(true);
      handleSettingsMethod.invoke(this, null);
    } 
    catch (Exception ex) {
      ex.printStackTrace();
    }

    PSurface surface = super.initSurface();
    surface.placeWindow(new int[]{0, 0}, new int[]{0, 0});

    this.showSurface();
    this.startSurface();
  }
Minim minim;

  // オーディオ入力の変数を用意する
  AudioInput in;

  // FFTの変数を用意する
  FFT fft;
  
  PFont font;

  int BUFSIZE = 512;

  public void settings() {
    size(1024, 600, "processing.opengl.PGraphics3D");
  }
  void setup() {
    //font = createFont("MagicRing.ttf", 30);
   //font = createFont("RuneAMN_KnifeA.ttf",30);
   font = createFont("Meiryo",30);
    //println(PFont.list());
   
    background(0);
    colorMode(HSB, 360, 100, 100, 100);

    // Minim の初期化
    minim = new Minim(this);

    // ステレオオーディオ入力を取得
    in = minim.getLineIn(Minim.STEREO, BUFSIZE);

    // ステレオオーディオ入力を FFT と関連づける
    fft = new FFT(in.bufferSize(), in.sampleRate());
    noStroke();
    
  }

  void draw()
  {
    fill(0, 0, 0, 10);
    rect(0, 0, width, height);
    
  
    // FFT 実行（左チャンネル）
    fft.forward(in.left);

    // FFTのスペクトラムの幅を変数に保管します
    float specSize = fft.specSize();

    // スペクトラムに応じて円を描画します
    for (int i = 0; i < specSize; i++)
    {
      float h = map(i, 0, specSize, 0, 180) * 0.8;
      float ellipseSize = map(fft.getBand(i), 0, BUFSIZE/16, 0, width/2);
      float x = map(i, 0, fft.specSize(), width/2, 0);
      fill(h, 60, 80, 7);
      ellipse(x, height/2, ellipseSize, ellipseSize);
    }
    
    for (int i = 0; i < specSize; i++)
  {
    // 棒の左右位置に応じた色相を取得します
    float h = map(i, 0, specSize, 0, 360);
    
    // スペクトラムの値に応じた不透明度を取得します
    float a = map(fft.getBand(i), 0, BUFSIZE/16, 0, 255);
    
    // スペクトラム位置に応じた棒の x 位置を取得します。
    float x = map(i, 0, specSize, width/2, 0);
    
    // 棒の描画幅を定めます
    float w = width / specSize / 2;
    
    // 棒の塗りつぶし色を指定します
    fill(h, 90, 80, a);
    
    // 棒を描画します
    rect(x, 0, w, height);
  }

    // FFT 実行（右チャンネル）
    fft.forward(in.right);

    // FFTのスペクトラムの幅を変数に保管します
    specSize = fft.specSize();

    // スペクトラムに応じて円を描画します
    for (int i = 0; i < specSize; i++)
    {
      float h = map(i, 0, specSize, 0, 180) * 0.8;
      float ellipseSize = map(fft.getBand(i), 0, BUFSIZE/16, 0, width/2);
      float x = map(i, 0, specSize, width/2, width);
      fill(h, 60, 80, 7);
      ellipse(x, height/2, ellipseSize, ellipseSize);
    }
    for (int i = 0; i < specSize; i++)
  {
    // 棒の左右位置に応じた色相を取得します
    float h = map(i, 0, specSize, 0, 360);
    
    // スペクトラムの値に応じた不透明度を取得します
    float a = map(fft.getBand(i), 0, BUFSIZE/16, 0, 255);
    
    // スペクトラム位置に応じた棒の x 位置を取得します。
    float x = map(i, 0, specSize, width/2, width);
    
    // 棒の描画幅を定めます
    float w = width / specSize / 2;
    
    // 棒の塗りつぶし色を指定します
    fill(h, 90, 80, a);
    
    // 棒を描画します
    rect(x, 0, w, height);
  }
  
  float mojideg = 360/mojisu;
   for (int i = 0; i < 360; i += mojideg) {

    pushMatrix(); //現在の座標系を保存
    translate(width/2, height/2);  //座標系を画面中央に移動
    rotate(radians(angle + i)); //座標系を回転
    fill(255);
    textFont(font);
    text(moji[mojino],0, -100);
    noFill();
    popMatrix(); //前の座標系を呼び出す
    mojino++;
    if (mojino == mojisu) mojino = 0;
  }
  stroke(255);
  ellipse(width/2, height/2,195,195);
  ellipse(width/2, height/2,250,250);
  noStroke();
  //angleを加算。360.0度になったら0.0度に戻す
  angle += 0.5;
  if (angle >= 360.0) angle = 0.0;

  }
void stop()
{
  minim.stop();
  super.stop();
}

void rad() {
  float mx = mouseX - 480;
  float my = -mouseY + 480;
  phi = atan(my/mx);
  if (mx< 0 ) {
    phi = 3.14 + phi;
  } else if (mx >= 0 && my < 0) {
    phi = 6.28 + phi;
  }
  r = sqrt(mx*mx+my*my);
  println(phi);
  println(r);
}
}
