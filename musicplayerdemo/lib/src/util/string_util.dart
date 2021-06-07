/**
 * Created by Amit Rawat on 05-06-2021
 */


class StringUtil {
  static String checknull(String value) {
    if (!["", null, "null"].contains(value)) {
      return value;
    } else {
      return '';
    }
  }


}
