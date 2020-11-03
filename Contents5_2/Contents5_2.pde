import ddf.minim.*;
Minim minim;
Bullet bullet;
AudioPlayer player;
private Boss boss = new Boss(100, 150);
private ArrayList<Bullet> danmaku = new ArrayList<Bullet>();


void setup() {
  size(320, 480);

  frameRate(30);

  bullet = new Bullet(width/2, height/2, 10, 0, 0 );
  minim = new Minim(this);
  player = minim.loadFile("WAV_20201030_171337544.wav");
}

void draw() {
  background(0);
  noStroke();
  fill(255);
  rect(150, 300, 20, 20);
  boss.doShinking();
  for (int i = danmaku.size() -1; i  >= 0; i--) {
    Bullet b = (Bullet)danmaku.get(i);
    if (!b.isAlive()) {
      danmaku.remove(i);
      continue;
    }
    b.update();
  }
  
}
