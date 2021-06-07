import 'package:connectivity/connectivity.dart';

/**
 * Created by Amit Rawat on 05-06-2021
 */

class InternetU {
  static Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
}
