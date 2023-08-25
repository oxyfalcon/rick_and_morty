import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:app/Provider/local_provider.dart';

class ItemList extends StatelessWidget {
  const ItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Consumer(
                  builder: (context, ref, value) =>
                      ref.watch(selectingSearchProvider)),
            ],
          ),
        ),
        Expanded(
            child: Consumer(
                builder: (context, ref, value) =>
                    ref.watch(selectingDisplayProvider))),
      ],
    );
  }
}
