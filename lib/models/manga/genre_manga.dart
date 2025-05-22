class GenreManga {
  final int malId;
  final String name;

  GenreManga({required this.malId, required this.name});

  factory GenreManga.fromJson(Map<String, dynamic> json) {
    return GenreManga(malId: json['mal_id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() => {'mal_id': malId, 'name': name};
}
