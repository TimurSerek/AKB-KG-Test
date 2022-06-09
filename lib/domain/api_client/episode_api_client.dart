
import 'package:akb_kg_test/domain/entity/episode_response.dart';

import '../../configuration/configuration.dart';
import '../entity/episode.dart';
import 'network_client.dart';

class EpisodeApiClient {
  final _networkClient = NetworkClient();

  Future<EpisodeResponse> getInitialEpisodes() async {
    EpisodeResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = EpisodeResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      Configuration.urlGetEpisode,
      parser,
    );
    return result;
  }

  Future<EpisodeResponse> getNextEpisodes(String nextPage) async {
    EpisodeResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = EpisodeResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      nextPage,
      parser,
    );
    return result;
  }

  Future<Episode> getEpisodeDetails(int index) async {
    Episode parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = Episode.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      '${Configuration.urlGetEpisode}$index',
      parser,
    );
    return result;
  }

  Future<EpisodeResponse> searchEpisodeByName(String name) async {
    EpisodeResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = EpisodeResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
        Configuration.urlGetEpisode,
        parser,
        <String, dynamic>{
          'name': name
        }
    );
    return result;
  }
}