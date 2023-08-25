import 'package:flutter/material.dart';
import 'package:app/my_homepage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
            useMaterial3: true),
        title: "Rick And Morty",
        home: const Material(child: MyHomePage()),
      ),
    );
  }
}
