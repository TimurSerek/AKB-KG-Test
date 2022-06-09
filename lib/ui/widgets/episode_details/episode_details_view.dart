import 'package:flutter/material.dart';

import '../../../library/widgets/inhereted_widget.dart';
import 'episode_details_model.dart';

class EpisodeDetailsView extends StatefulWidget {
  const EpisodeDetailsView({Key? key}) : super(key: key);

  @override
  State<EpisodeDetailsView> createState() => _EpisodeDetailsViewState();
}

class _EpisodeDetailsViewState extends State<EpisodeDetailsView> {

  @override
  void initState(){
    super.initState();
    NotifierProvider.read<EpisodeDetailsViewModel>(context)?.getEpisodeDetails();
  }

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<EpisodeDetailsViewModel>(context);
    final episodeDetails = model?.episodeDetails;
    if (model?.errorMessage != null) return Scaffold(body: Center(child: Text(model?.errorMessage ?? '')));
    if (episodeDetails == null) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(
        title:  Text(episodeDetails.name),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100.0,
            ),
            Text(episodeDetails.name),
            const SizedBox(
              height: 10.0,
            ),
            Text(episodeDetails.airDate),
            const SizedBox(
              height: 10.0,
            ),
            Text(episodeDetails.episode),
          ],
        ),
      ),
    );
  }
}

