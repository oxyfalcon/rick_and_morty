import 'package:app/Provider/api_location_provider.dart';
import 'package:app/Provider/local_provider.dart';
import 'package:app/schema/location_schema.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DisplayLocation extends ConsumerWidget {
  DisplayLocation({super.key});
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    scrollController.addListener(() {
      final maxScroll = scrollController.position.maxScrollExtent;
      final currentScroll = scrollController.position.pixels;
      final delta = MediaQuery.of(context).size.width * 0.20;
      if (maxScroll - currentScroll <= delta) {
        ref.watch(apiLocationProvider.notifier).getNextPage();
      }
    });
    final getList = ref.watch(apiLocationProvider);

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        getList.when(
            onGoingError: (items, e, stk) =>
                CurrentLocationWidget(listLocation: items),
            onGoingLoading: (items) =>
                CurrentLocationWidget(listLocation: items),
            data: (locationList) {
              if (locationList.isEmpty) {
                return SliverToBoxAdapter(
                    child: Center(
                  child: Text("No results",
                      style: Theme.of(context).textTheme.labelLarge),
                ));
              } else {
                return CurrentLocationWidget(
                  listLocation: locationList,
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

class CurrentLocationWidget extends StatelessWidget {
  const CurrentLocationWidget({super.key, required this.listLocation});

  final List<Location> listLocation;

  @override
  Widget build(BuildContext context) {
    print("CurrentLocationWidget build");
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: listLocation.length,
        (context, indexLocation) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer(builder: (context, ref, value) {
                      print("rebuilding");
                      var results = ref.watch(allCharacterFromLocationProvider);
                      return ExpansionTile(
                        title: Text(listLocation[indexLocation].name),
                        subtitle: Text(DateFormat.yMMMMEEEEd()
                            .format(listLocation[indexLocation].created)),
                        onExpansionChanged: (value) {
                          (value)
                              ? ref
                                  .watch(
                                      allCharacterFromLocationProvider.notifier)
                                  .allCharactersInLocation(
                                      listLocation[indexLocation])
                              : null;
                        },
                        children: [
                          results.when(
                            data: (listCharacter) => (listCharacter.isNotEmpty)
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: listCharacter.length,
                                    itemBuilder: (context, indexCharacter) =>
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              title: Text(
                                                  listCharacter[indexCharacter]
                                                      .name),
                                              subtitle: Text(
                                                  listCharacter[indexCharacter]
                                                      .status),
                                              leading: Image.network(
                                                  listCharacter[indexCharacter]
                                                      .image),
                                            ),
                                          )),
                                        ))
                                : const SizedBox(
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        "No Characters",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                            error: (error, stackTrace) => Center(
                              child: Text(error.toString()),
                            ),
                            loading: () => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                )),
          );
        },
      ),
    );
  }
}

class OnGoingWidget extends ConsumerWidget {
  const OnGoingWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.read(apiLocationProvider);
    return SliverToBoxAdapter(
      child: list.maybeWhen(
        orElse: () => const SizedBox.shrink(),
        onGoingLoading: (items) {
          if (!ref.read(apiLocationProvider.notifier).finished) {
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
