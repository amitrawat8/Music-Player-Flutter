import 'package:musicplayerdemo/src/dto/results.dart';

//Created by Amit Rawat on 15-06-2021
class MusicCache {
  final _cache = <String, ServiceResponse>{};

  ServiceResponse get(String term) => _cache[term];

  void set(String term, ServiceResponse result) => _cache[term] = result;

  bool contains(String term) => _cache.containsKey(term);

  void remove(String term) => _cache.remove(term);}
