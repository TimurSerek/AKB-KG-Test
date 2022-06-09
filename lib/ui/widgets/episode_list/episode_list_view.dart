import 'package:akb_kg_test/library/widgets/inhereted_widget.dart';
import 'package:akb_kg_test/shared/constants/app_strings.dart';
import 'package:flutter/material.dart';

import 'episode_list_model.dart';

class EpisodeListView extends StatefulWidget {
  const EpisodeListView({Key? key}) : super(key: key);

  @override
  State<EpisodeListView> createState() => _EpisodeListViewState();
}

class _EpisodeListViewState extends State<EpisodeListView> {
  @override
  void initState() {
    super.initState();
    NotifierProvider.read<EpisodeListViewModel>(context)?.loadInitialEpisodes();
  }

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<EpisodeListViewModel>(context);
    if (model?.errorMessage != null) return Scaffold(body: Center(child: Text(model?.errorMessage ?? '')));
    if (model?.episodes == null) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: const _AppBarWidget(),
      body: Stack(
        children: const [
          _EpisodeListWidget(),
          _SearchWidget(),
        ],
      ),
    );
  }
}

class _AppBarWidget extends StatelessWidget with PreferredSizeWidget {
  const _AppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(child: Text(AppStrings.episodes)),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _EpisodeListWidget extends StatelessWidget {
  const _EpisodeListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<EpisodeListViewModel>(context);
    return ListView.builder(
        padding: const EdgeInsets.only(top: 70),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: model?.episodes.length,
        itemExtent: 163,
        itemBuilder: (BuildContext context, int index) {
          model?.showNextEpisodes(index);
          return _ItemListWidget(
            index: index,
          );
        });
  }
}

class _ItemListWidget extends StatelessWidget {
  const _ItemListWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<EpisodeListViewModel>(context);
    final character = model?.episodes[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          character?.name ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          character?.airDate ?? '',
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Episode ${character?.episode}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: () => model?.onEpisodeTap(context, index),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<EpisodeListViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onChanged: model?.searchEpisode,
        decoration: InputDecoration(
          labelText: AppStrings.search,
          filled: true,
          fillColor: Colors.white.withAlpha(325),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
