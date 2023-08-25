import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/schema/enum.dart';
import 'package:app/Provider/local_provider.dart';

class SearchEpisode extends ConsumerStatefulWidget {
  const SearchEpisode({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchEpisodeState();
}

class _SearchEpisodeState extends ConsumerState<SearchEpisode> {
  Future openDialogEpisodes(BuildContext context) {
    TextEditingController episodeName = TextEditingController();
    return showAdaptiveDialog(
        context: context,
        builder: (context) => Dialog.fullscreen(
              child: SafeArea(
                  child: Scaffold(
                appBar: AppBar(
                  centerTitle: false,
                  title: const Text("Search"),
                  leading: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close)),
                ),
                body: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: episodeName,
                      decoration: const InputDecoration(
                          hintText: "Episode Name",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const SeasonSelectionButton(),
                      TextButton(
                          onPressed: () => ref
                              .read(selectedEpisodeProvider.notifier)
                              .removeAll(),
                          child: const Text("Clear"))
                    ],
                  ),
                  const EpisodeListTiles()
                ]),
              )),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => openDialogEpisodes(context),
        icon: const Icon(Icons.search));
  }
}

class SeasonSelectionButton extends ConsumerStatefulWidget {
  const SeasonSelectionButton({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SeasonSelectionButtonState();
}

class _SeasonSelectionButtonState extends ConsumerState<SeasonSelectionButton> {
  SeasonNumber number = SeasonNumber.empty;

  @override
  Widget build(BuildContext context) {
    var seasonNumber = ref.watch(seasonProvider);

    return SegmentedButton<SeasonNumber>(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: const <ButtonSegment<SeasonNumber>>[
        ButtonSegment(value: SeasonNumber.S01, label: Text("S01")),
        ButtonSegment(value: SeasonNumber.S02, label: Text("S02")),
        ButtonSegment(value: SeasonNumber.S03, label: Text("S03")),
        ButtonSegment(value: SeasonNumber.S04, label: Text("S04")),
        ButtonSegment(value: SeasonNumber.S05, label: Text("S05")),
      ],
      selected: <SeasonNumber>{seasonNumber},
      onSelectionChanged: (Set<SeasonNumber> selected) {
        SeasonNumber temp;
        (selected.isNotEmpty)
            ? temp = selected.first
            : temp = SeasonNumber.empty;
        ref.watch(seasonProvider.notifier).changeSeasonNumber(temp);
        ref.watch(episodeProvider.notifier).changeEpisodeList(temp);
      },
    );
  }
}

class EpisodeListTiles extends ConsumerStatefulWidget {
  const EpisodeListTiles({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EpisodeListTilesState();
}

class _EpisodeListTilesState extends ConsumerState<EpisodeListTiles> {
  @override
  Widget build(BuildContext context) {
    List<EpisodeNumber> list = ref.watch(episodeProvider);
    var currentSeasonNumber = ref.watch(seasonProvider);
    var selectedEpisode = ref.watch(selectedEpisodeProvider);
    var selectedEpisodeState = ref.watch(selectedEpisodeProvider.notifier);
    return Expanded(
      child: ListView(
        children: [
          for (var i in list)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CheckboxListTile.adaptive(
                selected: selectedEpisode[currentSeasonNumber]!.contains(i),
                value: selectedEpisode[currentSeasonNumber]!.contains(i),
                selectedTileColor: Theme.of(context)
                    .copyWith(
                        colorScheme:
                            ColorScheme.fromSeed(seedColor: Colors.greenAccent))
                    .colorScheme
                    .inversePrimary,
                onChanged: (value) {
                  setState(() {
                    (value!)
                        ? selectedEpisodeState.addEpisode(i)
                        : selectedEpisodeState.removeEpisode(i);
                  });
                },
                title: Text(i.name),
              ),
            ),
        ],
      ),
    );
  }
}
