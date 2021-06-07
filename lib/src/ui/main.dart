import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'music_page.dart';
/**
 * Created by Amit Rawat on 05-06-2021
 */

void main() => runApp(MyApp());

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
