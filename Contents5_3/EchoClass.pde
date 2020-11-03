class EchoClass implements AudioEffect
{
  //遅延音を記憶するLチャンネルとRチャンネルのバッファの設定
  float[] l_buffer;
  float[] r_buffer;
  int buffer_size;
  //現在のデータをバッファに入れる場所を指すインデックス
  int l_index, r_index;
  //いくつ前の遅延音を取り出すかの値
  float delay_time;
  //遅延音を繰り返す数
  int feedback;
  //遅延音の減衰値を繰り返し数分保持する配列
  float[] delay_level; 
   
  //実際の関数の中身を決めていく
  EchoClass(float fs, float dt, float dl, int fb)
  {
    //遅延時間の計算
    delay_time = fs * dt;
    //何回繰り返すかを決める
    feedback = fb;
    //遅延音を記録するバッファのサイズ指定（最低でもdelay_time * feedback)＋1必要）
    buffer_size = (int)(delay_time * feedback) + 256;
      
    //再生時にバッファの一番最初にデータを記録するように設定する
    l_index = 0;
    r_index = 0;
     
    //メモリ上にバッファを確保する．
    l_buffer = new float[buffer_size];
    r_buffer = new float[buffer_size];
     
    //確保したバッファに対して0で初期化する．
    for (int i = 0; i < buffer_size; i++)
    {
      l_buffer[i] = 0.0;
      r_buffer[i] = 0.0;
    }
     
    //遅延音の音量をfeedbackの数の分だけ確保する．
    delay_level = new float[feedback];
     
    for (int i = 0; i < feedback; i++)
    {
      //feedbackの数の分の遅延音量を計算
      delay_level[i] = sin(dl*(float)(i + 1));
    }
  }
   
//エコー処理の中身の設定
  int echo_process(float[] samp, float[] buffer, int ix)
  {
    //バッファへのインデックス値を変数に代入
    int index = ix;
     
    float[] out = new float[samp.length];
     
    for ( int n = 0; n < samp.length; n++ )
    {
      //現在のインデックスが指しているバッファの位置に現時点のデータを記録
      buffer[index] = samp[n];
      //データに今のデータを入れる
      float data = samp[n];
      //遅延の繰り返し回数だけ処理を繰り返し
      for (int i = 0; i < feedback; i++)
    {  
        //どれだけ前のデータを呼び出すかの値を設定
        int m = index - (int)((i + 1) * delay_time);
        //mはバッファのインデックスを指定する変数なので必ず正
        //mが負の数になったときのための処理を行う
        if ( m < 0 )
        {
          m += buffer_size;
        }
        //遅延音に減衰値を掛けたものをdetaに加える.data は「今の音＋１番目の遅延音＋２番目の遅延音…」となる
        data += delay_level[i] * buffer[m];
      }
      //出力用のバッファに遅延音も含んでいるデータを書き込んでいく
      out[n] = data;
      //次のインデックスに進む
      index++;
      //現在のインデックスがバッファサイズより大きい場合，インデックスを最初に戻す．
      if (index >= buffer_size)
      {
        index = 0;
      }
    }    
    arraycopy(out, samp);
    //返り値はインデックスの値
    return index;
  }
   
//ステレオの時に呼び出される process()メソッド
  void process(float[] samp)
  {
    l_index = echo_process(samp, l_buffer, l_index);
  }
//モノラルの時に呼び出される process()メソッド
  void process(float[] left, float[] right)
  {
    l_index = echo_process(left, l_buffer, l_index);
    r_index = echo_process(right, r_buffer, r_index);
  }
}
