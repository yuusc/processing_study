import processing.video.*; // Videoを扱うライブラリをインポート
Capture camera; // ライブカメラの映像をあつかうCapture型の変数

void setup() {
  size(480, 320);
  String[] cameras = Capture.list();
camera = new Capture(this, 640, 480, cameras[0]);
  camera.start();
}

void draw() {
  image(camera, 0, 0); // 画面に表示
} 

//カメラの映像が更新されるたびに、最新の映像を読み込む
void captureEvent(Capture camera) {
  camera.read();
}
