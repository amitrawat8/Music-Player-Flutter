import 'dart:async';
import 'dart:convert';

/**
 * Created by Amit Rawat on 15-06-2021
 */
import 'package:http/http.dart' as http;
import 'package:musicplayerdemo/src/constant/rest_constant.dart';
import 'package:musicplayerdemo/src/dto/results.dart';

class MusicClient {
  MusicClient({
    http.Client httpClient,
    this.baseUrl = RestConstant.SEARCH_URL,
  }) : this.httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final http.Client httpClient;

  Future<ServiceResponse> search(String term) async {
    final url = baseUrl +
        RestConstant.TERM +
        term +
        RestConstant.AND +
        RestConstant.ENTITY +
        RestConstant.SONG; //song
    final response = await httpClient.get(Uri.parse(url));
    final results = json.decode(response.body);

    if (response.statusCode == 200) {
      return ServiceResponse.fromJson(results);
    } else {
      throw ServiceResponse.fromJson(results);
    }
  }
}
