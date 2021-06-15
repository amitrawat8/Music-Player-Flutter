import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
//Created by Amit Rawat on 15-06-2021
abstract class MusicSearchEvent extends Equatable {
  const MusicSearchEvent();
}

class TextChanged extends MusicSearchEvent {
  const TextChanged({@required this.text});

  final String text;

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'TextChanged { text: $text }';
}