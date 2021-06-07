/**
 * Created by Amit Rawat on 05-06-2021
 */

class RestConstant {
  static const String URL = "http://itunes.apple.com/";
  static const String POSTFIX = "?";
  static const String SONG_URL = URL+"/songs"+POSTFIX;
  static const String ARTIST_URL = URL+"/artists"+POSTFIX;
  static const String SEARCH_URL = URL+"/search"+POSTFIX;
  static const String TERM = "term=";
  static const String TYPES = "types=";
  static const String ENTITY = "entity=";
  static const String AND = "&";
  static const String SONG = "song";


  static const String RESULT = "results";
  static const String RESULT_COUNT = "resultCount";
}
