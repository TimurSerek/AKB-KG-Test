import 'package:akb_kg_test/library/widgets/inhereted_widget.dart';
import 'package:flutter/material.dart';

import '../ui/widgets/character_details/character_details_model.dart';
import '../ui/widgets/character_details/character_details_view.dart';
import '../ui/widgets/character_list/character_list_view.dart';
import '../ui/widgets/episode_details/episode_details_model.dart';
import '../ui/widgets/episode_details/episode_details_view.dart';
import '../ui/widgets/episode_list/episode_list_view.dart';
import '../ui/widgets/main_screen/main_view.dart';

abstract class MainNavigationRouteNames {
  static const mainScreen = '/';
  static const characterList = '/character_list';
  static const characterDetails = '/character_list/character_details';
  static const episodeList = '/episode_list';
  static const episodeDetails = '/episode_list/episode_details';
}

class MainNavigation {
  String initialRoad() => MainNavigationRouteNames.mainScreen;
  final routes = <String, Widget Function(BuildContext)>{
    '/': (context) => const MainView(),
    '/character_list': (context) => const CharacterListView(),
    '/character_list/character_details': (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      final characterId = arguments is int ? arguments : 0;
      return NotifierProvider(
        model: CharacterDetailsViewModel(characterId),
        child: const CharacterDetailsView(),
      );
    },
    '/episode_list': (context) => const EpisodeListView(),
    '/episode_list/episode_details': (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      final episodeId = arguments is int ? arguments : 0;
      return NotifierProvider(
        model: EpisodeDetailsViewModel(episodeId),
        child: const EpisodeDetailsView(),
      );
    },
  };
}
