//Created by Amit Rawat on 15-06-2021
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:musicplayerdemo/src/bloc/MusicSearchEvent.dart';
import 'package:musicplayerdemo/src/bloc/MusicSearchState.dart';
import 'package:musicplayerdemo/src/bloc/SearchResultError.dart';
import 'package:musicplayerdemo/src/repository/music_repository.dart';
import 'package:musicplayerdemo/src/constant/base_constant.dart';
import 'package:rxdart/rxdart.dart';

class MusicSearchBloc extends Bloc<MusicSearchEvent, MusicSearchState> {
  final MusicRepository musicRepository;

  MusicSearchBloc({@required this.musicRepository})
      : super(SearchStateEmpty());

  @override
  Stream<Transition<MusicSearchEvent, MusicSearchState>> transformEvents(
    Stream<MusicSearchEvent> events,
    Stream<Transition<MusicSearchEvent, MusicSearchState>> Function(
      MusicSearchEvent event,
    )
        transitionFn,
  ) {
    return events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(transitionFn);
  }

  @override
  Stream<MusicSearchState> mapEventToState(MusicSearchEvent event) async* {
    if (event is TextChanged) {
      final searchTerm = event.text;
      if (searchTerm.isEmpty) {
        yield SearchStateEmpty();
      } else {
        yield SearchStateLoading();
        try {
          final resMusic = await musicRepository.search(searchTerm);
          yield SearchStateSuccess(resMusic.results);
        } catch (error) {
          yield error is SearchResultError
              ? SearchStateError(error.message)
              : SearchStateError(BaseConstant.NO_DATA_FOUND_OR_CONNECTION);
        }
      }
    }
  }
}
