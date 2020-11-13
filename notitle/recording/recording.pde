import ddf.minim.*;
import ddf.minim.ugens.*;
 
//クラスの宣言
Minim       minim;    //Minimを使う場合は必ず宣言
AudioOutput out;    //スピーカーから音を出す場合は必ず宣言
Oscil wave;       //関数Oscilを利用する場合は必ず宣言
float frec = 440;
float phi;
float r;
int BPM = 120;
final int division = 480;
float unitDeltaTime = 60.0 / (BPM * division);
final int format = 1;
final int padNumber = 8;//各行のパッドの数
boolean isStart = false;
final String title = "Recording";
final String fileName = "Recording.mid";
ArrayList<Byte>[] track = new ArrayList[2];
int[] deltaFrame = new int[track.length];
int[][] noteNumber = new int [track.length][padNumber];
boolean[][] isPush = new boolean [track.length][padNumber];

void setup()
{
  size(800,200, P3D);
    
  minim = new Minim(this);            //Minimを使う場合は必ず実行
  out = minim.getLineOut();           //スピーカーから音を出す場合は必ず実行
     //波形を生成  Oscil(周波数, 振幅, 波形の形状)
  wave = new Oscil( frec, 1, Waves.SINE );   //Sin波
  //波形waveをAudioOutputに接続
  //wave.patch( out );
  stroke(255);
  for (int i = 0; i < track.length; i++) {
    deltaFrame[i] = 0;
    track[i] = new ArrayList<Byte>();
    setInitialTrack(track[i]);
    for (int j = 0; j < padNumber; j++) {
      isPush[i][j] = false;
      noteNumber[i][j] = 12 * (i + 5) + j;
    }
  }
}
 
void draw()
{
  background(100);
  rad();
  deltaCount();
  display();
}

void deltaCount() {
  for (int i = 0; i < track.length; i++) {
    if (isStart) {
      deltaFrame[i]++;
    }
  }
}

void display() {
  for (int i = 0; i < track.length; i++) {
    for (int j = 0; j < padNumber; j++) {
      if (isPush[i][j]) {
        fill(255, 0, 0);
      } else {
        fill(0);
      }
      rect(j * 100, i * 100, 100, 100);
    }
  }
}

void mousePressed() {
  //パッドの内側をマウスボタンで押したら押した部分にあるパッドをノートオンにしてトラックに書き込む
  for (int i = 0; i < track.length; i++) {
    for (int j = 0; j < padNumber; j++) {
      if (j * 100 <= mouseX && mouseX <= (j + 1) * 100 && i * 100 <= mouseY && mouseY <= (i + 1) * 100) {
        if (!isPush[i][j]) {
          isPush[i][j] = true;
          writeTrack(track[i], i, j, isPush[i][j]);
        }
      }
    }
  }
}

void mouseReleased() {
  //マウスボタンを離した時にノートオンのパッドがあればノートオフにしてトラックに書き込む
  for (int i = 0; i < track.length; i++) {
    for (int j = 0; j < padNumber; j++) {
      if (isPush[i][j]) {
        isPush[i][j] = false;
        writeTrack(track[i], i, j, isPush[i][j]);
      }
    }
  }
}

void keyPressed() {
  //スペースキーを押したら保存する
  if (key == ' ') {
    for (int i = 0; i < track.length; i++) {
      setTrackEnd(track[i]);
      setTrackLength(track[i]);
    }
    //コンダクタートラック
    ArrayList<Byte> conductorTrack = new ArrayList<Byte>();
    setInitialTrack(conductorTrack);
    setTrackName(conductorTrack, title);
    changeTempo(conductorTrack, BPM);
    setTrackEnd(conductorTrack);
    setTrackLength(conductorTrack);

    byte[] playData = concat(arrayListToArray(track[0]), arrayListToArray(track[1]));
    byte[] allTrack = concat(arrayListToArray(conductorTrack), playData);
    outputSMF(allTrack, format, track.length+format, division, fileName);
  }
}

void setInitialTrack(ArrayList<Byte> _track) {
  _track.add(byte(0x4D));
  _track.add(byte(0x54));
  _track.add(byte(0x72));
  _track.add(byte(0x6B));
}

void setTrackLength(ArrayList<Byte> _track) {
  //上記のチャンクタイプを書き込む関数の前に呼び出す場合はindexを4減らす,_track.size()-3にする
  _track.add(4, byte((max(0, _track.size()-7))>>>24));
  _track.add(5, byte((max(0, _track.size()-7))>>>16));
  _track.add(6, byte((max(0, _track.size()-7))>>>8));
  _track.add(7, byte((max(0, _track.size()-7))));
}

//可変長数値表現に変換したデルタタイムを返す
//_dは変換前のデルタタイム
ArrayList<Byte> returnDeltaTime(int _d) {
  byte[] bytes = new byte[]{0, 0, 0, 0};
  int byteCount = convertDeltaTime(bytes, _d);
  ArrayList<Byte> returnBytes = new ArrayList<Byte>();
  for (int i = 0; i < byteCount; i++) {
    returnBytes.add(bytes[i]);
  }
  return returnBytes;
}

//デルタタイムを可変長数値表現に変換する
int convertDeltaTime(byte[] _array, int _d) {
  int count = 0; //変換時のバイト数
  if (_d <= 0x7F) { 
    //値が1バイトで表せる場合(0x7F→0x7F)
    _array[0] = byte(_d); 
    count = 1;
  } else if (_d <= 0x3FFF) {
    //値が2バイトで表せる場合(0x3FFF→0xFF7F)
    _array[0] = byte(0x80 | ((_d & 0x3F80) >> 7)); 
    _array[1] = byte(0x7F & _d);
    count = 2;
  } else if (_d <= 0x1FFFFF) { 
    //値が3バイトで表せる場合(0x1FFFFF→0xFFFF7F)
    _array[0] = byte(0x80 | ((_d & 0x1FC000) >> 14));
    _array[1] = byte(0x80 | ((_d & 0x3F80) >> 7));
    _array[2] = byte(0x7F & _d);
    count = 3;
  } else { 
    //値が4バイトで表せる場合(0xFFFFFFF→0xFFFFFF7F)
    _array[0] = byte(0x80 | ((_d & 0x0FE00000) >> 21));
    _array[1] = byte(0x80 | ((_d & 0x1FC000) >> 14));
    _array[2] = byte(0x80 | ((_d & 0x3F80) >> 7));
    _array[3] = byte(0x7F & _d);
    count = 4;
  } 
  return count;
}

//トラックに書き込み
void writeTrack(ArrayList<Byte> _track, int _i, int _j, boolean bool) {
  if (!isStart) {
    isStart = true;
    //デルタタイム0を追加
    _track.add(byte(0x00));
  } else {
    //デルタタイムを可変長数値表現に変更してから追加
    int deltaTime = int((deltaFrame[_i] / 60.0) / unitDeltaTime);
    ArrayList<Byte> list = new ArrayList();
    list.addAll(returnDeltaTime(deltaTime));
    for (int i = 0; i < list.size(); i++) {
      _track.add(list.get(i));
    }
  }

  //チャンネル
  //false→ノートオフ,true→ノートオン
  int channel;
  if (!bool) {
    channel = 0x80 + _i;
  } else {
    channel = 0x90 + _i;
  }
  _track.add(byte(channel));

  //ノート番号を取得;
  int note = noteNumber[_i][_j];
  _track.add(byte(note));
  //ベロシティ
  _track.add(byte(0x66));
  deltaFrame[_i] = 0;
}

//トラック名のメタイベントを追加
void setTrackName(ArrayList<Byte> _track, String name) {
  byte[] bytes = name.getBytes();
  _track.add(byte(0x00));
  _track.add(byte(0xFF));
  _track.add(byte(0x03));
  _track.add(byte(bytes.length));
  for (int i = 0; i < bytes.length; i++) {
    _track.add(Byte.valueOf(bytes[i]));
  }
}

//テンポ変更のメタイベントを追加
void changeTempo(ArrayList<Byte> _track, int _BPM) {
  //4分音符の長さ(単位はμs)
  int quarterNoteLength = int(60.0 * pow(10, 6) / _BPM);
  _track.add(byte(0x00));
  _track.add(byte(0xFF));
  _track.add(byte(0x51));
  _track.add(byte(0x03));
  _track.add(byte(quarterNoteLength >>> 16));
  _track.add(byte(quarterNoteLength >>> 8));
  _track.add(byte(quarterNoteLength));
}

//トラック終端のメタイベントを追加
void setTrackEnd(ArrayList<Byte> _track) {
  _track.add(byte(0x00));
  _track.add(byte(0xFF));
  _track.add(byte(0x2F));
  _track.add(byte(0x00));
}

//ArrayList<Byte>からbyte型配列に変換
byte[] arrayListToArray(ArrayList<Byte> _track) {
  Byte[] tempArray = _track.toArray(new Byte[_track.size()]);
  byte[] byteArray = new byte[tempArray.length];
  for (int i = 0; i < byteArray.length; i++) {
    byteArray[i] = tempArray[i];
  }
  return byteArray;
}

//SMFを出力
void outputSMF(byte[] _list, int _format, int _trackNumber, int _division, String _name) {
  //ヘッダチャンクを格納する配列を作成
  byte[] header = new byte[14];

  //チャンクタイプ
  header[0] = 0x4D;
  header[1] = 0x54;
  header[2] = 0x68;
  header[3] = 0x64;

  //データ長
  header[4] = 0x00;
  header[5] = 0x00;
  header[6] = 0x00;
  header[7] = 0x06;

  //MIDIフォーマット
  header[8] = byte(_format >>> 8);
  header[9] = byte(_format);

  //トラック数
  header[10] = byte(_trackNumber >>> 8);
  header[11] = byte(_trackNumber);

  //分解能
  header[12] = byte(_division >>> 8);
  header[13] = byte(_division);

  //SMF出力
  byte[] file = concat(header, _list);
  saveBytes(_name, file);
}

void rad(){
    float mx = mouseX - 480;
  float my = -mouseY + 480;
    phi = atan(my/mx);
  if (mx< 0 ){
      phi = 3.14 + phi;
  }else if(mx >= 0 && my < 0){
      phi = 6.28 + phi;
  }
  r = sqrt(mx*mx+my*my);
  println(phi);
  println(r);
}



// https://qiita.com/Beef1297/items/a20bec00c01a85daadd4
// https://my-pon.hatenablog.com/entry/2020/01/23/083725
