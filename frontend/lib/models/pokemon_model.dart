class PokemonModel {
  final int id;
  final String name;
  final int height;
  final int weight;
  final List<String> types;
  final String imageUrl;

  PokemonModel({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.types,
    required this.imageUrl,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      types: List<String>.from(json['types']),
      imageUrl: json['image_url'],
    );
  }
}