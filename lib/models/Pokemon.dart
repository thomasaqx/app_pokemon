import 'package:poke_app/models/Sprites.dart';

class Pokemon {

  final String name;
  final List<String> types;
  final String? mainSprite;
  final Sprites sprites;

  Pokemon({required this.name, required this.types, required this.mainSprite, required this.sprites});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      types: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
      mainSprite: json['sprites']['other']['official-artwork']['front_default'],
      sprites: Sprites.fromJson(json['sprites']),
    );
  }
}
