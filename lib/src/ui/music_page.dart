import 'dart:async';
import 'dart:math';

import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:musicplayerdemo/src/constant/base_constant.dart';
import 'package:musicplayerdemo/src/dto/results.dart';
import 'package:musicplayerdemo/src/ui/widget.dart';
import 'package:musicplayerdemo/src/util/alert_handler.dart';
import 'package:musicplayerdemo/src/util/internetU.dart';
import 'package:musicplayerdemo/src/util/time_convert.dart';

import '../lib/cupertino_search_bar.dart';
import '../network/musicservice.dart';

var audioManagerInstance = AudioManager.instance;
bool showVol = false;
PlayMode playMode = audioManagerInstance.playMode;
bool isPlaying = false;
double _slider;

class MusicPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MusicPageWidgetState();
  }
}

class MusicPageWidgetState extends State<MusicPageWidget>
    with SingleTickerProviderStateMixin {
  TextEditingController _searchTextController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  Animation _animation;
  AnimationController _animationController;
  Future<ServiceResponse> _search;
  AppleMusicStore musicStore = AppleMusicStore.instance;
  String _searchTextInProgress;
  int position = 0;
  List<String> nameList = [];

  @override
  initState() {
    super.initState();
    setupAudio();
    internet();
    listener();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: IOSSearchBar(
          controller: _searchTextController,
          focusNode: _searchFocusNode,
          animation: _animation,
          onCancel: _cancelSearch,
          onClear: _clearSearch,
        )),
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: GestureDetector(
                        onTapUp: (TapUpDetails _) {
                          _searchFocusNode.unfocus();
                          if (_searchTextController.text == '') {
                            _animationController.reverse();
                          }
                        },
                        child: _search != null
                            ? FutureBuilder<ServiceResponse>(
                                future: _search,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.connectionState !=
                                          ConnectionState.waiting) {
                                    final searchResult = snapshot.data;
                                    if (searchResult != null &&
                                        searchResult.results != null &&
                                        searchResult.results.isNotEmpty) {
                                      return songWidget(searchResult.results);
                                    } else {
                                      return Center(
                                          child:
                                              Text(BaseConstant.NO_DATA_FOUND));
                                    }
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child: Text(BaseConstant
                                            .NO_DATA_FOUND_OR_CONNECTION));
                                  }

                                  return Center(
                                      child: CircularProgressIndicator());
                                },
                              )
                            : Center(
                                child: Text(
                                    'Type on search bar to begin the song')), // Add search body here
                      ),
                    ),
                    bottomPanel(context),
                  ],
                ),
              ),
            )));
  }

  Widget songWidget(List<Results> songList) {
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

                          setState(() {
                            // print("pso :  $position");
                            songList[position].loadingNotify = false;
                            song.loadingNotify = true;
                          });
                          position = songIndex;
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

          return SizedBox(
            height: 0,
          );
        });
  }

  Widget bottomPanel(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: songProgress(context),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CircleAvatar(
              child: Center(
                child: IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                    ),
                    onPressed: () => audioManagerInstance.previous()),
              ),
              backgroundColor: Colors.cyan.withOpacity(0.3),
            ),
            CircleAvatar(
              radius: 30,
              child: Center(
                child: IconButton(
                  onPressed: () async {
                    audioManagerInstance.playOrPause();
                  },
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(
                    audioManagerInstance.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.cyan.withOpacity(0.3),
              child: Center(
                child: IconButton(
                    icon: Icon(
                      Icons.skip_next,
                      color: Colors.white,
                    ),
                    onPressed: () => audioManagerInstance.next()),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget songProgress(BuildContext context) {
    var style = TextStyle(color: Colors.black);
    return Row(
      children: <Widget>[
        Text(
          Time.formatDuration(audioManagerInstance.position),
          style: style,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbColor: Colors.blueAccent,
                  overlayColor: Colors.blue,
                  thumbShape: RoundSliderThumbShape(
                    disabledThumbRadius: 5,
                    enabledThumbRadius: 5,
                  ),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 10,
                  ),
                  activeTrackColor: Colors.blueAccent,
                  inactiveTrackColor: Colors.grey,
                ),
                child: Slider(
                  inactiveColor: Colors.blue.withAlpha(100),
                  activeColor: Colors.blue,
                  min: 0.0,
                  max: audioManagerInstance.duration.inSeconds.toDouble() + 1.0,
                  value: audioManagerInstance.position.inSeconds.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      _slider = value;
                    });
                  },
                  onChangeEnd: (value) {
                    if (audioManagerInstance.duration != null) {
                      Duration msec = Duration(
                          milliseconds:
                              (audioManagerInstance.duration.inMilliseconds *
                                      value)
                                  .round());
                      audioManagerInstance.seekTo(msec);
                    }
                  },
                )),
          ),
        ),
        Text(
          Time.formatDuration(audioManagerInstance.duration),
          style: style,
        ),
      ],
    );
  }

  void listener() {
    _animationController = new AnimationController(
      duration: new Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    );

    _searchFocusNode.addListener(() {
      if (!_animationController.isAnimating) {
        _animationController.forward();
      }
    });

    _searchTextController.addListener(_performSearch);

    this.setState(() {
      _search = musicStore.searchbySong(BaseConstant.BEATLES);
      _searchTextInProgress = BaseConstant.BEATLES;
    });
  }

  void internet() {
    InternetU.isConnected().then((internet) {
      if (!internet) {
        AlertHandler.showAlert(context, BaseConstant.CHECK_YOUR_INTERNET,
            BaseConstant.KEY_INTERNET);
      }
    });
  }

  void setupAudio() {
    audioManagerInstance.onEvents((events, args) {
      switch (events) {
        case AudioManagerEvents.start:
          _slider = 0;
          setState(() {});

          break;
        case AudioManagerEvents.ready:
          print("ready to play");
          setState(() {});
          // if you need to seek times, must after AudioManagerEvents.ready event invoked
          // AudioManager.instance.seekTo(Duration(seconds: 10));
          break;
        case AudioManagerEvents.seekComplete:
          _slider = audioManagerInstance.position.inMilliseconds /
              audioManagerInstance.duration.inMilliseconds;
          setState(() {});
          print("seek event is completed. position is [$args]/ms");
          break;
        case AudioManagerEvents.buffering:
          print("buffering $args");
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = audioManagerInstance.isPlaying;
          setState(() {});
          break;
        case AudioManagerEvents.timeupdate:
          _slider = audioManagerInstance.position.inMilliseconds /
              audioManagerInstance.duration.inMilliseconds;
          audioManagerInstance.updateLrc(args["position"].toString());
          setState(() {});
          break;
        case AudioManagerEvents.ended:
          audioManagerInstance.next();
          setState(() {});
          break;
        default:
          break;
      }
    });
  }

  _performSearch() {
    if (audioManagerInstance.isPlaying) {
      audioManagerInstance.stop();
    }
    final text = _searchTextController.text;
    if (_search != null && text == _searchTextInProgress) {
      return;
    }

    if (text.isEmpty) {
      this.setState(() {
        _search = null;
        _searchTextInProgress = null;
      });
      return;
    }

    this.setState(() {
      if (audioManagerInstance.isPlaying) {
        audioManagerInstance.stop();
      }

      _search = musicStore.searchbySong(text);
      _searchTextInProgress = text;
    });
  }

  _cancelSearch() {
    _searchTextController.clear();
    _searchFocusNode.unfocus();
    _animationController.reverse();
    this.setState(() {
      _search = null;
      _searchTextInProgress = null;
    });
  }

  _clearSearch() {
    _searchTextController.clear();
    this.setState(() {
      _search = null;
      _searchTextInProgress = null;
    });
  }

  @override
  dispose() async {
    if (_searchTextController != null) {
      _searchTextController.dispose();
    }
    if (audioManagerInstance.isPlaying) {
      audioManagerInstance.stop();
    }
    audioManagerInstance.release();
     _searchFocusNode.dispose();
    super.dispose();
  }
}
