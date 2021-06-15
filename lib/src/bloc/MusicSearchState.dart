import 'package:equatable/equatable.dart';
import 'package:musicplayerdemo/src/dto/results.dart';

//Created by Amit Rawat on 15-06-2021

abstract class MusicSearchState extends Equatable {
  const MusicSearchState();

  @override
  List<Object> get props => [];
}

class SearchStateEmpty extends MusicSearchState {}

class SearchStateLoading extends MusicSearchState {}

class SearchStateSuccess extends MusicSearchState {
  const SearchStateSuccess(this.items);

  final List<Results> items;

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

class SearchStateError extends MusicSearchState {
  const SearchStateError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}