import 'package:common/src/methods/queries/audios_query.dart';
import 'package:on_audio_query_platform_interface/on_audio_query_platform_interface.dart';

class FakeOnAudioQuery {
  Future<List<AudioModel>> queryAudios(List files) async {
    return AudiosQuery().queryAudios(
      filter: MediaFilter.forAudios(),
    );
  }
}
