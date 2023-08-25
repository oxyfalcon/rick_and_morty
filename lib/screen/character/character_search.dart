import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/schema/enum.dart';
import 'package:app/Provider/api_character_provider.dart';
import 'package:app/Provider/local_provider.dart';

class SearchCharacter extends ConsumerStatefulWidget {
  const SearchCharacter({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchCharacterState();
}

class _SearchCharacterState extends ConsumerState<SearchCharacter> {
  Future openDialogCharacter(BuildContext context) {
    TextEditingController input = TextEditingController();
    final api = ref.read(apiCharacterProvider.notifier);
    CharacterItems items = ref.watch(characterProvider);
    return showAdaptiveDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                  onPressed: () {
                    items.name = input.text;
                    api.characterFilter();
                    Navigator.of(context).pop();
                    items.gender = CharacterGender.empty;
                    items.species = CharacterSpecies.empty;
                    items.status = CharacterStatus.empty;
                    input.text = "";
                    ref.watch(valueProvider.notifier).index = 1;
                  },
                  child: const Text("Save"),
                )
              ],
              title: const Text("Search"),
              leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                    items.gender = CharacterGender.empty;
                    items.species = CharacterSpecies.empty;
                    items.status = CharacterStatus.empty;
                    input.text = "";
                  }),
              centerTitle: false,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder()),
                    controller: input,
                  ),
                ),
                const Padding(
                    padding: EdgeInsets.all(8.0), child: GenderButton()),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: StatusButton(),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SpeciesButton(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => openDialogCharacter(context),
        icon: const Icon(Icons.search));
  }
}

class StatusButton extends ConsumerStatefulWidget {
  const StatusButton({super.key});

  @override
  ConsumerState<StatusButton> createState() => _StatusButtonState();
}

class _StatusButtonState extends ConsumerState<StatusButton> {
  @override
  Widget build(BuildContext context) {
    CharacterItems items = ref.watch(characterProvider);
    return SegmentedButton<CharacterStatus>(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: const <ButtonSegment<CharacterStatus>>[
        ButtonSegment(value: CharacterStatus.alive, label: Text("Alive")),
        ButtonSegment(value: CharacterStatus.dead, label: Text("Dead")),
        ButtonSegment(value: CharacterStatus.unknown, label: Text("Unknown")),
      ],
      selected: <CharacterStatus>{items.status},
      onSelectionChanged: (Set<CharacterStatus> selected) {
        setState(() {
          (selected.isNotEmpty)
              ? items.status = selected.first
              : items.status = CharacterStatus.empty;
        });
      },
    );
  }
}

class GenderButton extends ConsumerStatefulWidget {
  const GenderButton({super.key});

  @override
  ConsumerState<GenderButton> createState() => _GenderButtonState();
}

class _GenderButtonState extends ConsumerState<GenderButton> {
  @override
  Widget build(BuildContext context) {
    CharacterItems items = ref.watch(characterProvider);
    return SegmentedButton<CharacterGender>(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: const <ButtonSegment<CharacterGender>>[
        ButtonSegment(
            value: CharacterGender.male,
            label: Text("Male"),
            icon: Icon(Icons.male)),
        ButtonSegment(
            value: CharacterGender.female,
            label: Text("Female"),
            icon: Icon(Icons.female)),
        ButtonSegment(
            value: CharacterGender.unknown,
            label: Text("Unknown"),
            icon: Icon(Icons.error)),
      ],
      selected: <CharacterGender>{items.gender},
      onSelectionChanged: (Set<CharacterGender> select) {
        setState(() {
          (select.isNotEmpty)
              ? items.gender = select.first
              : items.gender = CharacterGender.empty;
        });
      },
    );
  }
}

class SpeciesButton extends ConsumerStatefulWidget {
  const SpeciesButton({super.key});

  @override
  ConsumerState<SpeciesButton> createState() => _SpeciesButtonState();
}

class _SpeciesButtonState extends ConsumerState<SpeciesButton> {
  @override
  Widget build(BuildContext context) {
    CharacterItems items = ref.watch(characterProvider);
    return SegmentedButton<CharacterSpecies>(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: const <ButtonSegment<CharacterSpecies>>[
        ButtonSegment(value: CharacterSpecies.alien, label: Text("Alien")),
        ButtonSegment(value: CharacterSpecies.human, label: Text("Human")),
      ],
      selected: <CharacterSpecies>{items.species},
      onSelectionChanged: (Set<CharacterSpecies> selected) {
        setState(() {
          (selected.isNotEmpty)
              ? items.species = selected.first
              : items.species = CharacterSpecies.empty;
        });
      },
    );
  }
}
