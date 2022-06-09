import 'package:flutter/material.dart';

import '../../../library/widgets/inhereted_widget.dart';
import 'character_details_model.dart';

class CharacterDetailsView extends StatefulWidget {
  const CharacterDetailsView({Key? key}) : super(key: key);

  @override
  State<CharacterDetailsView> createState() => _CharacterDetailsViewState();
}

class _CharacterDetailsViewState extends State<CharacterDetailsView> {

  @override
  void initState(){
    super.initState();
    NotifierProvider.read<CharacterDetailsViewModel>(context)?.getCharacterDetails();
  }

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<CharacterDetailsViewModel>(context);
    final characterDetails = model?.characterDetails;
    if (model?.errorMessage != null) return Scaffold(body: Center(child: Text(model?.errorMessage ?? '')));
    if (characterDetails == null) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: AppBar(
        title:  Text(characterDetails.name),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(characterDetails.image),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(characterDetails.name),
            const SizedBox(
              height: 10.0,
            ),
            Text(characterDetails.species),
          ],
        ),
      ),
    );
  }
}

