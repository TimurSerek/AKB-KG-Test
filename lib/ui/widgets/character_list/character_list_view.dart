import 'package:akb_kg_test/library/widgets/inhereted_widget.dart';
import 'package:akb_kg_test/resources/app_colors.dart';
import 'package:akb_kg_test/resources/text_style.dart';
import 'package:akb_kg_test/shared/constants/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../data/model/species_model.dart';
import 'character_list_model.dart';

class CharacterListView extends StatefulWidget {
  const CharacterListView({Key? key}) : super(key: key);

  @override
  State<CharacterListView> createState() => _CharacterListViewState();
}

class _CharacterListViewState extends State<CharacterListView> {

  @override
  void initState() {
    super.initState();
    NotifierProvider.read<CharacterListViewModel>(context)
        ?.loadInitialCharacters();
  }

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<CharacterListViewModel>(context);
    if (model?.errorMessage != null) return Scaffold(body: Center(child: Text(model?.errorMessage ?? '')));
    if (model?.characters == null) return const Center(child: CircularProgressIndicator());
    return Scaffold(
      appBar: const _AppBarWidget(),
      body: Stack(
        children: const [
          _CharacterListWidget(),
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
    final model = NotifierProvider.read<CharacterListViewModel>(context);
    return AppBar(
      title: Center(child: Text(AppStrings.characters)),
      actions: [
        IconButton(onPressed: () {
          _showDialog(context, model);
        }, icon: const Icon(Icons.filter_alt_outlined)),
        const SizedBox(width: 20),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

Future<void> _showDialog(BuildContext context, CharacterListViewModel? model) async {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text(
          AppStrings.setupSearch, style: TextStyles.alertDialogTitle,)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                AppStrings.chooseSpecies, style: TextStyles.alertDialogItem,),
              const SizedBox(height: 10),
              Wrap(
                spacing: 4.0,
                runSpacing: 0.0,
                children: SpeciesChip.speciesList.map((speccy) {
                  return _ChoiceChipWidget(speccy: speccy, model: model);
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(AppStrings.applySettings),
            onPressed: () {
              model?.loadFilteredCharactersBySpecies();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(AppStrings.resetSettings),
            onPressed: () {
              model?.loadInitialCharacters();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(AppStrings.cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class _ChoiceChipWidget extends StatefulWidget {
  final String speccy;
  final CharacterListViewModel? model;

  const _ChoiceChipWidget({Key? key, required this.speccy, required this.model}) : super(key: key);

  @override
  State<_ChoiceChipWidget> createState() => _ChoiceChipWidgetState();
}

class _ChoiceChipWidgetState extends State<_ChoiceChipWidget> {
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(widget.speccy),
      onSelected: (isSelected) {
        setState((){
          _isSelected = isSelected;
        });
        widget.model?.addRemoveSpeccy(widget.speccy, _isSelected);
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(46)),
        side: BorderSide(
            color: AppColors.greyscale300,
            width: 1.0),
      ),
      selected: _isSelected,
      selectedColor: AppColors.blue600,
    );
  }
}

class _CharacterListWidget extends StatelessWidget {
  const _CharacterListWidget({
    Key? key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<CharacterListViewModel>(context);
    return ListView.builder(
        padding: const EdgeInsets.only(top: 70),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: model?.characters.length,
        itemExtent: 163,
        itemBuilder: (BuildContext context, int index) {
          model?.showNextCharacters(index);
          return _ItemListWidget(index: index,);
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
    final model = NotifierProvider.read<CharacterListViewModel>(context);
    final character = model?.characters[index];
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0, vertical: 10.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey),
              borderRadius:
              const BorderRadius.all(Radius.circular(10)),
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
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(character?.image ?? ''),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          character?.name ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          character?.status ?? '',
                          style: const TextStyle(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          character?.species ?? '',
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
              onTap: () => model?.onCharacterTap(context, index),
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
    final model = NotifierProvider.read<CharacterListViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onChanged: model?.searchCharacter,
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