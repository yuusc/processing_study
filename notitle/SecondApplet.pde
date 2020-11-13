import ddf.minim.analysis.*;
import ddf.minim.*;

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

int fftSize;
  public void settings() {
  size(1024, 600, "processing.opengl.PGraphics3D");
}
  void setup() {
  colorMode(HSB,360,100,100,100);
  fftSize=512;

  // Minim の初期化
  minim = new Minim(this);

  // ステレオオーディオ入力を取得
  in = minim.getLineIn(Minim.STEREO, 512);

  // ステレオオーディオ入力を FFT と関連づける
  fft = new FFT(in.bufferSize(), in.sampleRate());
  }

  void draw()
  {
    background(0);
strokeWeight(2.0);
fft.forward( in.mix );
for(int i =0; i < fft.specSize(); i++)
{
float x = map(i,0,fft.specSize(),0,width);
float y = map(fft.getBand(i),0,5.0,height,0);
float h = map(i,0,fft.specSize(),0,180);
stroke(h,100,100);
line(x,height,x,y);
}
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
