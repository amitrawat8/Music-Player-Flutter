import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:musicplayerdemo/src/util/alert_handler.dart';

import '../../dto/results.dart';
import '../../util/time_convert.dart';
import '../music_page.dart';
import 'icon_widget.dart';

// Created by Amit Rawat

/*song list */
class SongWidget extends StatelessWidget {
  final List<Results> songList;

  SongWidget({@required this.songList});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: songList.length,
        itemBuilder: (context, songIndex) {
          Results song = songList[songIndex];
          return Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      child: new Container(
                        width: 100,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/loading.gif',
                          image: song.artworkUrl100,
                          fit: BoxFit.cover,
                          height: 90,
                          width: 100,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(song.trackName,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700)),
                              ),
                              Text(
                                  "Artist: ${song.artistName.substring(0, min(song.artistName.length, 30))}",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  "Collection: ${song.collectionName.substring(0, min(song.collectionName.length, 30))}",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  "Duration: ${Time.parseToMinutesSeconds(song.trackTimeMillis)} min",
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          audioManagerInstance
                              .start(song.previewUrl, song.collectionName,
                                  desc: song.artistName,
                                  auto: true,
                                  cover: song.previewUrl)
                              .then((err) {
                            print(err);
                          });

                          if (songList.length != 1) {
                            songList[songPosition].loadingNotify = false;
                          }

                          song.loadingNotify = true;
                          songPosition = songIndex;
                          (context as Element).markNeedsBuild();
                          AlertHandler.showLoaderDialog(context);
                          // Play or pause; that is, pause if currently playing, otherwise play
                        },
                        child: song.loadingNotify != null && song.loadingNotify
                            ? SpinKitWave(
                                color: Colors.blue,
                                size: 20.0,
                              )
                            : IconText(
                                iconData: Icons.play_circle_outline,
                                iconColor: Colors.green,
                                string: "Play",
                                textColor: Colors.black,
                                iconSize: 35,
                              ),
                      ))
                ],
              ),
            ),
          );
        });
  }
}
