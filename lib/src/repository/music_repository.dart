import 'package:musicplayerdemo/src/dto/results.dart';
import 'package:musicplayerdemo/src/network/music_client.dart';

import '../network/music_cache.dart';

//Created by Amit Rawat on 15-06-2021

class MusicRepository {
  const MusicRepository(this.cache, this.client);

  final MusicCache cache;
  final MusicClient client;

  Future<ServiceResponse> search(String term) async {
    final cachedResult = cache.get(term);
    if (cachedResult != null) {
      return cachedResult;
    }
    final result = await client.search(term);
    cache.set(term, result);
    return result;
  }
}
