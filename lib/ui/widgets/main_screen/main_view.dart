import 'package:akb_kg_test/shared/constants/app_strings.dart';
import 'package:akb_kg_test/ui/widgets/episode_list/episode_list_view.dart';
import 'package:flutter/material.dart';

import '../../../library/widgets/inhereted_widget.dart';
import '../character_list/character_list_model.dart';
import '../character_list/character_list_view.dart';
import '../episode_list/episode_list_model.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final characterListModel = CharacterListViewModel();
  final episodeListModel = EpisodeListViewModel();
  int _selectedTab = 0;

  void onSelectedTab(int index){
    if(_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTab,
        children: [
          NotifierProvider(model: characterListModel,
          child: const CharacterListView()),
          NotifierProvider(model: episodeListModel,
              child: const EpisodeListView()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.list), label: AppStrings.characters),
          BottomNavigationBarItem(icon: const Icon(Icons.movie), label: AppStrings.episodes),
        ],
        onTap: onSelectedTab,
      ),
    );
  }
}
