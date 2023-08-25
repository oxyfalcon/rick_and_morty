import 'package:flutter/material.dart';

class CharacterDisplayPage extends StatelessWidget {
  const CharacterDisplayPage({super.key, required this.itr});

  final dynamic itr;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Character Display"),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: SafeArea(
        child: Column(children: [
          Expanded(child: Image.network(itr.image)),
          Expanded(
            flex: 2,
            child: SizedBox.expand(
              child: Center(
                child: Text(itr.name),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
