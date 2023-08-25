import 'package:app/schema/character_schema.dart';

class Location {
  Location({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.residents,
    required this.url,
    required this.created,
  });

  final int id;
  final String name;
  final String type;
  final String dimension;
  final List<String> residents;
  final String url;
  final DateTime created;

  factory Location.empty() => Location(
      id: 0,
      name: "",
      type: "",
      dimension: "",
      residents: [],
      url: "",
      created: DateTime.now());

  List<Character> allCharacterPresentInLocation = <Character>[];
  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        dimension: json["dimension"],
        residents: List<String>.from(json["residents"].map((x) => x)),
        url: json["url"],
        created: DateTime.parse(json["created"]),
      );
}
