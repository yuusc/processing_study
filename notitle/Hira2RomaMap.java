import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;

public class Hira2RomaMap{
    public static void main(String[] args) {
        ArrayList<String> hiralines = new ArrayList<String>();
        HashMap<String, String> hira2romamap = new HashMap<String, String>();
        hira2romamap = setHira2RomaMap();
        hiralines = kanayoui("hiragana.txt");
        for ( String hira : hiralines ){
            String roma = trans(hira,hira2romamap);
            System.out.println(hira);
            System.out.println(roma);
        }
    }
    public static String trans(String line,HashMap<String, String> map){
        String result = "";
        String h1,r1;
        for (int i=0; line.length()>i; i++){
            h1 = line.substring(i,i+1);
            r1 = map.get(h1);
            if (r1==null) {result += h1;continue;}
            result += r1;
        }
        return result;
    }
    
    public static ArrayList<String> kanayoui(String f){
        ArrayList<String> doc = new ArrayList<String>();
        try {
            FileReader   in  = new FileReader(f);
            BufferedReader inb = new BufferedReader(in);
            String line;
            while ((line = inb.readLine()) != null) {
                doc.add(line);
            }
            inb.close();
            in.close();
        }
        catch (IOException e) {
            System.err.println( f + " がないのでは？" );
            System.err.println( e);
        }
        return doc;
    }
        
    public static HashMap<String, String> setHira2RomaMap(){
        HashMap<String, String> map = new HashMap<String, String>();
        map.put( "　", " " );
        map.put( "ぁ", "^a" );
        map.put( "あ", "a" );
        map.put( "ぃ", "^yi" );
        map.put( "い", "i" );
        map.put( "ぅ", "^u" );
        map.put( "う", "u" );
        map.put( "ぇ", "^ye" );
        map.put( "え", "e" );
        map.put( "ぉ", "^o" );
        map.put( "お", "o" );
        map.put( "か", "ka" );
        map.put( "が", "ga" );
        map.put( "き", "ki" );
        map.put( "ぎ", "gi" );
        map.put( "く", "ku" );
        map.put( "ぐ", "gu" );
        map.put( "け", "ke" );
        map.put( "げ", "ge" );
        map.put( "こ", "ko" );
        map.put( "ご", "go" );
        map.put( "さ", "sa" );
        map.put( "ざ", "za" );
        map.put( "し", "shi" );
        map.put( "じ", "ji" );
        map.put( "す", "su" );
        map.put( "ず", "zu" );
        map.put( "せ", "se" );
        map.put( "ぜ", "ze" );
        map.put( "そ", "so" );
        map.put( "ぞ", "zo" );
        map.put( "た", "ta" );
        map.put( "だ", "da" );
        map.put( "ち", "chi" );
        map.put( "ぢ", "ji" );
        map.put( "っ", "_" );
        map.put( "つ", "tsu" );
        map.put( "づ", "zu" );
        map.put( "て", "te" );
        map.put( "で", "de" );
        map.put( "と", "to" );
        map.put( "ど", "do" );
        map.put( "な", "na" );
        map.put( "に", "ni" );
        map.put( "ぬ", "nu" );
        map.put( "ね", "ne" );
        map.put( "の", "no" );
        map.put( "は", "ha" );
        map.put( "ば", "ba" );
        map.put( "ひ", "hi" );
        map.put( "び", "bi" );
        map.put( "ふ", "fu" );
        map.put( "ぶ", "bu" );
        map.put( "へ", "he" );
        map.put( "べ", "be" );
        map.put( "ほ", "ho" );
        map.put( "ぼ", "bo" );
        map.put( "ま", "ma" );
        map.put( "み", "mi" );
        map.put( "む", "mu" );
        map.put( "め", "me" );
        map.put( "も", "mo" );
        map.put( "ゃ", "^ya" );
        map.put( "や", "ya" );
        map.put( "ゅ", "^yu" );
        map.put( "ゆ", "yu" );
        map.put( "ょ", "^yo" );
        map.put( "よ", "yo" );
        map.put( "ら", "ra" );
        map.put( "り", "ri" );
        map.put( "る", "ru" );
        map.put( "れ", "re" );
        map.put( "ろ", "ro" );
        map.put( "ゎ", "^wa" );
        map.put( "わ", "wa" );
        map.put( "ゐ", "i" );
        map.put( "ゑ", "e" );
        map.put( "を", "wo" );
        map.put( "ん", "n" );
        map.put( "ゔ", "vu" );
        return map;
    }
}
