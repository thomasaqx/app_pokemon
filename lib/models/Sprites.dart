class Sprites {
  final String? frontDefault;
  final String? backDefault;
  final String? frontShiny;
  final String? backShiny;
  Sprites({
    this.frontDefault,
    this.backDefault,
    this.frontShiny,
    this.backShiny,
  });
  factory Sprites.fromJson(Map<String, dynamic> json) {
    return Sprites(
      frontDefault: json['front_default'],
      backDefault: json['back_default'],
      frontShiny: json['front_shiny'],
      backShiny: json['back_shiny'],
    );
  }
  // Retorna todas as imagens não nulas em uma lista
  List<String> get allImages {
    return [
      frontDefault,
      backDefault,
      frontShiny,
      backShiny,
    ].whereType<String>().toList();
  }
}
