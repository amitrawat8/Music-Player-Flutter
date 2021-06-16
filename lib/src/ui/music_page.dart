import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicplayerdemo/src/bloc/MusicSearchBloc.dart';
import 'package:musicplayerdemo/src/bloc/MusicSearchEvent.dart';
import 'package:musicplayerdemo/src/bloc/MusicSearchState.dart';
import 'package:musicplayerdemo/src/constant/base_constant.dart';
import 'package:musicplayerdemo/src/ui/music_widget/bottom_widget.dart';
import 'package:musicplayerdemo/src/ui/music_widget/song_widget.dart';
import 'package:musicplayerdemo/src/util/alert_handler.dart';
import 'package:musicplayerdemo/src/util/internet_detect.dart';
import 'package:provider/provider.dart';

import '../constant/base_constant.dart';
import '../lib/cupertino_search_bar.dart';

var audioManagerInstance = AudioManager.instance;
bool showVol = false;
PlayMode playMode = audioManagerInstance.playMode;
bool isPlaying = false;

var songPosition = 0;

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
  String _searchTextInProgress;
  MusicSearchBloc _githubSearchBloc;

  @override
  initState() {
    super.initState();
    _githubSearchBloc = context.read<MusicSearchBloc>();
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
                      child: GestureDetector(onTapUp: (TapUpDetails _) {
                        _searchFocusNode.unfocus();
                        if (_searchTextController.text == '') {
                          _animationController.reverse();
                        }
                      }, child: BlocBuilder<MusicSearchBloc, MusicSearchState>(
                        builder: (context, state) {
                          if (state is SearchStateLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is SearchStateError) {
                            return Center(child: Text(state.error));
                          }
                          if (state is SearchStateSuccess) {
                            return state.items.isEmpty
                                ? Center(child: Text('No Results'))
                                : SongWidget(songList: state.items);
                          }
                          return Center(
                              child: Text('Please enter a term to begin'));
                        },
                      )),
                    ),
                    BottomWidget(),
                  ],
                ),
              ),
            )));
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
    if (_githubSearchBloc != null) {
      _githubSearchBloc.add(const TextChanged(text: BaseConstant.BEATLES));
    }

    this.setState(() {
      _searchTextInProgress = BaseConstant.BEATLES;
    });
  }

  void internet() {
    InternetDetect.isConnected().then((internet) {
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
          print("start to play");
          setState(() {});

          break;
        case AudioManagerEvents.ready:
          print("ready to play");
          Navigator.pop(context);
          setState(() {});
          // if you need to seek times, must after AudioManagerEvents.ready event invoked
          // AudioManager.instance.seekTo(Duration(seconds: 10));
          break;
        case AudioManagerEvents.seekComplete:
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
    if (text == _searchTextInProgress) {
      return;
    }

    if (text.isEmpty) {
      this.setState(() {
        _searchTextInProgress = null;
      });
      return;
    }
    _githubSearchBloc.add(
      TextChanged(text: text),
    );
    this.setState(() {
      if (audioManagerInstance.isPlaying) {
        audioManagerInstance.stop();
      }

      _searchTextInProgress = text;
    });
  }

  _cancelSearch() {
    _searchTextController.clear();
    _searchFocusNode.unfocus();
    _animationController.reverse();
    _githubSearchBloc.add(const TextChanged(text: ''));
    this.setState(() {
      _searchTextInProgress = null;
    });
  }

  _clearSearch() {
    _searchTextController.clear();
    _githubSearchBloc.add(const TextChanged(text: ''));
    this.setState(() {
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
