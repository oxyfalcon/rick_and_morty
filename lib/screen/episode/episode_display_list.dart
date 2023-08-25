import 'package:app/Provider/api_episode_provider.dart';
import 'package:app/schema/episode_schema.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DisplayEpisode extends ConsumerWidget {
  DisplayEpisode({super.key});
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    scrollController.addListener(() {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      final delta = MediaQuery.of(context).size.width * 0.20;
      if (maxScroll - currentScroll <= delta) {
        ref.watch(apiEpisodeProvider.notifier).getNextPage();
      }
    });
    final getList = ref.watch(apiEpisodeProvider);

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        getList.when(
            onGoingError: (items, e, stk) => CurrentEpisodeWidget(list: items),
            onGoingLoading: (items) => CurrentEpisodeWidget(list: items),
            data: (list) {
              if (list.isEmpty) {
                return SliverToBoxAdapter(
                    child: Center(
                  child: Text("No results",
                      style: Theme.of(context).textTheme.labelLarge),
                ));
              } else {
                return CurrentEpisodeWidget(
                  list: list,
                );
              }
            },
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                )),
        OnGoingWidget()
      ],
    );
  }
}

class CurrentEpisodeWidget extends StatelessWidget {
  const CurrentEpisodeWidget({super.key, required this.list});

  final List<Episode> list;

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
            childCount: list.length,
            (context, index1) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpansionTile(
                            title: Text(list[index1].name),
                            subtitle: Text(DateFormat.yMMMMEEEEd()
                                .format(list[index1].created)),
                            children: [
                              for (int i = 0;
                                  i < list[index1].characters.length;
                                  i++)
                                Text(list[index1].characters[i])
                            ],
                          ),
                        ],
                      )),
                )));
  }
}

class OnGoingWidget extends ConsumerWidget {
  const OnGoingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.read(apiEpisodeProvider);
    return SliverToBoxAdapter(
      child: list.maybeWhen(
        orElse: () => const SizedBox.shrink(),
        onGoingLoading: (items) {
          if (!ref.read(apiEpisodeProvider.notifier).finished) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(
              child: Text("All Done"),
            );
          }
        },
        onGoingError: (items, e, stk) => Center(child: Text(e.toString())),
      ),
    );
  }
}
