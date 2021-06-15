import 'package:flutter/cupertino.dart';

//Created by Amit Rawat on 15-06-2021

class SearchResultError {
  const SearchResultError({@required this.message});

  final String message;

  static SearchResultError fromJson(dynamic json) {
    return SearchResultError(
      message: json['message'] as String,
    );
  }
}