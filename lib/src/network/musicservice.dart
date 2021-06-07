import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:musicplayerdemo/src/constant/rest_constant.dart';
import 'package:musicplayerdemo/src/dto/results.dart';
/**
 * Created by Amit Rawat on 05-06-2021
 */

class AppleMusicStore {
  AppleMusicStore._privateConstructor();

  static final AppleMusicStore instance = AppleMusicStore._privateConstructor();

  Future<dynamic> fetchJSON(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<ServiceResponse> searchDefaultList(String query) async {
    final url = RestConstant.SEARCH_URL +
        RestConstant.TERM +
        query +
        RestConstant.AND +
        RestConstant.ENTITY +
        RestConstant.SONG; //song
    /* "$_SEARCH_URL?types=artists&term=$query";*/

    final json = await fetchJSON(url);
    final List<Results> songs = [];

    final resultCount = json[RestConstant.RESULT_COUNT];
    final songJSON = json[RestConstant.RESULT];
    if (songJSON != null) {
      songs.addAll((songJSON as List).map((a) => Results.fromJson(a)));
    }
    return ServiceResponse(resultCount: resultCount, results: songs);
    //  completer.complete(songs);
    //  return completer.future;
  }

  Future<ServiceResponse> searchbySong(String query) async {
    //var completer = new Completer();

    final url = RestConstant.SEARCH_URL +
        RestConstant.TERM +
        query +
        RestConstant.AND +
        RestConstant.ENTITY +
        RestConstant.SONG; //song

    final json = await fetchJSON(url);
    final List<Results> songs = [];

    final resultCount = json[RestConstant.RESULT_COUNT];
    final songJSON = json[RestConstant.RESULT];
    if (songJSON != null) {
      songs.addAll((songJSON as List).map((a) => Results.fromJson(a)));
    }
    return ServiceResponse(resultCount: resultCount, results: songs);
  }

  Future<ServiceResponse> search(String query) async {
    final url = RestConstant.SEARCH_URL +
        RestConstant.TYPES +
        "artists" +
        RestConstant.AND +
        RestConstant.TERM +
        query;
    final json = await fetchJSON(url);
    final List<Results> songs = [];

    final resultCount = json[RestConstant.RESULT_COUNT];
    final songJSON = json[RestConstant.RESULT];
    if (songJSON != null) {
      songs.addAll((songJSON as List).map((a) => Results.fromJson(a)));
    }
    return ServiceResponse(resultCount: resultCount, results: songs);
  }
}
