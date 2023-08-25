import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/schema/enum.dart';
import 'package:app/Provider/api_location_provider.dart';
import 'package:app/Provider/local_provider.dart';

class SearchLocation extends ConsumerStatefulWidget {
  const SearchLocation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchLocationState();
}

class _SearchLocationState extends ConsumerState<SearchLocation> {
  Future openDialogLocation(BuildContext context) {
    TextEditingController locationName = TextEditingController();
    TextEditingController dimensionName = TextEditingController();
    final api = ref.read(apiLocationProvider.notifier);
    LocationItems items = ref.watch(locationProvider);
    return showAdaptiveDialog(
        context: context,
        builder: (context) => Dialog.fullscreen(
              child: SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    centerTitle: false,
                    title: const Text("Search"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            items.name = locationName.text;
                            items.dimension = dimensionName.text;
                            api.locationFilter();
                            Navigator.of(context).pop();
                            locationName.text = "";
                            dimensionName.text = "";
                          },
                          child: const Text("Save"))
                    ],
                    leading: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                          locationName.text = "";
                          dimensionName.text = "";
                        }),
                  ),
                  body: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: const InputDecoration(
                              hintText: "Location Name",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder()),
                          controller: locationName,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: const InputDecoration(
                              hintText: "Dimension Name",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder()),
                          controller: dimensionName,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => openDialogLocation(context),
        icon: const Icon(Icons.search));
  }
}
