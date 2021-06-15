import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayerdemo/src/bloc/MusicSearchBloc.dart';
import 'package:musicplayerdemo/src/network/music_cache.dart';
import 'package:musicplayerdemo/src/network/music_client.dart';
import 'package:musicplayerdemo/src/repository/music_repository.dart';
import 'package:musicplayerdemo/src/ui/music_page.dart';

// Created by Amit Rawat
main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    final MusicRepository musicRepository = MusicRepository(
      MusicCache(),
      MusicClient(),
    );
    runApp(MyApp(musicRepository: musicRepository));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key key, @required this.musicRepository}) : super(key: key);
  final MusicRepository musicRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Music App",
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => MusicSearchBloc(musicRepository: musicRepository),
        child: MusicPageWidget(),
      ),
    );
  }
}
