// Created by Amit Rawat
class StringUtil {
  static String checknull(String value) {
    if (!["", null, "null"].contains(value)) {
      return value;
    } else {
      return '';
    }
  }


}
