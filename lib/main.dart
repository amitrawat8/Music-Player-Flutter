import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/ui/music_page.dart';
/**
 * Created by Amit Rawat on 05-06-2021
 */

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Music App",
      debugShowCheckedModeBanner: false,
      home: MusicPageWidget(),
    );
  }
}
