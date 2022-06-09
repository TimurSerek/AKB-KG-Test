import 'package:akb_kg_test/domain/api_client/episode_api_client.dart';
import 'package:akb_kg_test/domain/entity/episode_response.dart';

import '../domain/entity/episode.dart';

class EpisodeRepository {
  final _episodeApiClient = EpisodeApiClient();

  Future<EpisodeResponse> getInitialEpisodes() async =>
      _episodeApiClient.getInitialEpisodes();

  Future<EpisodeResponse> getNextEpisodes(String nextPage) async =>
      _episodeApiClient.getNextEpisodes(nextPage);

  Future<Episode> getEpisodeDetails(int index) async =>
      _episodeApiClient.getEpisodeDetails(index);

  Future<EpisodeResponse> searchEpisodeByName(String name) async =>
      _episodeApiClient.searchEpisodeByName(name);
}
